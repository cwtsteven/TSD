.PHONY: install uninstall clean examples benchmarks

install:	
	rm -rf opam/
	oasis2opam --local
	opam pin add tsd . 

uninstall:	
	@if [ -d "examples/build" ]; then rm -rf examples/build; fi
	@if [ -d "benchmarks/build" ]; then rm -rf benchmarks/build; fi
	opam uninstall tsd 
	opam unpin tsd 

clean: 	
	@if [ -d "examples/build" ]; then rm -rf examples/build; fi
	@if [ -d "benchmarks/build" ]; then rm -rf benchmarks/build; fi
	@if [ -d "_build" ]; then rm -rf _build; fi
	@if [ -e "tsd_ext.native" ]; then rm tsd_ext.native; fi 

examples: 
	@make -C examples

benchmarks: 	
	@make -C benchmarks

translator: 
	@ocamlbuild -package compiler-libs.common ppx/tsd_ext.native

translate:
	@ocamlc -dsource -ppx ./tsd_ext.native $(SRC)