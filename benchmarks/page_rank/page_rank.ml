open Tsd
open List 

let rec stepN n = 
	match n with 
	| 0 -> false
	| n -> step(); stepN (n-1)

let rec dot_prod xs ys = 
	match xs, ys with
	| [], [] -> 0.0
	| x :: xs, y :: ys -> x *. y +. dot_prod xs ys 

let rec replicate init n = 
	match n with
	| 0 -> [] 
	| n -> init :: replicate init (n-1)

let page_rank hs n =
	let init = replicate (1.0 /. float_of_int (length hs)) (length hs) in 
	let rs = cell (lift init) in 
	rs <~ [%dfg (lift map) (fun h -> (lift dot_prod) h rs) (lift hs)]; 
	stepN n;
	peek rs

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




