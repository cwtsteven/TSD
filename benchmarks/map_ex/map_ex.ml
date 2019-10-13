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
	let ins, ins' = createList n 0 in 
	let outs = map (fun i -> cell [%dfg i +^ 1]) ins in 
	List.map (fun i -> set i 1) ins';
	stabilise (); 
	outs (*List.iter (fun i -> print_int (v i); print_newline()) outs*) 