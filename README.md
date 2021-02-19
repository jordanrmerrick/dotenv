# Dotenv

## A lightweight dotenv library for OCaml

## How to Use It

`Env.create` initializes an `Env.t` from the .env file you import via its filename. `Env.t` is a key value list.
This is used in conjunction with `Env.get` and `Env.get_exn`, both of which can be used to find values from the associated key.

`Env.export` adds the env variables to the environment, allowing you to access them via `Sys.getenv`.

## Todo

 - [ ] Adding a lexer to process variables and output them as strings, ints, floats, etc. Currently, all variables are initialized as strings.

