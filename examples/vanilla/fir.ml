open List

let rec zip xs ys = 
  match (xs, ys) with 
  | [], [] -> []
  | x :: xs, y :: ys -> (x, y) :: zip xs ys 

let rec shift v = function
  | [] -> [] 
  | x :: y :: [] -> v :: x :: []
  | x :: xs -> v :: shift x xs

let rec replicate n x = 
  match n with 
  | 0 -> []
  | n -> x :: replicate (n-1) x


type ('state, 'event, 'output) transducer = {
	init : 'state ;
	trans : 'state -> 'event -> 'state;
	out : 'state -> 'output
}

let compose m1 m2 = {
	init = (m1.init, m2.init); 
	trans = (fun (s1, s2) e -> let s1' = m1.trans s1 e in let s2' = m2.trans s2 (m1.out s1) in (s1', s2')); 
	out = fun (s1, s2) -> (m1.out s1, m2.out s2)
}

let run machine events = 
	let rec runFrom machine curr = function
		| [] -> []
		| e :: es -> machine.out (machine.trans curr e) :: runFrom machine (machine.trans curr e) es
	in
	machine.out (machine.init) :: runFrom machine machine.init events 

let fir ws = {
	init = replicate (length ws) 0.0; 
	trans = (fun s i -> shift i s); 
	out = fun s -> fold_left (fun sum (w, s) -> sum +. w *. s) 0.0 (zip ws s) 
}

let avg3 = 
  let w = 1.0 /. 3.0 in 
  fir [w; w; w] 

let inp = {
	init = 0.0;
	trans = (fun s _ -> s +. 1.0);
	out = fun x -> x 
}

let out = compose inp avg3

let _ =
	run out [();();()]