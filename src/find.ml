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

open! Unix
open! Stdio

(* 
  Can't use Base here because it hides Sys.readdir and Sys.getcwd ()... kind of a nuisance.
*)

module H = struct

  let of_char_list ls =
    let str = Buffer.create (List.length ls) in
    List.iter (Buffer.add_char str) ls; Buffer.contents str
  
end


module Walker = struct

  let is_env s =
    (* This method is quite dirty but this is checking only for .env, so we just need to check the last 4 characters*)
    let len = String.length s in
    let rec loop acc l s =
      match l with
      | _ when l = len - 5  -> acc
      | x -> loop (s.[x]::acc) (x-1) s
    in
    loop [] (len-1) s |> H.of_char_list |> fun s -> s = ".env"

    
  let child () =
    let rec walk acc = function
      | [] -> acc
      | hd::tl ->
        let contents = Array.to_list (Sys.readdir hd) |> List.rev_map (Filename.concat hd) in
        let d, f =
          List.fold_left (fun (dir, file) f ->
              match (stat f).st_kind with
              | S_REG -> (dir, f::file)
              | S_DIR -> (f::dir, file)
              | _ -> (dir, file)
            ) ([], []) contents
        in
        walk (List.append f acc) (List.append d tl)

    in
    walk [] [Sys.getcwd ()]

  let search () = child () |> List.find is_env
     
      
end

exception No_env_file

let find () = Walker.search ()


