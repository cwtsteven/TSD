open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open List

open Tsd_trans

let rec expr_mapper mapper expr = 
  match expr with
  | { pexp_desc =
        Pexp_extension ({ txt = tag; loc }, pstr) } -> 
          if List.mem tag ["dfg"] then expr_translater loc pstr
          else default_mapper.expr mapper expr
  (* Delegate to the default mapper. *) 
  | _ -> default_mapper.expr mapper expr 

(*
and structure_item_mapper mapper structure_item =
  match structure_item with 
  | { pstr_desc = 
        Pstr_extension (({ txt = tag; loc }, pstr), _) } -> 
          if List.mem tag ["tsd"] then structure_item_translater loc pstr 
          else default_mapper.structure_item mapper structure_item
  | _ -> default_mapper.structure_item mapper structure_item
*)

and pattern_mapper mapper pattern = 
  match pattern with
  | x -> default_mapper.pat mapper x 

and tsd_mapper argv = 
  { 
    default_mapper with
    expr = expr_mapper;
    (*structure_item = structure_item_mapper; *)
    pat = pattern_mapper
  }
 
let () = register "tsd_ext" tsd_mapper