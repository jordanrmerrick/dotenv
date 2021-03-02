open! Unix
    
module Walker : sig
  val is_env : string -> bool
  val child : unit -> string list
  val search : unit -> string
end
