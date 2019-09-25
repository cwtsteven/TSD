open Tsd

let (+.) = lift (+.)

let fir3 f x =
  let s0 = cell [%dfg 0.0] in
  let s1 = cell [%dfg 0.0] in
  link s0 x;
  link s1 s0;
  let f = lift f in
  [%dfg (f 0 x) +. (f 1 s0) +. (f 2 s1)] 

let input = 
  let s = cell [%dfg 0.0] in
  link s [%dfg s +. 1.0];
  s 

let avg3 = fir3 (fun _ x -> x /. 3.0) input



let _ = 
  (*let n = int_of_string Sys.argv.(1) in  *)
  print_float (peek avg3); print_newline();
  for i = 1 to 10 do 
    step();
    print_float (peek avg3); print_newline()
  done