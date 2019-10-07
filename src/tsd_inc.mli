open Heteroset

type 'a graph

val create_thunk : (unit -> 'a) -> 'a graph

(* liftings *)
val lift : 'a -> 'a graph


(* core for tsd *)
val peek : 'a graph -> 'a 
val root : 'a graph -> 'a graph 
val apply : ('a -> 'b) graph -> 'a graph -> 'b graph
val ifthenelse : bool graph -> (unit -> 'a graph) -> (unit -> 'a graph) -> 'a graph
val cell : 'a graph -> 'a graph 
val link : 'a graph -> 'a graph -> unit
val (<~) : 'a graph -> 'a graph -> unit
val assign : 'a graph -> 'a -> unit
val (<:=) : 'a graph -> 'a -> unit 
val set : 'a graph -> 'a -> unit
val (<:~) : 'a graph -> 'a -> unit 
val init : unit -> unit 
val step : unit -> bool 