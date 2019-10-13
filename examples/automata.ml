open Tsd

let create_automaton init input trans finals = 
	let init = lift init and trans = lift trans and mem = lift List.mem and finals = lift finals in 
	let state = cell [%dfg init] in 
	state <~ [%dfg trans state input]; 
	(input, [%dfg mem state finals]) 

let run (input, _) data = List.iter (fun d -> set input d; step(); ()) data 

type state = S0 | S1 | S2 | S3

let finals = [S2] 

let transition state input = 
	match (state, input) with
	| S0, 'a' -> S1
	| S1, 'a' -> S2
	| S2, 'a' -> S3
	| s, _    -> s

let explode s =
  let rec exp i l =
   if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) [];;

let print_bool b = print_endline (if b then "true" else "false")

let _ = 
	let input = cell [%dfg 'a'] in 
	print_endline "This is an automaton that recognise a string with exactly 2 'a's. \n";
	while true do 
		let (ins, out) as automaton = create_automaton S0 input transition finals in 
		print_endline "Please enter a string:";
		let string = explode (read_line()) in 
		run automaton string;
		print_string "result: "; print_bool (peek out); print_newline()
	done