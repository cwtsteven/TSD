open Tsd
open List

let (+^) = lift (+) 

let createList n init total = 
	let rec aux n init acc = 
	match n with
	| 0 -> acc
	| n -> let input_v = cell (lift init) in 
		   aux (n-1) init (if n mod total/1000 == 0 then input_v :: acc else acc) 
    in 
    aux n init []

let rec stabilise () = 
	if step() then stabilise () else () 

let _ =
	let n = int_of_string Sys.argv.(1) in 
	let ins' = createList n 0 n in 
	List.map (fun i -> set i 1) ins'; 
	stabilise (); 
	(*ins; List.iter (fun i -> print_int (v i); print_newline()) outs*) 