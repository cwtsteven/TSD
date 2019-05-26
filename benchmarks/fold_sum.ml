open Tsd
open List

let (+^) = lift (+) 

let rec createList n init = 
	match n with
	| 0 -> [], []
	| n -> let input_v = cell (lift init) in 
		   let xs, ys = createList (n-1) init in 
		   input_v :: xs, if n mod 1000 == 0 then input_v :: ys else ys

let rec stabilise () = 
	if step() then stabilise () else () 

let _ =
	let n = int_of_string Sys.argv.(1) in 
	let ins, ins' = createList n 1 in 
	let out = fold_left (fun acc i -> cell [%dfg i +^ acc]) (lift 0) ins in 
	List.map (fun i -> set i 2) ins';
	stabilise (); 
	out (*print_int (peek out); print_newline()*)