open Tsd

let (+) = lift (+)
let (mod) = lift (mod)
let (<>) = lift (<>)
let (&&) = lift (&&)

let fromn n = let s = cell (lift n) in s <~ [%dfg s + 1]; s 

let inp = fromn 2 

let out = cell inp

let filter = cell [%dfg true]

let primes = [%dfg if filter then out else -1] 

let next_prime () =  
  let x = peek primes in 
  (if (peek filter) 
  then 
    let new_filter = [%dfg inp mod (lift x) <> 0] in 
    let old_filter = root filter in 
    filter <~ [%dfg old_filter && new_filter] 
  else 
    ()
  );
  step();
  x 

let _ =
	for i = 1 to 100 do
		Printf.printf "%d\n" (next_prime());
	done