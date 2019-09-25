open Tsd

let (+) = lift (+)

let signal =
	let%tsd s = cell 1 in 
	s <~ s + 1; s

let rsum i = 
	let%tsd s = cell 0 in 
	s <~ s + i; s

let o = rsum signal 


let _ = (*
	let n = int_of_string Sys.argv.(1) in  	*)
	let n = 10 in 
	print_int (peek o); print_newline();
	for i = 1 to n do 
		step();
		print_int (peek o); print_newline()
	done