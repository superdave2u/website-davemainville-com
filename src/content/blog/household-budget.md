---
title: 'Equitable, Not Equal: Building a Household Budget Splitter'
description: 'Most bill-splitting tools assume everyone pays the same share. I built Household Budget for the households where that assumption breaks — splits proportional to income, per-paycheck contributions, and the three-paycheck month handled correctly.'
pubDate: 'Oct 18 2024'
heroImage: '/project/household-budget.svg'
tags: ['vue', 'javascript', 'personal-finance', 'side-projects']
---

Split a $1,800 mortgage between two roommates and "everyone pays $900" sounds fair — until one earns $95k and the other earns $45k. Equal isn't always fair. For households where incomes don't match — roommates, partners, family members pooling for a mortgage — an **equitable** split proportional to income is often the arrangement that actually works.

That's the problem [Household Budget](https://budget.davemainville.com/) solves. It's live on its own domain, with [the source on GitHub](https://github.com/superdave2u/household-budget-tracker).

## The experience

The app has three moving parts. First you add the **People**: a name and a yearly salary, and the app immediately shows each person's share of household income. Then the **Bills**: a name, an amount, a frequency, and — the whole point — a split option:

- **Evenly**: the bill divides by headcount, the classic 50/50 (or 33/33/33 with three roommates).
- **Equitably**: the bill divides by income, so someone earning 60% of the household income carries 60% of that bill.

Each bill gets its own split option, because real households are mixed — a streaming service might split evenly while the mortgage splits by income. The **Budgets** view then rolls it all up: each person's monthly contribution, and what they owe *per paycheck*.

That per-pay number is my favorite detail. If your household is paid bi-weekly, two months a year contain a third paycheck — and budgets that ignore that "overpopulate" their categories those months, exactly as I noted in the [project README](https://github.com/superdave2u/household-budget-tracker). Household Budget computes per-pay contributions from the actual pay frequency, so every deposit matches reality.

And because this is financial data, it's **local-first**: everything lives in your browser's localStorage. No account, no server, no analytics. The Data view exports your setup as text you can copy to a clipboard (or paste back in on another device).

## The technology

I built it with **Vue 3** and **Vuetify** on **Vite**, with **Pinia** managing the state. The whole domain model lives in one small store:

- A `household` store holds `people` and `bills`, with getters for total income and total bills, persisted to `localStorage` so data survives refreshes without a backend.
- The equitable split is one honest line of math: each person's share is `their salary / household income × bill amount`, while an even split is simply `bill amount / number of people`.
- Frequencies are first-class: monthly and bi-weekly bills map to per-pay contribution calculations rather than naive monthly averages.
- The UI leans on Vuetify's data tables and dialogs for People, Bills, and Budgets, with a sidebar layout and responsive behavior for mobile.
- A single GitHub Actions workflow deploys the built app to GitHub Pages behind the `budget.davemainville.com` custom domain.

## What it taught me

The interesting engineering in this app isn't the framework — it's refusing the default assumption. Nearly every split-the-bill tool on the market is built around equal shares, and the moment a household's income is uneven, those tools stop being useful. Modeling the *real* arrangement — per-person income, per-bill split rules, per-paycheck deposits — is what made this one worth building.

If you've ever split a mortgage or rent unevenly on a spreadsheet and resented updating it every month, [give Household Budget a try](https://budget.davemainville.com/).
