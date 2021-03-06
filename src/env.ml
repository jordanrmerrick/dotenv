(*
Copyright 2021 Jordan Merrick

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

open! Stdio
open! Base
open! Path

module P : sig

  val read : ?filename:string -> unit -> string list

  val parse : string -> (string * string) option

  val excluder : (string * string) option list -> (string * string) list

end = struct

  let read ?(filename="") () =
    match filename with
    | ""      -> In_channel.read_lines ".env"
    | _ as fn -> In_channel.read_lines fn
            
  let parse s =
     String.strip s
     |> fun x ->
     if Char.(=) x.[0] '#' then
       None
     else
       String.lsplit2 ~on:'=' x
        
  let excluder ls =
    let rec aux acc ls =
      match ls with
      | []                -> acc
      | None::tl          -> aux acc tl
      | (Some (k, v))::tl -> aux ((k,v)::acc) tl
    in
    aux [] ls
      
end

type ('a, 'b) t = ('a, 'b) Hashtbl.t
    
let init filename =
  let open P in
  read ~filename () |> List.map ~f:parse |> excluder

let create filename =
  let handler x = match x with `Ok | `Duplicate -> () in
  let kv = Hashtbl.create (module String) in
  init filename |> List.iter ~f:(fun (k, v) -> handler (Hashtbl.add kv ~key:k ~data:v)); kv

let export filename =
  init filename |> List.iter ~f:(fun (k, v) -> Unix.putenv k v)

let get env (key : string) =
  Hashtbl.find env key
    
let get_exn env (key : string) =
  Hashtbl.find_exn env key

let find () =
  Path.Walker.search ()
