open Tsd
open List

let rec zip xs ys = 
  match (xs, ys) with 
  | [], [] -> []
  | x :: xs, y :: ys -> (x, y) :: zip xs ys 

let (+^) = lift (+.)
let (-^) = lift (-.)
let ( *^ ) = lift ( *. )
let ( /^ ) = lift ( /. )

let rec stepN n = 
	match n with 
	| 0 -> false
	| n -> step(); stepN (n-1)

let rec create_cells n init = 
	match n with
	| 0 -> []
	| n -> let s = cell (lift init) in s :: create_cells (n-1) init

let rec dot_prod xs ys = 
	match xs, ys with
	| [], [] -> lift 0.0
	| x :: xs, y :: ys -> let sum = dot_prod xs ys in [%dfg (lift x) *^ y +^ sum] 

let page_rank hs n =
	let rs = create_cells (length hs) (1.0 /. float_of_int (length hs)) in 
	iter (fun (h, r) -> link r (dot_prod h rs)) (zip hs rs); 
	stepN n;
	map peek rs

let rec transpose list = 
match list with
| []             -> []
| []   :: xss    -> transpose xss
| (x::xs) :: xss ->
    (x :: List.map List.hd xss) :: transpose (xs :: List.map List.tl xss)

let rec generate size bound = 
	match size with 
	| 0 -> []
	| 1 -> bound :: []
	| n -> let x = Random.float bound in x :: generate (n-1) (bound-.x)

let generate_matrix size bound =
	let rec aux iter = 
		match iter with 
		| 0 -> [] 
		| n -> generate size bound :: aux (n-1)
	in 
	aux size

let _ = 
	let size = int_of_string Sys.argv.(1) in 
  	let n = int_of_string Sys.argv.(2) in 
  	let hs = transpose (generate_matrix size 1.0) in 
	page_rank hs n




