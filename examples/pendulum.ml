open Tsd

let%tsd x = 1 

let t = 0.05 
let l = 10.0 
let g = 9.81 

let ( *^ ) = lift ( *. )
let ( +^ ) = lift ( +. )
let ( -^ ) = lift ( -. )
let ( /^ ) = lift ( /. )
let sin' = lift sin
let cos' = lift cos

let%tsd integr = fun t dx -> 
	let x = cell 0.0 in 
	x <~ t *^ dx +^ x; 
	x 

let%tsd deriv = fun t x ->
	let prex = cell 0.0 in
	prex <~ x;  
	x -^ prex /^ t  

let%tsd integr = integr (lift t)
let%tsd deriv = deriv (lift t) 

let%tsd equation = fun d2x0 d2y0 -> 
	let theta = cell 0.0 in 
	let g = lift g and l = lift l in 
	theta <~ integr (integr ((sin' theta) *^ (d2y0 +^ g) -^ (cos' theta) *^ d2x0) /^ l);
	theta 

let%tsd position = fun x0 y0 ->  
	let d2x0 = deriv (deriv x0) in 
	let d2y0 = deriv (deriv y0)  in

    let theta = equation d2x0 d2y0 in

    let l = lift l in 
    let x = x0 +^ l *^ (sin' theta)  in
    let y = y0 +^ l *^ (cos' theta)  in
    (x, y) 



let _ = 
	let pos = [%tsd position 0.0 0.0 ] in 
	let (x, y) = peek pos in 
	Printf.printf "x: %f, y:%f\n" x y; 
	step(); 
	Printf.printf "x: %f, y:%f\n" x y; 
	step(); 
	Printf.printf "x: %f, y:%f\n" x y; 
	step(); 
	Printf.printf "x: %f, y:%f\n" x y; 