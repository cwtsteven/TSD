type ('state, 'event) state_machine = {
	init : 'state ;
	trans : 'state -> 'event -> 'state
}

let alt : (int, 'a) state_machine = {
	init = 1;
	trans = fun s _ -> 1 - s 
}

let sum : (int, int) state_machine = {
	init = 0;
	trans = fun s i -> i + s 
}

let compose m1 m2 = {
	init = (m1.init, m2.init); 
	trans = fun (s1, s2) e -> let s1' = m1.trans s1 e in let s2' = m2.trans s2 s1 in (s1', s2')
}

let run machine events = 
	let rec runFrom machine curr = function
		| [] -> []
		| e :: es -> (machine.trans curr e) :: runFrom machine (machine.trans curr e) es
	in
	machine.init :: runFrom machine machine.init events 

let _ =
	let alt_sum = compose alt sum in 
	run alt_sum [();();()]