open Tsd

let state_machine init transition input =
	let state = cell [%dfg (lift init)] in 
	state <~ [%dfg (lift transition) state input ]; 
	state 

let alt = state_machine 1 (fun s _ -> 1 - s) (lift 0)

let sum inp = 
  state_machine 0 (fun s i -> i + s) inp

let alt_sum = sum alt 

let _ = 
	(*let n = int_of_string Sys.argv.(1) in *)
	print_int (peek alt_sum); print_newline();
	for i = 1 to 10 do 
		step();
		print_int (peek alt_sum); print_newline()
	done