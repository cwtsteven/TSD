let main = let mem = Primes.main_alloc () in fun _ -> Primes.main_step mem ();;


let _ = 
	for i = 1 to 100 do main () done; 