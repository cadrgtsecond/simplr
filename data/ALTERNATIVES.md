# Alternatives
This is the markdown file that contains all of the actual information. Each level 2 heading under this file corresponds to a piece of software and the first paragraph corresponds to the strengths of some technology. e.g

```
react:+20 graphql:-20
```

means that when React is present in the stack, add 20 to the score and when GraphQL is present, subtract 20 from the score.

To set an initial score, add `self:initialScore` to the strengths eg. `#vite self:+20`

> IMPORTANT: Ensure that scores are always less than 100 and more than -100 regardless of the technologies selected

> NOTE: This is just a regular integer(parsed with `parse-integer`) so you could also write `react:20` but always use a `+` for readability

The second paragraph is `Stylized name: long description...`(Currently the stylized name is just added to the description). Then it is followed by a list of reasons `- reason -- options`(Not implemented yet)

Just read the rest of the file

## react
frontend:only self:-20

React: The library for web and native user interfaces

## htmx
frontend:only backend:only self:+80 graphql:-40

HTMX: An extension of HTML as a hypermedia to build modern web apps with the simplicity of hypermedia

## svelte
frontend:only self:+40 graphql:+10

Svelte: Cybernetically enhanced web apps with a compact, simple, and complete Javascript framework(that even handles css!)

## graphql
api:only self:+20

GraphQL: GraphQL is a query language for APIs and a runtime for fulfilling those queries with your existing data.

## c
native:only self:-20

C: The most popular low-level programming language

## rust
native:only self:+65 very-low-level:-20

Rust: A language empowering everyone to build reliable and efficient software.

## zig
native:only self:+60

Zig: A general-purpose programming language and toolchain for maintaining robust, optimal and reusable software.
