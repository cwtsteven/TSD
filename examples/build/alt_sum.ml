open Tsd

let state_machine init trans input = 
	let init = lift init and trans = lift trans in 
	let%dfg state = 1 in 
	(*state <~ trans state input; *)
	cell 1
(*

let alt = state_machine 1 (fun s _ -> 1 - s) (lift 0) 

let sum inp = 
  state_machine 0 (fun s i -> i + s) inp

let alt_sum = sum alt 

let _ = 
	print_int (peek alt_sum); print_newline();
	for i = 1 to 10 do 
		step();
		print_int (peek alt_sum); print_newline()
	done 
*)