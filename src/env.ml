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

open! Base
open! Stdio

module P : sig

  type t
    
  val to_string : t -> string
  val of_string : string -> t

  val read : string -> t list

  val parse : t -> (t * t) option

  val excluder : (t * t) option list -> (t * t) list

end = struct

  type t = string

  let to_string t = t
  let of_string t = t

  let read filename = In_channel.read_lines filename
            
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

type t = (string * string) list
    
let to_t t = t
let of_t t = t

let of_p (k, v) = (P.to_string k, P.to_string v) |> to_t

let create filename =
  let open P in 
  read filename |> List.map ~f:parse |> excluder |> List.map ~f:of_p

let export filename =
  create filename |> List.iter ~f:(fun (k, v) -> Unix.putenv k v)

let get (env : t) (key : string) =
  List.Assoc.find ~equal:String.(=) env key

let get_exn (env : t) (key : string) =
  List.Assoc.find_exn ~equal:String.(=) env key