module Inc = Incremental.Make ()
open Inc

let rec createGraph n x =  
	match n with 
	| 0 -> () 
	| n -> let c = Inc.map x ~f:(fun x -> x + 1) in createGraph (n - 1) c 

let _ =
	let n = int_of_string Sys.argv.(1) in 
	let input_v = Var.create 0 in 
	let input = Var.watch input_v in
	createGraph n input;
	Var.set input_v 1;
	Inc.stabilize ()