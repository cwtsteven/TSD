let main = let mem = Alt_sum.main_alloc () in fun _ -> Alt_sum.main_step mem ();;


let _ = 
	for i = 1 to 100 do main () done; 