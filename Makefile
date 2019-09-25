.PHONY: install uninstall clean examples benchmarks

install:	
	opam pin add tsd . 

uninstall:	
	@if [ -d "examples/build" ]; then rm -rf examples/build; fi
	@if [ -d "benchmarks/build" ]; then rm -rf benchmarks/build; fi
	opam uninstall tsd 
	opam unpin tsd 

clean: 	
	@if [ -d "examples/build" ]; then rm -rf examples/build; fi
	@if [ -d "benchmarks/build" ]; then rm -rf benchmarks/build; fi


examples: 
	@make -C examples

benchmarks: 	