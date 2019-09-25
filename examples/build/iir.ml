open Tsd
open List

let (+^) = lift (+.)
let (-^) = lift (-.)
let ( *^ ) = lift ( *. )
let ( /^ ) = lift ( /. )

let delay x init = 
  let s = cell (lift init) in 
  link s x; s

let delayN x n init = 
  let rec aux x init n acc =
    match n with 
    | 0 -> acc
    | n -> let s = delay x init in
           aux s init (n-1) (s :: acc)
  in
  rev_append (aux x init n [x]) [] 

let chain init n = tl (delayN (lift init) n init)

let rec zip xs ys = 
  match (xs, ys) with 
  | [], [] -> []
  | x :: xs, y :: ys -> (x, y) :: zip xs ys

let iir x ffws fbws = 
  let forwards = delayN x (length ffws - 1) 0.0 in 
  let f_sum = fold_left (fun sum (w, s) -> [%dfg sum +^ (lift w) *^ s]) (lift 0.0) (zip ffws forwards) in 
  match fbws with 
  | [] -> f_sum 
  | a0 :: []  -> [%dfg f_sum /^ (lift a0)] 
  | a0 :: fbws -> 
    let backwards = chain 0.0 (length fbws) in 
    let b_sum = fold_left (fun sum (w, s) -> [%dfg sum +^ (lift w) *^ s]) (lift 0.0) (zip fbws backwards) in 
    let sum = [%dfg (f_sum -^ b_sum) /^ (lift a0)] in 
    link (hd backwards) sum; sum 


let print_f f = print_float f; print_newline()

let rec replicate n x = 
  match n with 
  | 0 -> []
  | n -> Random.float x :: replicate (n-1) x

let _ = (*
  let p = int_of_string Sys.argv.(1) in 
  let q = int_of_string Sys.argv.(2) in
  let n = int_of_string Sys.argv.(3) in *)
  let (p,q,n) = 10,10,100 in 
  let example x = 
    iir x (replicate p 1.0) (replicate q 1.0)
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

