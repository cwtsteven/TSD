module Inc = Incremental.Make ()
open Inc

let createList n init total = 
	let rec aux n init acc = 
	match n with
	| 0 -> acc
	| n -> let input_v = Var.create init in 
		   aux (n-1) init (if n mod total/1000 == 0 then input_v :: acc else acc)
	in 
    aux n init []

let createLayer xs = 
	let rec aux xs acc =
	match xs with 
	| [] -> acc
	| x :: [] -> x :: acc 
	| (x :: y :: xs) -> let c = Inc.map2 x y ~f:(fun x y -> x + y) in aux xs (c :: acc)
	in 
    aux xs []

let rec createGraph n xs =
	match n with
	  | 0 -> xs
	  | n -> createGraph (n-1) (createLayer xs) 

let _ =
	let n = int_of_string Sys.argv.(1) in 
	let k = int_of_string Sys.argv.(2) in 
	let ins' = createList n 0 n in 
	(*let outs = createGraph k (List.map (fun i -> Var.watch i) ins) in*)
	List.map (fun i -> Var.set i 1) ins';
	(*let v = Inc.Observer.value_exn in
	let outs = List.map (fun i -> Inc.observe i) outs in *)
	Inc.stabilize (); 
	(*outs; List.iter (fun i -> print_int (v i); print_newline()) outs*)