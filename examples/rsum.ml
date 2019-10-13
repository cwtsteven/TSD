open Tsd

let (+) = lift (+)

let signal =
	let s = cell [%dfg 1] in 
	s <~ [%dfg s + 1]; s

let rsum i = 
	let s = cell [%dfg 0] in 
	s <~ [%dfg s + i]; s

let o = rsum signal 


let _ = 
	let n = 10 in 
	print_int (peek o); print_newline();
	for i = 1 to n do 
		step();
		print_int (peek o); print_newline()
	done