open Tsd


let (x, m) = 
	let max = lift max in 
	let x = cell [%dfg 1] in 
	let f = [%dfg fun x -> max x 2] in 
	(x, [%dfg f x])


let print_i i = print_int i; print_newline()

let _ =  
	print_i (peek m);
	step (); 
	print_i (peek m);
	x <~ [%dfg 3]; 
	step (); 
	print_i (peek m) 