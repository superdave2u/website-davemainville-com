---
title: 'Cleaning 15,000 Contacts with a Chain of Responsibility'
description: 'How a Google Contacts import broke my messaging apps, the criteria I used to tell friends from database records, and the design patterns — Chain of Responsibility and a rate-limiting Decorator — that made the cleanup safe and steady.'
pubDate: 'Oct 03 2026'
heroImage: '/project/contact-list-cleanup.svg'
tags: ['python', 'google-api', 'design-patterns', 'side-projects']
---

This project began as an excuse to learn Python by solving a real problem: my Google Address Book was a mess, and the mess had a cause. Years ago I imported roughly **15,000 student records** from a leadership development group I volunteer with, wanting quick access to phone numbers in an emergency. What I didn't account for was the blast radius: apps like WhatsApp and Facebook Messenger scan your device contacts to suggest connections — and suddenly my social apps were full of strangers from a database.

Worse, a manual batch delete was a non-starter for [the source on GitHub](https://github.com/superdave2u/contact-list-cleanup): during my time in that community I'd made genuine friendships, and those records were mixed into the same imported batch. I needed to delete most of 15,000 records while keeping the handful that were actually *mine*.

## The criteria for "keep"

Bulk import made the records easy to add, so I went looking for signals that separated personal contacts from database entries. Three criteria emerged:

1. If a record has **more than one phone number**, keep it.
2. If a record has **more than one label**, keep it.
3. If a record has a **labeled phone number** (Mobile, Work, Office), keep it.

Imported database rows are sparse — one number, one label, no annotation. Real relationships accumulate detail. With those criteria validated by hand, I wrote the code.

## Chain of Responsibility for the filters

The filtering fit the **Chain of Responsibility** pattern perfectly: pass each contact through a series of handlers, where any handler can claim the record ("skip this one — it looks personal") and stop the chain. An abstract handler defines `set_next` and pass-through logic; concrete handlers each encode one criterion:

```py
class PhoneNumberWithLabelHandler(AbstractHandler):
    def handle(self, contact):
        phone_numbers = contact.get("phoneNumbers", [])
        if any("contactGroupMembership" in phone for phone in phone_numbers):
            return ("Skipped", "Phone number has a label")
        return super().handle(contact)
```

The handlers chain together at composition time:

```py
def record_filters():
    multiple_phone_numbers_handler.set_next(multiple_labels_handler)
    phone_number_with_label_handler.set_next(multiple_phone_numbers_handler)
    return phone_number_with_label_handler
```

A record that survives every handler gets deleted; any handler that returns a result diverts it to the "kept" pile. Adding a new criterion later means writing one new handler and inserting it into the chain — nothing else changes.

## From reactive backoff to a rate-limiting Decorator

The cleanup talks to the Google People API, which enforces a rate limit (90 calls per minute). My first encounter with that limit was a `429` error, and my first fix was reactive: retry with exponential pause — 2 seconds, then 4, then 8.

It worked, sort of. The console output was exciting, but the API metrics told the real story: a sawtooth of call spikes followed by error bursts. I was slamming the ceiling, backing off, and slamming it again.

The better fix was to be *intentional* about pacing, and the **Decorator pattern** was the right tool — wrap the API call in a function that waits *only as long as needed* to stay under the limit:

```py
def rate_limited_calls_per_min(max_per_minute):
    min_interval = 60.0 / float(max_per_minute)

    def decorate(func):
        last_time_called = [0.0]

        @wraps(func)
        def rate_limited_function(*args, **kwargs):
            elapsed = time.perf_counter() - last_time_called[0]
            left_to_wait = min_interval - elapsed
            if left_to_wait > 0:
                time.sleep(left_to_wait)
            ret = func(*args, **kwargs)
            last_time_called[0] = time.perf_counter()
            return ret

        return rate_limited_function

    return decorate


@rate_limited_calls_per_min(90)
def delete_contact_api_call(service, contact_resource_name):
    service.people().deleteContact(resourceName=contact_resource_name).execute()
```

The key refactor was isolating the API call into its own function so that *only* the network call is timed. The result flipped the metrics chart from sawtooth to a smooth, steady trend line of calls — the API quota used efficiently instead of fought against.

## What it taught me

Two patterns, one lesson each. The Chain of Responsibility turned a tangle of "if" conditions into a pipeline I could reason about one criterion at a time — and the criteria themselves came from examining the data, not from guessing. The Decorator turned a reactive error handler into a proactive pacing mechanism, and the difference showed up immediately in the API dashboards.

I also learned something about myself as an engineer: the code has optimization opportunities left — the API interaction logic could be broken into more focused domain classes — and I've decided to leave it. *Enough to get the job done* is a legitimate final state for a learning project, and the reward is a clean address book after nearly a decade of ignoring the mess.

If you're curious, [the full README](https://github.com/superdave2u/contact-list-cleanup) includes the API metric charts that motivated the backoff-to-decorator switch.
