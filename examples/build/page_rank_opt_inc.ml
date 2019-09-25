open Tsd_inc
open List

let rec zip xs ys = 
  match (xs, ys) with 
  | [], [] -> []
  | x :: xs, y :: ys -> (x, y) :: zip xs ys 

let (+^) = lift (+.)
let (-^) = lift (-.)
let ( *^ ) = lift ( *. )
let ( /^ ) = lift ( /. )

let rec stepN n = 
  match n with 
  | 0 -> false
  | n -> step(); stepN (n-1)

let rec create_cells n init = 
  match n with
  | 0 -> (lift [], []) 
  | n -> let s = cell (lift init) in let ss, cs = create_cells (n-1) init in [%dfg (lift cons) s ss], (s :: cs)

let rec dot_prod xs ys = 
  match xs, ys with
  | [], [] -> 0.0
  | x :: xs, y :: ys -> let sum = dot_prod xs ys in x *. y +. sum

let page_rank hs n =
  let rs, gs = create_cells (length hs) (1.0 /. float_of_int (length hs)) in 
  iter (fun (h, r) -> link r [%dfg (lift dot_prod) (lift h) rs]) (zip hs gs); 
  stepN n;
  map peek gs

let _ =
  let hs = [[0.0;0.0;0.25;0.0;0.0]; 
            [1.0;0.0;0.25;0.0;0.0]; 
            [0.0;0.0;0.0;0.5;0.0]; 
            [0.0;0.0;0.25;0.0;1.0]; 
            [0.0;1.0;0.25;0.5;0.0]] in 
  let rs = page_rank hs 10 in 
  iter (fun n -> print_float n; print_newline()) rs 
