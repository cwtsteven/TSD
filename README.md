# TSD
An Ocaml implementation of Transparent Synchronous Dataflow

## Requirements
1. Ocaml 4.05.0 
2. In order to run the benchmarks for ReactiveML and JaneStreet Incremental Library, please make sure the following are installed. 
   - ReactiveML: http://rml.lri.fr/
   - Inc: `incremental` package in opam

## Installation
1. To pin and install the TSD package, run `opam pin add tsd .` while at the main directory. 
2. To uninstall, run `opam uninstall tsd` 
3. To reinstall, 1) run `sh clean.sh` to clean up builds and 2) run `opam install tsd`

## Compilation 
Run `ocamlfind ocamlc -package tsd,tsd.ppx -o $TARGET -linkpkg $SOURCE` to compile your favourite programs. 

## Examples and Benchmarks
1. To build all the examples, simply run `sh build_examples.sh`. 
2. To execute the benchmarks, simply run `sh run_benchmarks.sh`. 
