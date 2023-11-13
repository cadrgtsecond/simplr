# Simplr
> The live link is at [simplr.fly.dev](https://simplr.fly.dev)

A website to find simpler alternative to popular projects

Our technology stacks are getting exceedingly complex. We are using either absurdly overpowered, pointlessly bleeding-edge technologies when simpler alternatives exist already. This is a website that provides people with simpler alternatives to common technologies we use.

> NOTE: All data is stored in [data/ALTERNATIVES.md](data/ALTERNATIVES.md). It is currently quite limited. If you wish to extend it, please send a pull request!

## Running it
### With Docker
```bash
docker build -t simplr .
docker run -p <local-port>:5000 simplr
```

### In prod
This project uses [Roswell](https://roswell.github.io/) for its startup script

Install Roswell and run

```bash
ros start.ros
```

And it should start up a Woo server on port 5000.

### In debug
You can load it up like any other project from the repl with `simplr.asd`

```lisp
* (push #p"./" asdf:*central-registry*)
* (ql:quickload :simplr)
* (in-package :simplr)
* (start <server-options>)
```

`<server-options>` are passed to `clack:clackup`

## Technologies used
### Frontend
- [HTMX](https://htmx.org): for a simple Hypermedia-driven UI

### Backend
- Common Lisp: Because Alien technology is cool and minimal
  - [clack](https://github.com/fukamachi/clack) and [ningle](https://github.com/fukamachi/ningle) for the web framework
  - [ten](https://github.com/mmontone/ten) For templating
  - [libcmark](https://commonmark.org/) and its Lisp bindings [cl-cmark](https://github.com/HiPhish/cl-cmark) for parsing Markdown
  - iterate, str, and cl-ppcre: Common utility libraries for doing iteration, strings, and regex respectively
- SQLite. We only use it to efficiently query the read-only data loaded from Markdown. A proper SQL server would have too much overhead

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

## TODO:
- Use Nix for reproducibility instead of Docker
- Add more technologies
