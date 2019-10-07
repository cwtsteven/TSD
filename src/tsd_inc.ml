type 'a graph = Thunk of (unit -> 'a) * Heteroset.t 
             | IF_Thunk of (unit -> 'a graph) * Heteroset.t
             | Cell of int * (('a * 'a graph * 'a option * Heteroset.t) ref)

let create_thunk t = Thunk (t, Heteroset.empty)

let _cell_id = ref 0 

let lift t = Thunk ((fun () -> t), Heteroset.empty) 

let rec peek = function
  | Thunk (t, _) -> t ()
  | IF_Thunk (t, _) -> peek (t()) 
  | Cell (_,x) -> let (v,_,_,_) = !x in v 

let root = function
  | Cell (_,x) -> let (_,g,_,_) = !x in g 
  | _ -> failwith "graph: not a cell"  

let getParents = function 
  | Thunk (_, l) -> l  
  | IF_Thunk (_, l) -> l
  | Cell (id,x) -> Heteroset.singleton (id,x) 

let apply t u = Thunk ((fun () -> (peek t) (peek u)), Heteroset.union (getParents t) (getParents u))

let ifthenelse b t1 t2 = let t1 = t1() in let t2 = t2() in 
                         IF_Thunk ((fun () -> if peek b then t1 else t2), 
                                    Heteroset.union (Heteroset.union (getParents b) (getParents t1)) (getParents t2))

let dirties = ref Heteroset.empty

let rec addChildTo l c = 
  Heteroset.iter (fun (id,x) -> let (v, g, op, childs) = !x in 
                           x := (v, g, op, Heteroset.add c childs)
                 ) l 

let rec removeChildFrom l c =
  Heteroset.iter (fun (id,x) -> let (v, g, op, childs) = !x in 
                           x := (v, g, op, Heteroset.remove c childs)
                 ) l 

let cell g = 
  let c = ref (peek g, g, None, Heteroset.empty) in
  let id = !_cell_id in 
  _cell_id := !_cell_id + 1; 
  addChildTo (getParents g) (id,c); 
  Cell (id,c)  

let init _ = 
  dirties := Heteroset.empty

let step () = 
  let dirty = Heteroset.fold 
    (fun dirty (_,x) -> 
      match !x with 
      | (v, g, None, childs) -> let new_v = peek g in 
                                x := (v, g, Some new_v, childs); 
                                if (v <> new_v) then Heteroset.union dirty childs 
                                else dirty 
      | _                    -> failwith "step: should be None" 
    ) Heteroset.empty !dirties 
  in 
  let result = Heteroset.fold 
    (fun acc (_,x) -> 
      match !x with
      | (v, g, Some w, childs) -> x := (w, g, None, childs); acc || (v != w) 
      | _                      -> failwith "step: re-eval missing"  
    ) false !dirties 
  in 
  dirties := dirty; 
  result 
 
let rec link cell dep = 
  match cell with
  | Cell (id,x) -> let (v, g, _, childs) = !x in 
                  x := (v, dep, None, childs); 
                  removeChildFrom (getParents g) (id,x); 
                  addChildTo (getParents dep) (id,x); 
                  dirties := Heteroset.add (id,x) !dirties
  | IF_Thunk (t,_) -> link (t()) dep
  | _ -> failwith "link: not a cell" 

let rec assign cell v = 
  match cell with
  | Cell (id,x) -> let (old_v, g, _, childs) = !x in 
                   x := (v, g, None, childs);
                   removeChildFrom (getParents g) (id,x); 
                   dirties := Heteroset.add (id,x) !dirties;
                   (if old_v <> v then dirties := Heteroset.union !dirties childs else ())
  | IF_Thunk (t,_) -> assign (t()) v
  | _ -> failwith "assign: not a cell" 

let rec set cell v = 
  match cell with
  | Cell (id,x) -> let (old_v, g, _, childs) = !x in 
                   x := (v, lift v, None, childs);
                   removeChildFrom (getParents g) (id,x); 
                   (if old_v <> v then dirties := Heteroset.union !dirties childs else ())
  | IF_Thunk (t,_) -> set (t()) v
  | _ -> failwith "set: not a cell" 

let (<~) = link 

let (<:=) = assign 

let (<:~) = set 
