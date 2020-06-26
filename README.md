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

## Running on utop
1. Run `#ppx "tsd_ext";;`
2. Run `#require "tsd";;`
3. Run `open Tsd;;`
4. Try running `let x = [%dfg 1];;` and it should work! 

## The TSD language extension and helper functions

An extensive description of the language and the underlying calculus can be found in the report [Transparent Synchronous Dataflow](https://arxiv.org/pdf/1910.09579.pdf). Here is a quick recap:

* `val peek : 'a graph -> 'a` : takes a node in a graph, evaluates it, and returns its value
* `val root : 'a graph -> 'a graph` : returns the dependencies of a cell (if it is not a cell it gives a runtime error)
* `val cell : 'a graph -> 'a graph` : takes a node in a graph as argument and returns a new cell dependent on the node
* `val link : 'a graph -> 'a graph -> unit` : takes a cell and a node and makes the node the (new) dependency of the cell (if the first argument is not a cell it gives a runtime error)
* `val (<~) : 'a graph -> 'a graph -> unit` : alias for `link`
* `val assign : 'a graph -> 'a -> unit` : change the value of a cell (runtime error if argument not a cell)
* `val (<:=) : 'a graph -> 'a -> unit` : alias for `assign`
* `val set : 'a graph -> 'a -> unit` : combination of `link` and `assign`
* `val (<:~) : 'a graph -> 'a -> unit` : alias for `set`
* `val init : unit -> unit` : deletes the dataflow graph
* `val step : unit -> bool` : propagates changes until every cell is changed at most once. It returns `true` if changes were made. 

The tag `[%dfg t]` always returns a node in a graph that corresponds to `t`. Note that this node is not a cell. For example
`let x = [%dfg 1]` creates a constant graph with node `1`. This  `let f = [%dfg fun x y -> x * y]` creates a function from graphs to graphs which can be used as follows:
```
let ( * ) = lift ( * );;
let f = [%dfg fun x y -> x * y];;
let x = cell [%dfg 1] ;;
let y = cell [%dfg 2] ;;
let m = [%dfg f x y];;
```
This creates a dataflow graph with two cells, initialised to 1 and 2, connected via multiplication to the node `x` (which is not a cell). 
