open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident
open Set
open List

module VariableSet = Set.Make(String) 

let desugar binds t = 
  Exp.apply (Exp.fun_ Nolabel None ((List.hd binds).pvb_pat) t) [(Nolabel, ((List.hd binds).pvb_expr))]

let rec expr_translater loc pstr = 
  match pstr with 
  | PStr [{ pstr_desc = 
            Pstr_eval (exp, _)}] -> syncdf_translater exp (VariableSet.empty)
  | _ -> raise (Location.Error (Location.error ~loc:loc "Only expressions can be defined within the TSD calculus. "))  

and addVar pat vars = 
  let {ppat_desc = desc} = pat in 
  match desc with 
  | Ppat_var id   -> VariableSet.add id.txt vars 
  | Ppat_alias (p, id) -> addVar p (VariableSet.add id.txt vars)
  | Ppat_array ps | Ppat_tuple ps -> 
                      let rec aux ps vars =
                       begin match ps with
                       | [] -> vars
                       | p :: ps -> aux ps (addVar p vars)
                       end
                      in aux ps vars
  | Ppat_construct (id, Some p) -> addVar p vars
  | Ppat_variant (id, Some p) -> addVar p vars
  | Ppat_record (ps, f) -> let rec aux ps vars =
                           begin match ps with
                           | [] -> vars
                           | (id, p) :: ps -> aux ps (addVar p vars)
                           end
                          in aux ps vars
  | Ppat_or (p1, p2) -> addVar p2 (addVar p1 vars)
  | Ppat_constraint (p, t) -> addVar p vars
  | Ppat_lazy p -> addVar p vars
  | Ppat_exception p -> addVar p vars 
  | Ppat_type id -> vars 
  | _ -> vars 

and syncdf_translater exp vars = 
  match exp.pexp_desc with 
  | Pexp_ident id                       -> if VariableSet.mem (Longident.last id.txt) vars then Exp.apply (Exp.ident {txt = Lident "lift"; loc = exp.pexp_loc}) [(Nolabel, (exp))] else exp
  | Pexp_constant c                     -> Exp.apply (Exp.ident {txt = Lident "lift"; loc = exp.pexp_loc}) [(Nolabel, (Exp.constant c))]
  | Pexp_apply (f, args)                -> apply_translater f args vars
  | Pexp_fun (_, _, pat, t)             -> let vars = addVar pat vars in 
                                           let g = syncdf_translater t vars in 
                                           let body = Exp.apply (Exp.ident {txt = Lident "peek"; loc = t.pexp_loc}) [(Nolabel, g)] in
                                           Exp.apply (Exp.ident {txt = Lident "lift"; loc = exp.pexp_loc}) [(Nolabel, (Exp.fun_ Nolabel None pat body))]
  | Pexp_let (rec_flag, binds, t)       -> syncdf_translater (desugar binds t) vars
  | Pexp_ifthenelse (cond, t1, t2)      -> ifthenelse_translater (cond, t1, t2) vars
(*  | Pexp_sequence (t1, t2)              -> Exp.sequence (syncdf_translater t1 vars) (syncdf_translater t2 vars) *)
  | Pexp_tuple ls                       -> Exp.apply (Exp.ident {txt = Lident "create_thunk"; loc = exp.pexp_loc})
                                              [(Nolabel, Exp.fun_ Nolabel None (Pat.any()) (Exp.tuple (List.map 
                                                                      (fun exp -> 
                                                                        let g = syncdf_translater exp vars in 
                                                                        Exp.apply (Exp.ident {txt = Lident "peek"; loc = exp.pexp_loc}) [(Nolabel, g)]
                                                                      )
                                                                      ls))
                                              )]
  | _ -> Exp.apply (Exp.ident {txt = Lident "lift"; loc = exp.pexp_loc}) [(Nolabel, exp)] 
      (*raise (Location.Error (Location.error ~loc:(exp.pexp_loc) "This expression is not defined in the SSAC calculus. "))  *)

and args_translater args vars = 
  match args with
  | [] -> [] 
  | (l, exp) :: args -> (l, syncdf_translater exp vars) :: args_translater args vars

and apply_translater f args vars = 
  match f.pexp_desc with  
  | Pexp_ident {txt = Lident "lift"} -> Exp.apply f args
  | Pexp_ident {txt = Lident "link"} 
  | Pexp_ident {txt = Lident "<~"} 
  | Pexp_ident {txt = Lident "cell"} -> Exp.apply f (args_translater args vars)                 
  | _ -> let g = syncdf_translater f vars in 
         let rec fold_apply = function
            | [] -> raise (Location.Error (Location.error ~loc:(f.pexp_loc) "Function application cannot have no args. ")) 
            | [(l, u)] -> let k = syncdf_translater u vars in
                          Exp.apply (Exp.ident {txt = Lident "apply"; loc = f.pexp_loc}) [(Nolabel, g); (l,k)]
            | (l, u) :: xs -> 
                          let k = syncdf_translater u vars in
                          Exp.apply (Exp.ident {txt = Lident "apply"; loc = f.pexp_loc}) [(Nolabel, fold_apply xs); (l,k)]
         in
         fold_apply (rev_append args [])

and ifthenelse_translater (cond, t1, t2) vars =
  let g = (syncdf_translater cond vars) in
  let h = Exp.fun_ Nolabel None (Pat.any()) (syncdf_translater t1 vars) in 
  match t2 with
  | Some t2 -> let k = Exp.fun_ Nolabel None (Pat.any()) (syncdf_translater t2 vars) in 
               Exp.apply (Exp.ident {txt = Lident "ifthenelse"; loc = cond.pexp_loc}) [(Nolabel, g); (Nolabel, h); (Nolabel, k)]
  | None    -> Exp.apply (Exp.ident {txt = Lident "ifthenelse"; loc = cond.pexp_loc}) [(Nolabel, g); (Nolabel, h)]