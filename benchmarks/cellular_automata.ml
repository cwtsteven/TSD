open Tsd

type state = Zero | One
(*
let get_neighbour i cell_array = 
	if i == 0 then (lift Zero, cell_array.(i), cell_array.(i+1))
	else if i == (Array.length cell_array) - 1 then (cell_array.(i-1), cell_array.(i), lift Zero)
	else (cell_array.(i-1), cell_array.(i), cell_array.(i+1)) 
*)
let get_neighbour i all = 
  if i == 0 then (lift Zero, List.nth all (i), List.nth all (i+1))
  else if i == ((List.length all) - 1) then (List.nth all (i-1), List.nth all (i), lift Zero)
  else (List.nth all (i-1), List.nth all (i), List.nth all (i+1)) 

let create_automata size init transition = 
	let cell_list = List.map (fun i -> cell (lift i)) init in 
	List.iteri (fun i _ -> 
		let (a,b,c) = get_neighbour i cell_list in 
		link (List.nth cell_list i) [%dfg (lift transition) a b c]
	) cell_list; 
	cell_list

let rec init_states n total = 
	match n with
	| 0 -> [] 
	| n -> (if n == (total)/2 then One else Zero) :: init_states (n-1) total 

let rule110 a b c = 
	match (a,b,c) with
	| (One, One, One) -> Zero
	| (One, One, Zero) -> One
	| (One, Zero, One) -> One
	| (One, Zero, Zero) -> Zero
	| (Zero, One, One) -> One
	| (Zero, One, Zero) -> One
	| (Zero, Zero, One) -> One
	| (Zero, Zero, Zero) -> Zero

let rule54 a b c = 
	match (a,b,c) with
	| (One, One, One) -> Zero
	| (One, One, Zero) -> Zero
	| (One, Zero, One) -> One
	| (One, Zero, Zero) -> One
	| (Zero, One, One) -> Zero
	| (Zero, One, Zero) -> One
	| (Zero, Zero, One) -> One
	| (Zero, Zero, Zero) -> Zero

let _ =
	init();
	let size = int_of_string Sys.argv.(1) in 
	let total_step = int_of_string Sys.argv.(2) in 
	let world = create_automata size (init_states size size) rule54 in 
	for i = 1 to total_step do
		(*List.iter (fun cell -> print_int (if (peek cell) == One then 1 else 0)) world;
		print_newline();*)
		step()
	done