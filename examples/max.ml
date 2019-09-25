open Tsd


let (x, m) = 
	let%tsd max' = lift (max) 
	and x = cell 1
	and y = cell 2
	and m = max' x y in 
	(x, m)



let print_i i = print_int i; print_newline()

let _ =  
	print_i (peek m);
	step (); 
	print_i (peek m);
	x <~ [%tsd 3]; 
	step (); 
	print_i (peek m) 