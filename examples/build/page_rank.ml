open Tsd
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
	| 0 -> []
	| n -> let s = cell (lift init) in s :: create_cells (n-1) init


let rec dot_prod xs ys = 
	match xs, ys with
	| [], [] -> lift 0.0
	| x :: xs, y :: ys -> let sum = dot_prod xs ys in [%dfg (lift x) *^ y +^ sum] 

let page_rank hs n =
	let rs = create_cells (length hs) (1.0 /. float_of_int (length hs)) in 
	iter (fun (h, r) -> link r (dot_prod h rs)) (zip hs rs); 
	stepN n;
	map peek rs

let _ =
	let hs = [[0.0;0.0;0.25;0.0;0.0]; 
			  [1.0;0.0;0.25;0.0;0.0]; 
			  [0.0;0.0;0.0;0.5;0.0]; 
			  [0.0;0.0;0.25;0.0;1.0]; 
			  [0.0;1.0;0.25;0.5;0.0]] in 
	let rs = page_rank hs 10 in 
	iter (fun n -> print_float n; print_newline()) rs