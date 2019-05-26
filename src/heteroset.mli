type t
val empty : t
val add : 'a -> t -> t
val remove : 'a -> t -> t
val singleton : 'a -> t
val union : t -> t -> t
val fold : ('a -> 'b -> 'a) -> 'a -> t -> 'a 
val iter : ('a -> unit) -> t -> unit 
