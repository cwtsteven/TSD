open Tsd

let (+) = lift (+)
let (mod) = lift (mod)
let (<>) = lift (<>)
let (&&) = lift (&&)

let fromn n = let s = cell (lift n) in s <~ [%dfg s + 1]; s 

let inp = fromn 2 
let filter = cell [%dfg true] 

let next () = 
  step(); 
  let new_filter = if peek filter then [%dfg inp mod (lift (peek inp - 1)) <> 0] else [%dfg true] in 
  let old_filter = root filter in 
  filter <~ [%dfg old_filter && new_filter]

let delay = 
  let s = cell [%dfg -1] in 
  s <~ inp; s
let primes = [%dfg if filter then delay else -1] 

let _ =
	for i = 1 to 100 do
    next();
		Printf.printf "%d\n" (peek primes);
	done 