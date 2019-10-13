open Tsd
open List

let (+^) = lift (+.)
let (-^) = lift (-.)

let fir x fs =
  let f, fs = lift (hd fs), tl fs in 
  let i = [%dfg f x] in 
  let r, _ = fold_left (fun (sum,s) f -> let s = cell s in [%dfg (lift f) s +^ sum], s) (i, x) fs in 
  r

let iir x ffs bfs = 
  let b, bs = lift (hd bfs), tl bfs in 
  let y = fir x ffs in 
  let i = [%dfg b y] in 
  let r, _ = fold_left (fun (sum,s) b -> let s = cell s in [%dfg sum -^ (lift b) s], s) (i, y) bfs in 
  r 


let print_f f = print_float f; print_newline()

let rec replicate n x = 
  match n with 
  | 0 -> []
  | n -> (fun y -> Random.float x *. y) :: replicate (n-1) x

let _ = 
  let p = int_of_string Sys.argv.(1) in 
  let q = int_of_string Sys.argv.(2) in
  let n = int_of_string Sys.argv.(3) in 
  let example x = 
    iir x (replicate p 1.0) (replicate q 1.0)
  in
  let input = 
    let s = cell (lift 0.0) in 
    link s [%dfg s +^ 1.0]; s 
  in 
  let out = example input in 
  (*print_f (peek out);*)
  for i = 1 to n do
    step();
    (*print_f (peek out);*)
  done

