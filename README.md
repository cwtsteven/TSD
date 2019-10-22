# TSD
An Ocaml implementation of Transparent Synchronous Dataflow

## Requirements
1. Ocaml 4.05.0 + 
2. `oasis2opam` package
2. In order to run the benchmarks for ReactiveML and JaneStreet Incremental Library, please make sure the following are installed. 
   - ReactiveML: http://rml.lri.fr/
   - Inc: `incremental` package in opam
   - Zelus: http://zelus.di.ens.fr/

## Installation
1. To pin and install the TSD package, run `make install` and follows the instruction. 
2. To uninstall, run `make uninstall` 

## Compilation 
Run `ocamlfind ocamlc -package tsd,tsd.ppx -o $TARGET -linkpkg $SOURCE` to compile your favourite programs. 

## Examples and Benchmarks
1. To build all the examples, simply run `make examples`. The compiled executable can be found in examples/build/$TARGET/$TARGET. 
2. To execute the benchmarks, simply run `make benchmarks`. 
