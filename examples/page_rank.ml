open Tsd
open List 

let rec stepN n = 
	match n with 
	| 0 -> false
	| n -> step(); stepN (n-1)

let rec dot_prod xs ys = 
	match xs, ys with
	| [], [] -> 0.0
	| x :: xs, y :: ys -> x *. y +. dot_prod xs ys 

let rec replicate init n = 
	match n with
	| 0 -> [] 
	| n -> init :: replicate init (n-1)

let page_rank hs n =
	let init = replicate (1.0 /. float_of_int (length hs)) (length hs) in 
	let rs = cell (lift init) in 
	rs <~ [%dfg (lift map) (fun h -> (lift dot_prod) h rs) (lift hs)]; 
	stepN n;
	peek rs

let _ =
	let hs = [[0.0;0.0;0.25;0.0;0.0]; 
			  [1.0;0.0;0.25;0.0;0.0]; 
			  [0.0;0.0;0.0;0.5;0.0]; 
			  [0.0;0.0;0.25;0.0;1.0]; 
			  [0.0;1.0;0.25;0.5;0.0]] in 
	let rs = page_rank hs 10 in 
	iter (fun n -> print_float n; print_newline()) rs