(* The Zélus Hybrid Synchronous language compiler, version 1.3.0
  (Sun 16 Sep 09:45:15 CEST 2018) *)
type continuous = { mutable pos: float; mutable der: float }
type zerocrossing = { mutable zin: bool; mutable zout: float }
type 'a signal = 'a * bool
type zero = bool
type ('b, 'a) integr' =
  { mutable i_49 : 'b; mutable m_44 : 'a }

let integr'_alloc () =
  { i_49 = (true: bool); m_44 = (0.: float) } 
let integr'_reset self  =
  self.i_49 <- true; ()


let integr'_step self t_27 dx_26 =
  let l_51 = self.i_49  in
  self.i_49 <- false;
  let m_45 = if l_51 then 0. else (+.) (( *. ) t_27 dx_26) self.m_44  in
  let x_28 = m_45  in
  self.m_44 <- m_45; m_45

let integr' = integr'_alloc, integr'_step, integr'_reset
type ('b, 'a) deriv' =
  { mutable i_50 : 'b; mutable m_46 : 'a }

let deriv'_alloc () =
  { i_50 = (true: bool); m_46 = (0.: float) } 
let deriv'_reset self  =
  self.i_50 <- true; ()


let deriv'_step self t_29 x_30 =
  let l_52 = self.i_50  in
  self.i_50 <- false;
  let m_47 = if l_52 then 0. else (/.) ((-.) x_30 self.m_46) t_29  in
  self.m_46 <- x_30; m_47

let deriv' = deriv'_alloc, deriv'_step, deriv'_reset
let t = 0.05

let l = 10.

let g = 9.81

type ('a) integr =
  { mutable i_53 : 'a }

let integr_alloc () =
  { i_53 = integr'_alloc () (* discrete *)  } 
let integr_reset self  =
  integr'_reset self.i_53 ; ()


let integr_step self dx_31 =
  integr'_step self.i_53 t dx_31

let integr = integr_alloc, integr_step, integr_reset
type ('a) deriv =
  { mutable i_54 : 'a }

let deriv_alloc () =
  { i_54 = deriv'_alloc () (* discrete *)  } 
let deriv_reset self  =
  deriv'_reset self.i_54 ; ()


let deriv_step self x_32 =
  deriv'_step self.i_54 t x_32

let deriv = deriv_alloc, deriv_step, deriv_reset
type ('c, 'b, 'a) equation =
  { mutable i_55 : 'c; mutable i_56 : 'b; mutable m_48 : 'a }

let equation_alloc () =
  { m_48 = (0.: float);i_55 = integr_alloc () (* discrete *) ;
                       i_56 = integr_alloc () (* discrete *)  }
let equation_reset self  =
  self.m_48 <- 0.; integr_reset self.i_55 ; integr_reset self.i_56 ; ()


let equation_step self d2x0_33 d2y0_34 =
  let thetap_36 = self.m_48  in
  let theta_35 =
      integr_step self.i_56 ((/.) (integr_step self.i_55 ((-.) (( *. ) 
                                                                  (sin 
                                                                    self.m_48)
                                                                  ((+.) 
                                                                    d2y0_34 g))
                                                               (( *. ) 
                                                                  (cos 
                                                                    self.m_48)
                                                                  d2x0_33)))
                                  l)  in
  self.m_48 <- theta_35; theta_35

let equation = equation_alloc, equation_step, equation_reset
type ('e, 'd, 'c, 'b, 'a) position =
  { mutable i_57 : 'e;
    mutable i_58 : 'd;
    mutable i_59 : 'c; mutable i_60 : 'b; mutable i_61 : 'a }

let position_alloc () =
  { i_57 = deriv_alloc () (* discrete *) ;
    i_58 = deriv_alloc () (* discrete *) ;
    i_59 = deriv_alloc () (* discrete *) ;
    i_60 = deriv_alloc () (* discrete *) ;
    i_61 = equation_alloc () (* discrete *)  } 
let position_reset self  =
  deriv_reset self.i_57 ;
  deriv_reset self.i_58 ;
  deriv_reset self.i_59 ;
  deriv_reset self.i_60 ; equation_reset self.i_61 ; ()


let position_step self x0_37 y0_38 =
  let d2x0_39 = deriv_step self.i_58 (deriv_step self.i_57 x0_37)  in
  let d2y0_40 = deriv_step self.i_60 (deriv_step self.i_59 y0_38)  in
  let theta_41 = equation_step self.i_61 d2x0_39 d2y0_40  in
  let y_43 = (+.) y0_38 (( *. ) l (cos theta_41))  in
  let x_42 = (+.) x0_37 (( *. ) l (sin theta_41))  in
  (x_42, y_43)

let position = position_alloc, position_step, position_reset
