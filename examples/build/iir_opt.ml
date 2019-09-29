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
  let rec aux x init n =
    match n with 
    | 0 -> lift []
    | n -> let s = delay x init in
           let ss = aux s init (n-1) in 
           [%dfg (lift cons) s ss]
  in 
  let ss = aux x init n in 
  [%dfg (lift cons) x ss]

let chain init n = 
  let rec aux x init n =
    match n with 
    | 0 -> lift [], [] 
    | n -> let s = delay x init in
           let ss, cs = aux s init (n-1) in 
           [%dfg (lift cons) s ss], s :: cs
  in 
  aux (lift init) init n

let rec dot_prod xs ys = 
  match xs, ys with
  | [], [] -> 0.0
  | x :: xs, y :: ys -> let sum = dot_prod xs ys in x *. y +. sum

let iir x ffws fbws = 
  let forwards = delayN x (length ffws - 1) 0.0 in 
  let f_sum = [%dfg (lift dot_prod) (lift ffws) forwards] in 
  match fbws with 
  | [] -> f_sum 
  | a0 :: []  -> [%dfg f_sum /^ (lift a0)] 
  | a0 :: fbws -> 
    let backwards, cs = chain 0.0 (length fbws) in 
    let b_sum = [%dfg (lift dot_prod) (lift fbws) backwards] in 
    let sum = [%dfg (f_sum -^ b_sum) /^ (lift a0)] in 
    link (hd cs) sum; sum 


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
