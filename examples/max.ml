open Tsd


let max' = lift (max)

let x = cell [%dfg 1] 
let y = cell [%dfg 2]  
let m = [%dfg max' x y] 


let print_i i = print_int i; print_newline()

let _ =  
	print_i (peek m);
	step (); 
	print_i (peek m);
	link x [%dfg 3]; 
	step (); 
	print_i (peek m)