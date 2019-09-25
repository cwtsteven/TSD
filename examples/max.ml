open Tsd


let (x, m) = 
	let max = lift max 
	let%tsd x = cell 1 in  
	and 	f = fun x -> max x 2 in 
	(x, f x)


let print_i i = print_int i; print_newline()

let _ =  
	print_i (peek m);
	step (); 
	print_i (peek m);
	x <~ [%tsd 3]; 
	step (); 
	print_i (peek m) 