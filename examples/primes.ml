open Tsd

let (+) = lift (+)
let (mod) = lift (mod)
let (==) = lift (==)
let (<>) = lift (<>)
let (&&) = lift (&&)
let (||) = lift (||)

let fromn n = 
  let s = cell (lift n) in 
  s <~ [%dfg s + 1]; s 

let filter inp n = 
  let n = lift n in 
  [%dfg inp == n || inp mod n <> 0] 

let inp = fromn 2 
let sieve = cell (filter inp 2) 

let next () = 
  step();
  let newlayer = filter inp (peek inp) in
  let oldlayer = root sieve in 
  sieve <~ [%dfg oldlayer && newlayer] 

let delay = cell inp 
let primes = [%dfg if sieve then delay else -1] 

let _ =
	for i = 1 to 100 do
		Printf.printf "%d\t%b\t%d\n" (peek delay) (peek sieve) (peek primes);
    next()
	done 