open! Base
open! Stdio
open! Path

type ('a, 'b) t = ('a, 'b) Base.Hashtbl.t

val create : Base.string -> (Base.String.t, Base.string) Base.Hashtbl.t
val export : Base.string -> unit
val get : (Base.string, 'a) Base.Hashtbl.t -> Base.string -> 'a option
val get_exn : (Base.string, 'a) Base.Hashtbl.t -> Base.string -> 'a
val find : unit -> string
