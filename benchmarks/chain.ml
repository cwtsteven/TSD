open Tsd

let (+) = lift (+) 

let rec createCells n x = 
	match n with 
	| 0 -> ()
	| n -> let c = cell [%dfg x + 1] in createCells (n - 1) c 

let rec stabilise () = 
	if step() then stabilise () else () 

let _ = 
	let n = int_of_string Sys.argv.(1) in 
	let x = cell [%dfg 0] in
	createCells n x;
	set x 1; 
	stabilise()
