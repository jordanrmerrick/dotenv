module P :
  sig
    type t
      
    val to_string : t -> Base.string
    val of_string : Base.string -> t
      
    val read : Base.string -> t Base.list
        
    val parse : t -> (t * t) Base.option
        
    val excluder : (t * t) Base.option Base.list -> (t * t) Base.list
        
  end
  
type ('a, 'b) t = ('a, 'b) Base.Hashtbl.t
    
val to_t : 'a -> 'a
val of_t : 'a -> 'a
  
val of_p : P.t * P.t -> Base.string * Base.string
                                        
val init : Base.string -> (Base.string * Base.string) Base.List.t
    
val create : Base.string -> (Base.String.t, Base.string) Base.Hashtbl.t
    
val export : Base.string -> unit
  
val get : (Base.string, 'a) Base.Hashtbl.t -> Base.string -> 'a option
    
val get_exn : (Base.string, 'a) Base.Hashtbl.t -> Base.string -> 'a
