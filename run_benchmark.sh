#!/bin/bash

rm -rf benchmarks_build
mkdir benchmarks_build
mkdir benchmarks_build/inc
mkdir benchmarks_build/rml 
mkdir benchmarks_build/incjs
cp -R benchmarks/* benchmarks_build

for i in benchmarks/*.ml; do
	NAME=$(basename $i .ml)
	ocamlfind ocamlopt -package tsd,tsd.ppx -o benchmarks_build/$NAME -linkpkg benchmarks_build/$NAME.ml
	cp benchmarks/$NAME.ml benchmarks_build/inc/$NAME.ml
	sed -i "" "1s/.*/open Tsd_inc/" benchmarks_build/inc/$NAME.ml
	ocamlfind ocamlopt -package tsd,tsd.ppx -o benchmarks_build/inc/$NAME -linkpkg benchmarks_build/inc/$NAME.ml
done 

for i in benchmarks/rml/*.rml; do 
	NAME=$(basename $i .rml)
	rmlc $i -d benchmarks_build/rml/
	ocamlfind ocamlopt -o benchmarks_build/rml/$NAME -I `rmlc -where` unix.cmxa rmllib.cmxa benchmarks_build/rml/$NAME.ml
done 

for i in benchmarks/incjs/*.ml; do 
	NAME=$(basename $i .ml)
	cp $i benchmarks_build/incjs/$NAME.ml 
	ocamlfind ocamlopt -thread -linkpkg -package incremental -o benchmarks_build/incjs/$NAME benchmarks_build/incjs/$NAME.ml
done 


########## benchmarks for cellular automata ##########
echo "\n########## benchmarks for cellular automata ##########"
echo "---------- size 100, running 100 times"
echo "RML:"
time benchmarks_build/rml/cellular_automata 100 100
echo "\nPlain TSD:"
time benchmarks_build/cellular_automata 100 100
echo "\nInc TSD:"
time benchmarks_build/inc/cellular_automata 100 100
echo "\n---------- size 1000, running 100 times"
echo "RML:"
time benchmarks_build/rml/cellular_automata 1000 100
echo "\nPlain TSD:"
time benchmarks_build/cellular_automata 1000 100
echo "\nInc TSD:"
time benchmarks_build/inc/cellular_automata 1000 100
echo "\n---------- size 10000, running 100 times"
echo "RML:"
time benchmarks_build/rml/cellular_automata 10000 100
echo "\nPlain TSD:"
time benchmarks_build/cellular_automata 10000 100
echo "\nInc TSD:"
time benchmarks_build/inc/cellular_automata 10000 100


########## benchmarks for light control ##########
echo "\n########## benchmarks for light control ##########"
echo "---------- with 100000 commands"
echo "RML:"
time benchmarks_build/rml/light_control 100000 
echo "\nPlain TSD:"
time benchmarks_build/light_control 100000
echo "\nInc TSD:"
time benchmarks_build/inc/light_control 100000
echo "---------- with 1000000 commands"
echo "RML:"
time benchmarks_build/rml/light_control 1000000
echo "\nPlain TSD:"
time benchmarks_build/light_control 1000000
echo "\nInc TSD:"
time benchmarks_build/inc/light_control 1000000
echo "---------- with 10000000 commands"
echo "RML:"
time benchmarks_build/rml/light_control 10000000
echo "\nPlain TSD:"
time benchmarks_build/light_control 10000000
echo "\nInc TSD:"
time benchmarks_build/inc/light_control 10000000


########## benchmarks for planets ##########
echo "\n########## benchmarks for planets ##########"
echo "---------- with 10 planets, running 1000 times"
echo "RML:"
time benchmarks_build/rml/planets 10 1000
echo "\nPlain TSD:"
time benchmarks_build/planets 10 1000
echo "\nInc TSD:"
time benchmarks_build/inc/planets 10 1000
echo "\n---------- with 100 planets, running 1000 times"
echo "RML:"
time benchmarks_build/rml/planets 100 1000
echo "\nPlain TSD:"
time benchmarks_build/planets 100 1000
echo "\nInc TSD:"
time benchmarks_build/inc/planets 100 1000
echo "\n---------- with 1000 planets, running 1000 times"
echo "RML:"
time benchmarks_build/rml/planets 1000 1000
echo "\nPlain TSD:"
time benchmarks_build/planets 1000 1000
echo "\nInc TSD:"
time benchmarks_build/inc/planets 1000 1000


########## benchmarks for Alt-sum ##########
echo "\n########## benchmarks for Alt-sum ##########"
echo "---------- with 100000 inputs"
echo "RML:"
time benchmarks_build/rml/alt_sum 100000 
echo "\nPlain TSD:"
time benchmarks_build/alt_sum 100000
echo "\nInc TSD:"
time benchmarks_build/inc/alt_sum 100000
echo "---------- with 1000000 inputs"
echo "RML:"
time benchmarks_build/rml/alt_sum 1000000
echo "\nPlain TSD:"
time benchmarks_build/alt_sum 1000000
echo "\nInc TSD:"
time benchmarks_build/inc/alt_sum 1000000
echo "---------- with 10000000 inputs"
echo "RML:"
time benchmarks_build/rml/alt_sum 10000000
echo "\nPlain TSD:"
time benchmarks_build/alt_sum 10000000
echo "\nInc TSD:"
time benchmarks_build/inc/alt_sum 10000000


########## benchmarks for FIR (naive) ##########
echo "\n########## benchmarks for FIR (naive) ##########"
echo "---------- p = 10, with 100000 steps" 
echo "RML:"
time benchmarks_build/rml/fir 10 100000
echo "\nPlain TSD:"
time benchmarks_build/fir 10 100000
echo "\nInc TSD:"
time benchmarks_build/inc/fir 10 100000
echo "---------- p = 100, with 100000 steps"
echo "RML:"
time benchmarks_build/rml/fir 100 100000
echo "\nPlain TSD:"
time benchmarks_build/fir 100 100000
echo "\nInc TSD:"
time benchmarks_build/inc/fir 100 100000
echo "---------- p = 1000, with 100000 steps"
echo "RML:"
time benchmarks_build/rml/fir 1000 100000
echo "\nPlain TSD:"
time benchmarks_build/fir 1000 100000
echo "\nInc TSD:"
time benchmarks_build/inc/fir 1000 100000


########## benchmarks for FIR (opt) ##########
echo "\n########## benchmarks for FIR (opt) ##########"
echo "---------- p = 10, with 100000 steps"
echo "\nPlain TSD:"
time benchmarks_build/fir_opt 10 100000
echo "\nInc TSD:"
time benchmarks_build/inc/fir_opt 10 100000
echo "---------- p = 100, with 100000 steps"
echo "\nPlain TSD:"
time benchmarks_build/fir_opt 100 100000
echo "\nInc TSD:"
time benchmarks_build/inc/fir_opt 100 100000
echo "---------- p = 1000, with 100000 steps"
echo "\nPlain TSD:"
time benchmarks_build/fir_opt 1000 100000
echo "\nInc TSD:"
time benchmarks_build/inc/fir_opt 1000 100000


########## benchmarks for IIR (naive) ##########
echo "\n########## benchmarks for IIR (naive) ##########"
echo "---------- p = 10, q = 10, with 100000 steps"
echo "RML:"
time benchmarks_build/rml/iir 10 10 100000
echo "\nPlain TSD:"
time benchmarks_build/iir 10 10 100000
echo "\nInc TSD:"
time benchmarks_build/inc/iir 10 10 100000
echo "---------- p = 100, q = 100, with 100000 steps"
echo "RML:"
time benchmarks_build/rml/iir 100 100 100000
echo "\nPlain TSD:"
time benchmarks_build/iir 100 100 100000
echo "\nInc TSD:"
time benchmarks_build/inc/iir 100 100 100000
echo "---------- p = 1000, q = 1000, with 100000 steps"
echo "RML:"
time benchmarks_build/rml/iir 1000 1000 100000
echo "\nPlain TSD:"
time benchmarks_build/iir 1000 1000 100000
echo "\nInc TSD:"
time benchmarks_build/inc/iir 1000 1000 100000


########## benchmarks for IIR (opt) ##########
echo "\n########## benchmarks for IIR (opt) ##########"
echo "---------- p = 10, q = 10, with 100000 steps"
echo "\nPlain TSD:"
time benchmarks_build/iir_opt 10 10 100000
echo "\nInc TSD:"
time benchmarks_build/inc/iir_opt 10 10 100000
echo "---------- p = 100, q = 100, with 100000 steps"
echo "\nPlain TSD:"
time benchmarks_build/iir_opt 100 100 100000
echo "\nInc TSD:"
time benchmarks_build/inc/iir_opt 100 100 100000
echo "---------- p = 1000, q = 1000, with 100000 steps"
echo "\nPlain TSD:"
time benchmarks_build/iir_opt 1000 1000 100000
echo "\nInc TSD:"
time benchmarks_build/inc/iir_opt 1000 1000 100000


########## benchmarks for Page rank (naive) ##########
echo "\n########## benchmarks for Page rank (naive) ##########"
echo "---------- with 10 pages and 100 steps"
echo "RML:"
time benchmarks_build/rml/page_rank 10 100
echo "\nPlain TSD:"
time benchmarks_build/page_rank 10 100
echo "\nInc TSD:"
time benchmarks_build/inc/page_rank 10 100
echo "---------- with 100 pages and 100 steps"
echo "RML:"
time benchmarks_build/rml/page_rank 100 100
echo "\nPlain TSD:"
time benchmarks_build/page_rank 100 100
echo "\nInc TSD:"
time benchmarks_build/inc/page_rank 100 100
echo "---------- with 1000 pages and 100 steps"
echo "RML:"
time benchmarks_build/rml/page_rank 1000 100
echo "\nPlain TSD:"
time benchmarks_build/page_rank 1000 100
echo "\nInc TSD:"
time benchmarks_build/inc/page_rank 1000 100


########## benchmarks for Page rank (opt) ##########
echo "\n########## benchmarks for Page rank (opt) ##########"
echo "---------- with 10 pages and 100 steps"
echo "\nPlain TSD:"
time benchmarks_build/page_rank_opt 10 100
echo "\nInc TSD:"
time benchmarks_build/inc/page_rank_opt 10 100
echo "---------- with 100 pages and 100 steps"
echo "\nPlain TSD:"
time benchmarks_build/page_rank_opt 100 100
echo "\nInc TSD:"
time benchmarks_build/inc/page_rank_opt 100 100
echo "---------- with 1000 pages and 100 steps"
echo "\nPlain TSD:"
time benchmarks_build/page_rank_opt 1000 100
echo "\nInc TSD:"
time benchmarks_build/inc/page_rank_opt 1000 100


########## benchmarks for Map ##########
echo "\n########## benchmarks for Map ##########"
echo "---------- with 1000 nodes"
echo "RML:"
time benchmarks_build/rml/map_ex 1000
echo "\nPlain TSD:"
time benchmarks_build/map_ex 1000
echo "\nInc TSD:"
time benchmarks_build/inc/map_ex 1000
echo "---------- with 10000 nodes"
echo "RML:"
time benchmarks_build/rml/map_ex 10000
echo "\nPlain TSD:"
time benchmarks_build/map_ex 10000
echo "\nInc TSD:"
time benchmarks_build/inc/map_ex 10000
echo "---------- with 100000 nodes"
echo "RML:"
time benchmarks_build/rml/map_ex 100000
echo "\nPlain TSD:"
time benchmarks_build/map_ex 100000
echo "\nInc TSD:"
time benchmarks_build/inc/map_ex 100000


########## benchmarks for Fold-sum ##########
echo "\n########## benchmarks for Fold-sum ##########"
echo "---------- with 100 nodes"
echo "RML:"
time benchmarks_build/rml/fold_sum 100
echo "\nPlain TSD:"
time benchmarks_build/fold_sum 100
echo "\nInc TSD:"
time benchmarks_build/inc/fold_sum 100
echo "\n########## benchmarks for Fold-sum ##########"
echo "---------- with 1000 nodes"
echo "RML:"
time benchmarks_build/rml/fold_sum 1000
echo "\nPlain TSD:"
time benchmarks_build/fold_sum 1000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_sum 1000 
echo "\n########## benchmarks for Fold-sum ##########"
echo "---------- with 10000 nodes"
echo "RML:"
time benchmarks_build/rml/fold_sum 10000
echo "\nPlain TSD:"
time benchmarks_build/fold_sum 10000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_sum 10000 


########## benchmarks for Fold-sum (2) ##########
echo "\n########## benchmarks for Fold-sum (2) ##########"
echo "---------- with 100 nodes"
echo "\nPlain TSD:"
time benchmarks_build/fold_sum_2 100
echo "\nInc TSD:"
time benchmarks_build/inc/fold_sum_2 100 
echo "\n########## benchmarks for Fold-sum ##########"
echo "---------- with 1000 nodes"
echo "\nPlain TSD:"
time benchmarks_build/fold_sum_2 1000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_sum_2 1000 
echo "\n########## benchmarks for Fold-sum ##########"
echo "---------- with 10000 nodes"
echo "\nPlain TSD:"
time benchmarks_build/fold_sum_2 10000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_sum_2 10000 


########## benchmarks for Fold-max ##########
echo "\n########## benchmarks for Fold-max ##########"
echo "---------- with 100 nodes"
echo "RML:"
time benchmarks_build/rml/fold_max 100
echo "\nPlain TSD:"
time benchmarks_build/fold_max 100
echo "\nInc TSD:"
time benchmarks_build/inc/fold_max 100 
echo "\n########## benchmarks for Fold-max ##########"
echo "---------- with 1000 nodes"
echo "RML:"
time benchmarks_build/rml/fold_max 1000
echo "\nPlain TSD:"
time benchmarks_build/fold_max 1000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_max 1000 
echo "\n########## benchmarks for Fold-max ##########"
echo "---------- with 10000 nodes"
echo "RML:"
time benchmarks_build/rml/fold_max 10000
echo "\nPlain TSD:"
time benchmarks_build/fold_max 10000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_max 10000 


########## benchmarks for Fold-max (2) ##########
echo "\n########## benchmarks for Fold-max (2) ##########"
echo "---------- with 100 nodes"
echo "\nPlain TSD:"
time benchmarks_build/fold_max_2 100
echo "\nInc TSD:"
time benchmarks_build/inc/fold_max_2 100 
echo "\n########## benchmarks for Fold-max ##########"
echo "---------- with 10000 nodes"
echo "\nPlain TSD:"
time benchmarks_build/fold_max_2 1000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_max_2 1000 
echo "\n########## benchmarks for Fold-max ##########"
echo "---------- with 100000 nodes"
echo "\nPlain TSD:"
time benchmarks_build/fold_max_2 10000
echo "\nInc TSD:"
time benchmarks_build/inc/fold_max_2 10000 


########## benchmarks for chain ##########
echo "\n########## benchmarks for chain ##########"
echo "---------- with 1000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/chain 1000
echo "\nPlain TSD:"
time benchmarks_build/chain 1000
echo "\nInc TSD:"
time benchmarks_build/inc/chain 1000
echo "\n---------- with 10000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/chain 10000
echo "\nPlain TSD:"
time benchmarks_build/chain 10000
echo "\nInc TSD:"
time benchmarks_build/inc/chain 10000
echo "\n---------- with 100000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/chain 100000
echo "\nInc TSD:"
time benchmarks_build/inc/chain 100000
echo "\n---------- with 1000000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/chain 1000000
echo "\nInc TSD:"
time benchmarks_build/inc/chain 1000000
echo "\n---------- with 10000000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/chain 10000000
echo "\nInc TSD:"
time benchmarks_build/inc/chain 10000000


########## benchmarks for field ##########
echo "\n########## benchmarks for field ##########"
echo "---------- with 1000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/field 1000 
echo "\nPlain TSD:"
time benchmarks_build/field 1000 
echo "\nInc TSD:"
time benchmarks_build/inc/field 1000 
echo "\n---------- with 10000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/field 10000 
echo "\nPlain TSD:"
time benchmarks_build/field 10000 
echo "\nInc TSD:"
time benchmarks_build/inc/field 10000 
echo "\n---------- with 100000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/field 100000 
echo "\nPlain TSD:"
time benchmarks_build/field 100000 
echo "\nInc TSD:"
time benchmarks_build/inc/field 100000 
echo "\n---------- with 1000000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/field 1000000 
echo "\nPlain TSD:"
time benchmarks_build/field 1000000 
echo "\nInc TSD:"
time benchmarks_build/inc/field 1000000 
echo "\n---------- with 10000000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/field 10000000 
echo "\nPlain TSD:"
time benchmarks_build/field 10000000 
echo "\nInc TSD:"
time benchmarks_build/inc/field 10000000 


########## benchmarks for tree ##########
echo "\n########## benchmarks for tree ##########"
echo "---------- with 1000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/tree 1000 10
echo "\nPlain TSD:"
time benchmarks_build/tree 1000 10
echo "\nInc TSD:"
time benchmarks_build/inc/tree 1000 10
echo "\n---------- with 10000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/tree 10000 10
echo "\nPlain TSD:"
time benchmarks_build/tree 10000 10
echo "\nInc TSD:"
time benchmarks_build/inc/tree 10000 10
echo "\n---------- with 100000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/tree 100000 10
echo "\nPlain TSD:"
time benchmarks_build/tree 100000 10
echo "\nInc TSD:"
time benchmarks_build/inc/tree 100000 10
echo "\n---------- with 1000000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/tree 1000000 10
echo "\nPlain TSD:"
time benchmarks_build/tree 1000000 10
echo "\nInc TSD:"
time benchmarks_build/inc/tree 1000000 10
echo "\n---------- with 10000000 nodes"
echo "Incr Library:"
time benchmarks_build/incjs/tree 10000000 10
echo "\nPlain TSD:"
time benchmarks_build/tree 10000000 10
echo "\nInc TSD:"
time benchmarks_build/inc/tree 10000000 10



