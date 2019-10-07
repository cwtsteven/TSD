(* The Zélus Hybrid Synchronous language compiler, version 1.3.0
  (Sun 16 Sep 09:45:15 CEST 2018) *)
type continuous = { mutable pos: float; mutable der: float }
type zerocrossing = { mutable zin: bool; mutable zout: float }
type 'a signal = 'a * bool
type zero = bool
type state__439 = Silent_93 | Open_92  
type state__438 = Failure_88 | Try_87 | Light_on_86 | Light_off_85  
type state__437 = Silent_68 | Open_67  
type state__436 = Failure_63 | Try_62 | Light_on_61 | Light_off_60  
type state__435 = Silent_53 | Open_52  
let low = 4

let high = 4

let delay_on = 500

let delay_off = 100

type ('d, 'c, 'b, 'a) count =
  { mutable i_112 : 'd;
    mutable m_106 : 'c; mutable m_105 : 'b; mutable m_104 : 'a }

let count_alloc () =
  { i_112 = (true: bool);
    m_106 = (0: int); m_105 = (0: int); m_104 = (false: bool) } 
let count_reset self  =
  self.i_112 <- true; ()


let count_step self d_41 t_42 =
  let l_122 = self.i_112  in
  self.i_112 <- false;
  let m_107 =
      if l_122
      then d_41
      else if (&) t_42 (not self.m_104) then (-) self.m_105 1 else self.m_106
   in
  let cpt_43 = m_107  in
  let ok_44 = (=) m_107 0  in
  self.m_106 <- m_107; self.m_105 <- m_107; self.m_104 <- ok_44; ok_44

let count = count_alloc, count_step, count_reset
type ('b, 'a) edge =
  { mutable i_113 : 'b; mutable m_108 : 'a }

let edge_alloc () =
  { i_113 = (true: bool); m_108 = (false: bool) } 
let edge_reset self  =
  self.i_113 <- true; ()


let edge_step self x_45 =
  let l_123 = self.i_113  in
  self.i_113 <- false;
  let m_109 = if l_123 then false else (&) (not self.m_108) x_45  in
  self.m_108 <- x_45; m_109

let edge = edge_alloc, edge_step, edge_reset
type ('b, 'a) heat =
  { mutable i_114 : 'b; mutable m_110 : 'a }

let heat_alloc () =
  { i_114 = (true: bool); m_110 = (false: bool) } 
let heat_reset self  =
  self.i_114 <- true; ()


let heat_step self expected_temp_47 actual_temp_46 =
  let l_124 = self.i_114  in
  self.i_114 <- false;
  let m_111 = if l_124 then false else self.m_110  in
  let ok_48 =
      if (<=) actual_temp_46 ((-) expected_temp_47 low)
      then true
      else
        if (>=) actual_temp_46 ((+) expected_temp_47 high)
        then false
        else m_111  in
  self.m_110 <- ok_48; ok_48

let heat = heat_alloc, heat_step, heat_reset
type ('f, 'e, 'd, 'c, 'b, 'a) command =
  { mutable i_135 : 'f;
    mutable i_136 : 'e;
    mutable r_95 : 'd;
    mutable s_94 : 'c; mutable open_light_51 : 'b; mutable open_gas_50 : 'a }

let command_alloc () =
  { r_95 = (false: bool);
    s_94 = (Open_52: state__435);
    open_light_51 = (false: bool); open_gas_50 = (false: bool);i_135 = count_alloc () (* discrete *) ;
                                                               i_136 = count_alloc () (* discrete *)  }
let command_reset self  =
  self.r_95 <- false;
  self.s_94 <- Open_52; count_reset self.i_135 ; count_reset self.i_136 ; ()


let command_step self millisecond_49 =
  let l_126 = self.r_95  in
  let l_125 = self.s_94  in
  (match self.s_94 with
     | Open_52 ->
         (if self.r_95 then (count_reset self.i_136 ; ()) else ());
         (if count_step self.i_136 delay_on millisecond_49
          then (self.s_94 <- Silent_53; self.r_95 <- true; ())
          else (self.r_95 <- false; ()));
         self.open_gas_50 <- true; self.open_light_51 <- true; ()
     | Silent_53 ->
         (if self.r_95 then (count_reset self.i_135 ; ()) else ());
         (if count_step self.i_135 delay_off millisecond_49
          then (self.s_94 <- Open_52; self.r_95 <- true; ())
          else (self.r_95 <- false; ()));
         self.open_gas_50 <- false; self.open_light_51 <- false; ()
     );
  (self.open_light_51, self.open_gas_50)

let command = command_alloc, command_step, command_reset
type ('m, 'l, 'k, 'j, 'i, 'h, 'g, 'f, 'e, 'd, 'c, 'b, 'a) light =
  { mutable i_137 : 'm;
    mutable i_138 : 'l;
    mutable i_139 : 'k;
    mutable i_140 : 'j;
    mutable r_97 : 'i;
    mutable s_96 : 'h;
    mutable open_light_59 : 'g;
    mutable open_gas_58 : 'f;
    mutable nok_57 : 'e;
    mutable r_99 : 'd;
    mutable s_98 : 'c; mutable open_light_66 : 'b; mutable open_gas_65 : 'a }

let light_alloc () =
  { r_97 = (false: bool);
    s_96 = (Light_off_60: state__436);
    open_light_59 = (false: bool);
    open_gas_58 = (false: bool);
    nok_57 = (false: bool);
    r_99 = (false: bool);
    s_98 = (Open_67: state__437);
    open_light_66 = (false: bool); open_gas_65 = (false: bool);i_137 = count_alloc () (* discrete *) ;
                                                               i_138 = count_alloc () (* discrete *) ;
                                                               i_139 = edge_alloc () (* discrete *) ;
                                                               i_140 = count_alloc () (* discrete *)  }
let light_reset self  =
  self.r_97 <- false;
  self.s_96 <- Light_off_60;
  self.r_99 <- false;
  self.s_98 <- Open_67;
  count_reset self.i_137 ;
  count_reset self.i_138 ;
  edge_reset self.i_139 ; count_reset self.i_140 ; ()


let light_step self millisecond_54 on_heat_55 on_light_56 =
  let l_128 = self.r_97  in
  let l_127 = self.s_96  in
  (match self.s_96 with
     | Light_off_60 ->
         self.nok_57 <- false;
         self.open_light_59 <- false;
         self.open_gas_58 <- false;
         (if on_heat_55
          then (self.s_96 <- Try_62; self.r_97 <- true; ())
          else (self.r_97 <- false; ()));
         ()
     | Light_on_61 ->
         self.nok_57 <- false;
         self.open_light_59 <- false;
         self.open_gas_58 <- true;
         (if not on_heat_55
          then (self.s_96 <- Light_off_60; self.r_97 <- true; ())
          else (self.r_97 <- false; ()));
         ()
     | Try_62 ->
         let l_130 = ref (false:bool) in
         let l_129 = ref (Silent_68:state__437) in
         (if self.r_97
          then
            (self.r_99 <- false;
             self.s_98 <- Open_67;
             count_reset self.i_137 ;
             count_reset self.i_138 ;
             edge_reset self.i_139 ; count_reset self.i_140 ; ())
          else ());
         l_130 := self.r_99;
         l_129 := self.s_98;
         let millisecond_64 = millisecond_54  in
         (match !l_129 with
            | Open_67 ->
                (if !l_130 then (count_reset self.i_138 ; ()) else ());
                (if count_step self.i_138 delay_on millisecond_64
                 then (self.s_98 <- Silent_68; self.r_99 <- true; ())
                 else (self.r_99 <- false; ()));
                self.open_gas_65 <- true; self.open_light_66 <- true; ()
            | Silent_68 ->
                (if !l_130 then (count_reset self.i_137 ; ()) else ());
                (if count_step self.i_137 delay_off millisecond_64
                 then (self.s_98 <- Open_67; self.r_99 <- true; ())
                 else (self.r_99 <- false; ()));
                self.open_gas_65 <- false; self.open_light_66 <- false; ()
            );
         let (copy_115, copy_116) = (self.open_light_66, self.open_gas_65)
          in
         self.open_light_59 <- copy_115;
         self.open_gas_58 <- copy_116;
         (match (count_step self.i_140 3
                                       (edge_step self.i_139 (not self.open_light_59)),
                 on_light_56) with
            | (_, true) -> self.s_96 <- Light_on_61; self.r_97 <- true; ()
            | (true, _) -> self.s_96 <- Failure_63; self.r_97 <- true; ()
            | _ -> self.r_97 <- false; () );
         ()
     | Failure_63 ->
         self.nok_57 <- true;
         self.open_light_59 <- false;
         self.open_gas_58 <- false; self.r_97 <- false; ()
     );
  (self.open_light_59, self.open_gas_58, self.nok_57)

let light = light_alloc, light_step, light_reset
type ('s,
      'r, 'q, 'p, 'o, 'n, 'm, 'l, 'k, 'j, 'i, 'h, 'g, 'f, 'e, 'd, 'c, 'b, 'a) main =
  { mutable i_141 : 's;
    mutable i_142 : 'r;
    mutable i_143 : 'q;
    mutable i_144 : 'p;
    mutable i_145 : 'o;
    mutable r_101 : 'n;
    mutable s_100 : 'm;
    mutable open_light_84 : 'l;
    mutable open_gas_83 : 'k;
    mutable nok_82 : 'j;
    mutable open_light_78 : 'i;
    mutable open_gas_77 : 'h;
    mutable on_heat_76 : 'g;
    mutable ok_75 : 'f;
    mutable nok_74 : 'e;
    mutable r_103 : 'd;
    mutable s_102 : 'c; mutable open_light_91 : 'b; mutable open_gas_90 : 'a }

let main_alloc () =
  { r_101 = (false: bool);
    s_100 = (Light_off_85: state__438);
    open_light_84 = (false: bool);
    open_gas_83 = (false: bool);
    nok_82 = (false: bool);
    open_light_78 = (false: bool);
    open_gas_77 = (false: bool);
    on_heat_76 = (false: bool);
    ok_75 = (false: bool);
    nok_74 = (false: bool);
    r_103 = (false: bool);
    s_102 = (Open_92: state__439);
    open_light_91 = (false: bool); open_gas_90 = (false: bool);i_141 = heat_alloc () (* discrete *) ;
                                                               i_142 = count_alloc () (* discrete *) ;
                                                               i_143 = count_alloc () (* discrete *) ;
                                                               i_144 = edge_alloc () (* discrete *) ;
                                                               i_145 = count_alloc () (* discrete *)  }
let main_reset self  =
  self.r_101 <- false;
  self.s_100 <- Light_off_85;
  heat_reset self.i_141 ;
  self.r_103 <- false;
  self.s_102 <- Open_92;
  count_reset self.i_142 ;
  count_reset self.i_143 ;
  edge_reset self.i_144 ; count_reset self.i_145 ; ()


let main_step self millisecond_71
                   restart_73 expected_temp_70 actual_temp_69 on_light_72 =
  let l_132 = ref (false:bool) in
  let l_131 = ref (Failure_88:state__438) in
  (if restart_73
   then
     (self.r_101 <- false;
      self.s_100 <- Light_off_85;
      heat_reset self.i_141 ;
      self.r_103 <- false;
      self.s_102 <- Open_92;
      count_reset self.i_142 ;
      count_reset self.i_143 ;
      edge_reset self.i_144 ; count_reset self.i_145 ; ())
   else ());
  l_132 := self.r_101;
  l_131 := self.s_100;
  let on_light_81 = on_light_72  in
  self.on_heat_76 <- heat_step self.i_141 expected_temp_70 actual_temp_69;
  let on_heat_80 = self.on_heat_76  in
  let millisecond_79 = millisecond_71  in
  (match !l_131 with
     | Light_off_85 ->
         self.nok_82 <- false;
         self.open_light_84 <- false;
         self.open_gas_83 <- false;
         (if on_heat_80
          then (self.s_100 <- Try_87; self.r_101 <- true; ())
          else (self.r_101 <- false; ()));
         ()
     | Light_on_86 ->
         self.nok_82 <- false;
         self.open_light_84 <- false;
         self.open_gas_83 <- true;
         (if not on_heat_80
          then (self.s_100 <- Light_off_85; self.r_101 <- true; ())
          else (self.r_101 <- false; ()));
         ()
     | Try_87 ->
         let l_134 = ref (false:bool) in
         let l_133 = ref (Silent_93:state__439) in
         (if !l_132
          then
            (self.r_103 <- false;
             self.s_102 <- Open_92;
             count_reset self.i_142 ;
             count_reset self.i_143 ;
             edge_reset self.i_144 ; count_reset self.i_145 ; ())
          else ());
         l_134 := self.r_103;
         l_133 := self.s_102;
         let millisecond_89 = millisecond_79  in
         (match !l_133 with
            | Open_92 ->
                (if !l_134 then (count_reset self.i_143 ; ()) else ());
                (if count_step self.i_143 delay_on millisecond_89
                 then (self.s_102 <- Silent_93; self.r_103 <- true; ())
                 else (self.r_103 <- false; ()));
                self.open_gas_90 <- true; self.open_light_91 <- true; ()
            | Silent_93 ->
                (if !l_134 then (count_reset self.i_142 ; ()) else ());
                (if count_step self.i_142 delay_off millisecond_89
                 then (self.s_102 <- Open_92; self.r_103 <- true; ())
                 else (self.r_103 <- false; ()));
                self.open_gas_90 <- false; self.open_light_91 <- false; ()
            );
         let (copy_117, copy_118) = (self.open_light_91, self.open_gas_90)
          in
         self.open_light_84 <- copy_117;
         self.open_gas_83 <- copy_118;
         (match (count_step self.i_145 3
                                       (edge_step self.i_144 (not self.open_light_84)),
                 on_light_81) with
            | (_, true) -> self.s_100 <- Light_on_86; self.r_101 <- true; ()
            | (true, _) -> self.s_100 <- Failure_88; self.r_101 <- true; ()
            | _ -> self.r_101 <- false; () );
         ()
     | Failure_88 ->
         self.nok_82 <- true;
         self.open_light_84 <- false;
         self.open_gas_83 <- false; self.r_101 <- false; ()
     );
  let (copy_119, copy_120, copy_121) =
      (self.open_light_84, self.open_gas_83, self.nok_82)  in
  self.open_light_78 <- copy_119;
  self.open_gas_77 <- copy_120;
  self.nok_74 <- copy_121;
  self.ok_75 <- not self.nok_74;
  (self.open_light_78, self.open_gas_77, self.ok_75, self.nok_74)

let main = main_alloc, main_step, main_reset
