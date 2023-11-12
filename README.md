# Simplr
The live link is at [simplr.fly.dev](https://simplr.fly.dev)

A website to find simpler alternative to popular projects

Our technology stacks are getting exceedingly complex. We are using either absurdly overpowered, pointlessly bleeding-edge technologies when simpler alternatives exist already. This is a website that provides people with simpler alternatives to common technologies we use.

> NOTE: All data is stored in [data/ALTERNATIVES.md](data/ALTERNATIVES.md). It is currently quite limited. If you wish to extend it, please send a pull request!

## Rationale
Abolish the Cargo Cult. Do not overengineer. Keep it simple

## Example
Here is a tech stack: React, React Redux, Tailwindcss, GraphQL, Stripe, Flask for a Backend API, for a courses app

You probably do not need React. Even really advanced frontends don't need such things. A courses app is very CRUD-y Page-y and very much suited to a Hypermedia approach. But since full page reloads are annoying and we want a more rich UI, [htmx](https://htmx.org) can be added. You probably don't need Redux in the first place. And if it is REALLY needed, you can use svelte. Unless you have a Mobile App, you probably don't need GraphQL and a seperate Backend. Just serve the HTML directly as a frontend from the database(Like good ol' PHP and Ruby on Rails). Tailwindcss is a necessity but you might look into [UnoCSS](https://unocss.dev/). Stripe is basically a necessity in this case. So the answer is

```
- React, React Redux
  + HTMX
    ... Reasons to consider
    ... Also cons
  + Svelte
    ... Reasons to consider
    ... Also cons to consider
- GraphQL
x Tailwindcss
  x UnoCSS
x Stripe
```

Initially, it will show you all alternatives but you can select what is absolutely necessary and what even you think is pointless and it will adjust the results

## The tech stack of THIS website
The website is written in Common Lisp. Lisp is basically 7 functions handed down to John McCarthy by Aliens. The database is SQLite since it removes the need for a seperate database system. The database isn't updated at all and is only used to query the data(Stored in data/ALTERNATIVES.md) efficiently. For this avoiding a round trip to the database as SQLite is embedded is the best option

## TODO:
- Use Nix for reproducibility instead of Docker
- Improve active search
- Make UI more friendly
- Add more technologies
