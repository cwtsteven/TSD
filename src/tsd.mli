open Heteroset

type 'a graph

(* liftings *)
val lift : 'a -> 'a graph


(* core for ssd *)
val peek : 'a graph -> 'a 
val apply : ('a -> 'b) graph -> 'a graph -> 'b graph
val ifthenelse : bool graph -> (unit -> 'a graph) -> (unit -> 'a graph) -> 'a graph
val cell : 'a graph -> 'a graph 
val link : 'a graph -> 'a graph -> unit
val (<~) : 'a graph -> 'a graph -> unit
val set : 'a graph -> 'a -> unit
val (<:=) : 'a graph -> 'a -> unit 
val put : 'a graph -> 'a -> unit
val (<:~) : 'a graph -> 'a -> unit 
val init : unit -> unit 
val step : unit -> bool 