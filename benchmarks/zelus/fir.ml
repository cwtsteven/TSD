(* The Zélus Hybrid Synchronous language compiler, version 1.3.0
  (Sun 16 Sep 09:45:15 CEST 2018) *)
type continuous = { mutable pos: float; mutable der: float }
type zerocrossing = { mutable zin: bool; mutable zout: float }
type 'a signal = 'a * bool
type zero = bool
type ('a) list = Cons | Nil  
