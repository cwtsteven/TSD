open Tsd

let (+) = lift (+)
let (%) = lift (%)
let (<>) = lift (<>)
let (&&) = lift (&&)

let fromn n = let s = cell (lift n) in s <~ [%dfg s + 1]; s 

let inp = fromn 2 

let filter = cell [%dfg true]

let primes = [%dfg if filter then Just inp else Nothing]

let next_prime () =  
  let x = peek primes in 
  (if (peek filter)
  then 
  	let curr_inp = peek curr_inp in 
    let filter' = [%dfg inp % (lift curr_inp) <> 0] in 
    filter <~ [%dfg root filter && filter'];  
  else 
    ()
  step ();
  x 

let _ =
	for i = 1 to 100 do
		Printf.prinf "%d\n" (next_prime());
	done