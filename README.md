# Dotenv

## A lightweight dotenv library for OCaml

## How to Use It

There are 2 ways to access your env file.

1. Call `Env.create` to initialize an `Env.t`. You can access your variables by calling `Env.get` or `Env.get_exn`.

2. Call `Env.export` to export your .env file to the Unix environment. You can access your variables by calling `Unix.getenv`.

You may also use `Env.find ()` to dynamically find your .env file within your executing directory or any of its child directories.

## Todo

 - [ ] Adding a lexer to process variables and output them as strings, ints, floats, etc. Currently, all variables are initialized as strings.

 - [x] Add an automatic .env file finder (should search all child directories from execution dir)