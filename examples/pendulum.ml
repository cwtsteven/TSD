open Tsd

let%tsd x = 1 

let t = 0.05 
let l = 10.0 
let g = 9.81 

let ( *^ ) = lift ( *. )
let ( +^ ) = lift ( +. )
let ( -^ ) = lift ( -. )
let ( /^ ) = lift ( /. )


let integr t dx = 
	let%tsd x = cell 0.0 in 
	x <~ t *^ dx +. x; 
	x 

let deriv t x = 
	let%tsd prex = cell 0 in
	prex <~ x;  
	x -^ prex /^ t  



let equation d2x0 d2y0 = 
	let%tsd theta = cell 0.0 in 
	theta 

