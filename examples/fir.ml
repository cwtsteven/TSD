open Tsd
open List

let (+^) = lift (+.)
let ( *^ ) = lift ( *. )

let delay x init = 
  let init = lift init in 
  let%tsd s = cell init in 
  s <~ x; s

let delayN x n init = 
  let rec aux x init n acc =
    match n with 
    | 0 -> acc
    | n -> let s = delay x init in
           aux s init (n-1) (s :: acc) 
  in
  rev_append (aux x init n [x]) [] 

let rec zip xs ys = 
  match (xs, ys) with 
  | [], [] -> []
  | x :: xs, y :: ys -> (x, y) :: zip xs ys 

let fir x fs = 
  let xs = delayN x (length ws - 1) 0.0 in 
  let fold_left = lift fold_left and zip = lift zip in 
  let%tsd r = fold_left (fun sum (f, s) -> sum +^ (lift f) s)) 0.0 (zip ws xs) in 
  r


let print_f f = print_float f; print_newline()

let rec replicate n x = 
  match n with 
  | 0 -> []
  | n -> Random.float x :: replicate (n-1) x

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