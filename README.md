# a-mir-formality

This repository aims to be a complete, authoratative formal model of the Rust MIR. At present, however, it is an incomplete, experimental model thereof. Presuming these experiments bear fruit, the intention is to bring this model to Rust as an RFC and develop it as an official part of the language definition.

## Tool

For the time being, the model is implemented in [PLT Redex](https://redex.racket-lang.org/). PLT Redex was chosen because it is ridiculously accessible and fun to use. It lets you write down type system rules and operational semantics in a notation that is very similar to what is commonly used in published papers and then execute them; you can also write collections of unit tests and fuzz your model by generating test programs automatically. The hope is that PLT Redex will prove to be a sufficiently accessible tool that many Rust contributors will be able to understand, play with, and extend the model.

One downside of PLT Redex is that it doesn't scale naturally to performing proofs. We may choose to port the model to another system at some point, or maintain multiple variants.

## Structure of the repository


