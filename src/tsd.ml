type 'a graph = Thunk of (unit -> 'a) 
             | IF_Thunk of (unit -> 'a graph)
             | Cell of int * (('a * 'a graph * 'a option) ref)

let create_thunk t = Thunk t

let _cell_id = ref 0 

let lift t = Thunk (fun () -> t)

let rec peek = function
  | Thunk t -> t ()
  | IF_Thunk t -> peek (t()) 
  | Cell (_,x) -> let (v,_,_) = !x in v 

let root = function
  | Cell (_,x) -> let (_,g,_) = !x in g
  | _ -> failwith "graph: not a cell"  

let apply t u = Thunk (fun () -> (peek t) (peek u))

let ifthenelse b t1 t2 = let t1 = t1() in let t2 = t2() in IF_Thunk (fun () -> if peek b then t1 else t2)

let dirties = ref Heteroset.empty

let cell g = 
  let c = ref (peek g, g, None) in 
  let id = !_cell_id in 
  _cell_id := !_cell_id + 1; 
  dirties := Heteroset.add (id,c) !dirties; 
  Cell (id,c) 

let init _ = 
  dirties := Heteroset.empty

let step () = 
  Heteroset.iter 
    (fun (_,x) -> 
      match !x with 
      | (v, g, None) -> let new_v = peek g in 
                        x := (v, g, Some new_v)
      | _            -> failwith "step: should be None" 
    ) !dirties;
  let result = Heteroset.fold 
    (fun acc (_,x) -> 
      match !x with
      | (v, g, Some w) -> x := (w, g, None); acc || (v != w) 
      | _              -> failwith "step: re-eval missing"  
    ) false !dirties 
  in 
  result 
 
let rec link cell dep = 
  match cell with
  | Cell (_,x) -> let (v, g, _) = !x in 
                  x := (v, dep, None)
  | IF_Thunk t -> link (t()) dep
  | _ -> failwith "link: not a cell" 

let rec assign cell v = 
  match cell with
  | Cell (_,x) -> let (_, g, _) = !x in 
                  x := (v, g, None) 
  | IF_Thunk t -> assign (t()) v
  | _ -> failwith "assign: not a cell" 

let rec set cell v = 
  match cell with
  | Cell (_,x) -> x := (v, lift v, None) 
  | IF_Thunk t -> set (t()) v
  | _ -> failwith "set: not a cell" 

let (<~) = link 

let (<:=) = assign 

let (<:~) = set 
