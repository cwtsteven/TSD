open Tsd_inc

let (+^) = lift (+)

let x = cell (lift 0)
let _ = x <~ [%dfg x +^ 1]
let y = cell (lift 0) 
let _ = y <~ [%dfg y +^ 1]

let pos = [%dfg (x, y)] 
let (x, y) = peek pos 
let (x2, y2) = peek pos 

let _ = x, y, x2, y2 
