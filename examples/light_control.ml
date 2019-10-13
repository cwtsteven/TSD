open Tsd

let create_transducer init input transition outF = 
	let init = lift init and transition = lift transition and outF = lift outF in 
	let state = cell [%dfg init] in 
	state <~ [%dfg transition state input]; 
	[%dfg outF state] 

type light = On | Off

type command = Switch_on | Switch_off 

let transition state input = 
	match (state, input) with
	| On, Switch_off -> print_endline "Light off!\n"; Off
	| Off, Switch_on -> print_endline "Light on!\n"; On 
	| s, _ 			 -> s 

let _ =
	let input = cell [%dfg Switch_off] in
	let _ = create_transducer Off input transition (fun x -> x) in 
	print_endline "Enter 'switch_on' or 'switch_off' to switch on/off the light. \n";
	while true do 
		let cmd = read_line() in 
		match cmd with
		| "switch_on"  -> set input Switch_on; step(); ()
		| "switch_off" -> set input Switch_off; step(); ()
		| _ 		   -> print_endline "Wrong command. "
	done 