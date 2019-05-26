open Tsd

let create_transducer init input transition outF = 
	let state = cell [%dfg (lift init)] in 
	link state [%dfg (lift transition) state input]; 
	(input, [%dfg (lift outF) state]) 

type light = On | Off

type command = Switch_on | Switch_off

let rec run (input, out) f n = 
	match n with
	| 0 -> ()
	| n -> set input ((if Random.bool() then Switch_on else Switch_off)); step(); f (peek out); run (input, out) f (n - 1)

let transition state input = 
	match (state, input) with
	| On, Switch_off -> (*print_endline "Light off!";*) Off
	| Off, Switch_on -> (*print_endline "Light on!";*) On 
	| s, _ 			 -> s 

let _ =
	init();
	let n = int_of_string (Sys.argv.(1)) in 
	let input = cell [%dfg Switch_on] in
	let (ins, out) as transducer = create_transducer Off input transition (fun x -> x) in
	run transducer (fun x -> ()) n 