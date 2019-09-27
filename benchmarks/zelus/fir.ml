(* The Zélus Hybrid Synchronous language compiler, version 1.3.0
  (Sun 16 Sep 09:45:15 CEST 2018) *)
type continuous = { mutable pos: float; mutable der: float }
type zerocrossing = { mutable zin: bool; mutable zout: float }
type 'a signal = 'a * bool
type zero = bool
let f x_13 =
  (+) x_13 1

let apply f_14 x_15 =
  f x_15

type applynode = unit

let applynode_alloc () = ()
let applynode_reset self  =
  ()


let applynode_step self f_16 x_17 =
  f x_17

let applynode = applynode_alloc, applynode_step, applynode_reset
