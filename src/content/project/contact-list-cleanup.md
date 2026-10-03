---
title: 'Contact List Cleanup'
description: 'A Python utility that safely purged 15,000 imported records from my Google Contacts while keeping genuine personal connections.'
heroImage: '../../../public/project/contact-list-cleanup.svg'
relatedPosts: ['contact-list-cleanup']
---

**Contact List Cleanup** is a Python program built to finally tackle my Google Address Book: after importing roughly 15,000 student records from a leadership community I volunteer with, messaging apps connected me with strangers from the database. The tool deletes the database noise while keeping the records of genuine friends.

**[Source on GitHub](https://github.com/superdave2u/contact-list-cleanup)**

## Highlights

- **Data-quality criteria:** keep records with multiple phone numbers, multiple labels, or labeled phone numbers — signals that separate personal contacts from imported database rows.
- **Chain of Responsibility:** each keep-criterion is a handler in a chain; any handler can spare a record from deletion, and new criteria drop in without touching existing logic.
- **Rate-limiting Decorator:** Google People API calls wrapped with a decorator that paces them under the 90-calls-per-minute limit — replacing reactive exponential backoff (sawtooth spikes and 429 bursts) with a smooth, steady call rate.
- **Python + Google People API**, with metric charts of the before/after API behavior documented in the README.
