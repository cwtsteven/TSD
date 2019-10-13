open Tsd
open List 

let t = lift 0.05 
let l = lift 10.0 
let g = lift 9.81 

let ( *^ ) = lift ( *. )
let ( +^ ) = lift ( +. )
let ( -^ ) = lift ( -. )
let ( /^ ) = lift ( /. )
let sin' = lift sin
let cos' = lift cos


let integr t dx =
	let x = cell [%dfg 0.0] in 
	x <~ [%dfg t *^ dx +^ x]; 
	x 

let deriv t x =
	let pre_x = cell x in 
	[%dfg x -^ pre_x /^ t]

let integr = integr t
let deriv = deriv t

let equation d2x0 d2y0 = 
	let theta = cell [%dfg 0.0] in 
	let thetap = cell [%dfg 0.0] in 
	thetap <~ theta; 
	let m = integr [%dfg (sin' thetap) *^ (d2y0 +^ g) -^ (cos' thetap) *^ d2x0] in 
	theta <~ integr [%dfg m /^ l];
	theta 

let position x0 y0 = 
	let d2x0 = deriv (deriv x0) in 
	let d2y0 = deriv (deriv y0)  in

    let theta = equation d2x0 d2y0 in 

    let%dfg x = x0 +^ l *^ (sin' theta) in
    let     y = y0 +^ l *^ (cos' theta) in
    (x, y)

let inc init = 
	let init = lift init in 
	let s = cell [%dfg init] in 
	s <~ [%dfg s +^ 1.0]; s 

let _ = 
	let (x0, y0) = inc 0.0, inc 0.0 in 
	let pos = position x0 y0 in 
	let (x, y) = peek pos in 
	(*Printf.printf "x: %f, y:%f\n" x y; *)
	let n = int_of_string Sys.argv.(1) in 
	for i = 1 to n do 
		step(); 
		(*let (x, y) = peek pos in 
		Printf.printf "x: %f, y:%f\n" x y; *)
	done;

