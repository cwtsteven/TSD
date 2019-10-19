open Tsd
open List

let (+^) = lift (+.)

let fir x fs = 
  let r, _ = fold_left (fun (sum,s) f -> [%dfg (lift f) s +^ sum], cell s) (lift 0.0, x) fs in 
  r


let print_f f = print_float f; print_newline()

let rec replicate n x = 
  match n with 
  | 0 -> []
  | n -> (fun y -> Random.float x *. y) :: replicate (n-1) x

let _ = 
  let p = 10 in 
  let n = 100 in 
  let example x = 
    fir x (replicate p 1.0) 
  in
  let input = 
    let s = cell (lift 0.0) in 
    link s [%dfg s +^ 1.0]; s 
  in 
  let out = example input in 
  print_f (peek out);
  for i = 1 to n do
    step();
    print_f (peek out);
  done 