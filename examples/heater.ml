open Tsd

let low = lift 4
let high = lift 4

let delay_on = lift 500 (* in miliseconds *)
let delay_off = lift 100

let (&&) = lift (&&)
let (||) = lift (||)
let not = lift not 
let (+) = lift (+)
let (-) = lift (-) 

let count d t r = 
	let (==) = lift (==) in 
	let cpt = cell d in 
	let ok = [%dfg cpt == 0] in
	cpt <~ [%dfg if r then d else if t && not ok then cpt - 1 else cpt];
	ok 

let edge x r = 
	let s = cell [%dfg false] in 
	let pre_x = cell x in 
	s <~ [%dfg not r || (not pre_x && x)]; s  

let heat expected_temp actual_temp =  
	let (<=) = lift (<=) and (>=) = lift (>=) in
	[%dfg actual_temp <= expected_temp - low || not (actual_temp >= expected_temp + high)] 

type _command = Open | Silent

let command millisecond r = 
	let (==) = lift (==) in 
	let cmd = cell [%dfg Silent] in 
	let on_count = count delay_on [%dfg millisecond && cmd == Open] [%dfg r || cmd == Silent] in 
	let off_count = count delay_off [%dfg millisecond && cmd == Silent] [%dfg r || cmd == Open] in 

	cmd <~ [%dfg if r then Silent 
				 else if cmd == Open then (if on_count then Silent else Open) 
				 else if off_count then Open else Silent]; 

	[%dfg (cmd == Open, cmd == Open)] 

type _light = Light_off | Light_on | Try | Failure 

let light millisecond on_heat on_light r =
	let (==) = lift (==) and fst = lift fst and snd = lift snd in  
	let state = cell [%dfg Light_off] in 
	let cmd = command millisecond r in 
    let nok = [%dfg state == Failure] in 
    let open_light = [%dfg if state == Try then fst cmd else false] in 
    let open_gas = [%dfg if state == Try then snd cmd 
    					 else if state == Light_on then true 
    					 else false] in
    let error_count = count (lift 3) (edge [%dfg not open_light] r) [%dfg r || state == Try] in 
	
	state <~ [%dfg if r then Light_off 
				   else if state == Light_off then (if on_heat then Try else Light_off) 
				   else if state == Light_on then (if not on_heat then Light_off else Light_on) 
				   else if state == Try then (if on_light then Light_on else if error_count then Failure else Try)
				   else Failure]; 
	[%dfg ((open_light, open_gas), nok)] 

let main millisecond restart expected_temp actual_temp on_light =
	let snd = lift snd in 
	let on_heat = heat expected_temp actual_temp in 
	let output = light millisecond on_heat on_light restart in 
	let ok = [%dfg not (snd output)] in 
	[%dfg output, ok]






