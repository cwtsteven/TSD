.PHONY: all 

all: 
	@if [ -d "build" ]; then rm -rf build; fi
	@mkdir build 
	@for f in $(shell ls *.ml); do \
		NAME=$$(basename $${f} .ml); \
		INC=$${NAME}_inc; \
		echo "compiling $${NAME}.ml ....."; \
		cp $${f} build/; \
		cp $${f} build/$${INC}.ml; \
		sed -i "" "1s/.*/open Tsd_inc/" build/$${INC}.ml; \
		ocamlfind ocamlopt -w -1..66 -package tsd,tsd.ppx -o build/$${NAME} -linkpkg build/$${NAME}.ml; \
		ocamlfind ocamlopt -w -1..66 -package tsd,tsd.ppx -o build/$${INC} -linkpkg build/$${INC}.ml; \
	 done 
	@echo "Finished!" 