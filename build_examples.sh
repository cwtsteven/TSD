rm -rf examples_build
mkdir examples_build
cp -R examples/* examples_build

for i in examples/*.ml; do
	NAME=$(basename $i .ml)
	ocamlfind ocamlopt -package tsd,tsd.ppx -o examples_build/$NAME -linkpkg examples_build/$NAME.ml
	TAR=${NAME}_inc
	cp examples/$NAME.ml examples_build/$TAR.ml
	sed -i "" "1s/.*/open Tsd_inc/" examples_build/$TAR.ml
	ocamlfind ocamlopt -package tsd,tsd.ppx -o examples_build/$TAR -linkpkg examples_build/$TAR.ml
done 