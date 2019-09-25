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

let%tsd deriv = deriv (lift t) 

let%tsd position = fun x0 y0 ->  
	let d2x0 = deriv (deriv x0) in 
	let d2y0 = deriv (deriv y0)  in

    let theta = 0.0 in

    let x = x0 +^ (lift l) *^ (sin' theta)  in
    let y = y0 +^ (lift l) *^ (cos' theta)  in
    (x, y)