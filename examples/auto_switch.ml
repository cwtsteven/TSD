open Tsd 

let delay_on = lift 10 (* in miliseconds *)
let delay_off = lift 5

let (&&) = lift (&&)
let not = lift not 
let (-) = lift (-) 


let count d t r = 
	let (==) = lift (==) in 
	let cpt = cell d in 
	let ok = [%dfg cpt == 0] in
	cpt <~ [%dfg if r then d else if t && not ok then cpt - 1 else cpt];
	ok 

type _command = Open | Silent

let command millisecond = 
	let (==) = lift (==) in 
	let cmd = cell [%dfg Silent] in 
	let on_count = count delay_on [%dfg millisecond && cmd == Open] [%dfg cmd == Silent] in 
	let off_count = count delay_off [%dfg millisecond && cmd == Silent] [%dfg cmd == Open] in 

	cmd <~ [%dfg if cmd == Open 
				 then (if on_count then Silent else Open) 
				 else (if off_count then Open else Silent)]; 

	[%dfg (cmd == Open, cmd == Open)] 

let _ = 
	let cmd = command [%dfg true] in 
	Printf.printf "cmd\t cmd\t";
	for i = 1 to 100 do 
		let (a,b) = peek cmd in
		Printf.printf "%b\t %b\t" a b;
		step();
	done; 
