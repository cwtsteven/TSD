open Tsd_inc

let t = 0.05 
let l = 10.0 
let g = 9.81 

let ( *^ ) = lift ( *. )
let ( +^ ) = lift ( +. )
let ( -^ ) = lift ( -. )
let ( /^ ) = lift ( /. )
let sin' = lift sin
let cos' = lift cos


let integr t dx =
	let t = lift t in 
	let x = cell [%dfg 0.0] in 
	x <~ [%dfg t *^ dx +^ x]; 
	x 

let deriv t x =
	let t = lift t in 
	let pre_x = cell x in 
	[%dfg x -^ pre_x /^ t]

let integr = integr t
let deriv = deriv t

let equation d2x0 d2y0 = 
	let g = lift g and l = lift l in 

	let theta = cell [%dfg 0.0] in 
	let thetap = cell [%dfg 0.0] in 
	thetap <~ theta; 
	let m = integr [%dfg (sin' thetap) *^ (d2y0 +^ g) -^ (cos' thetap) *^ d2x0] in 
	theta <~ integr [%dfg m /^ l];
	theta 

let position x0 y0 = 
	let l = lift l in 
	let d2x0 = deriv (deriv x0) in 
	let d2y0 = deriv (deriv y0)  in

    let theta = equation d2x0 d2y0 in 

    let x = [%dfg x0 +^ l *^ (sin' theta)] in
    let y = [%dfg y0 +^ l *^ (cos' theta)] in
    [%dfg (x0, y0)]

let inc init = 
	let s = cell (lift init) in 
	s <~ [%dfg s +^ 1.0]; s 

let _ = 
	let (x0, y0) = inc 0.0, inc 0.0 in 
	let pos = position x0 y0 in 
	let (x, y) = peek pos in 
	Printf.printf "x: %f, y:%f\n" x y; 
	for i = 1 to 100 do 
		step(); 
		let (x, y) = peek pos in 
		Printf.printf "x: %f, y:%f\n" x y; 
	done;

