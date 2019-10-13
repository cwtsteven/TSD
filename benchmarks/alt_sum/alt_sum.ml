open Tsd

let state_machine init trans input = 
	let init = lift init and trans = lift trans in 
	let state = cell [%dfg init] in 
	state <~ [%dfg trans state input]; 
	state 

let alt = state_machine 1 (fun s _ -> 1 - s) (lift 0) 

let sum inp = state_machine 0 (fun s i -> i + s) inp

let alt_sum = sum alt 


let _ = 
  let n = int_of_string Sys.argv.(1) in 
  for i = 1 to n do
    step();
  done