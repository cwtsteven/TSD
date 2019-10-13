let main = let mem = Light_control.main_alloc () in fun _ -> Light_control.main_step mem ();;


let _ = 
	let n = int_of_string Sys.argv.(1) in 
	for i = 1 to n do main () done; 