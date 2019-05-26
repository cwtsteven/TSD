module Template = Set.Make (struct type t = int * (int ref) let compare (x,_) (y,_) = compare x y end)

type t = Template.t

(* constant *)
let empty = Template.empty 

(* logn *)
let add v s = Template.add (Obj.magic v) s 

(* logn *)
let remove v s = Template.remove (Obj.magic v) s 

(* constant *)
let singleton v = Template.singleton (Obj.magic v)

(* nlogn *)
let union t1 t2 = Template.union t1 t2 (*(Obj.obj (Obj.repr t1)) (Obj.obj (Obj.repr t2))*)

(* linear *)
let fold f base s = Template.fold (fun b acc -> f acc (Obj.magic b)) s base 

(* linear *)
let iter f s = Template.iter (fun b -> f (Obj.magic b)) s 
