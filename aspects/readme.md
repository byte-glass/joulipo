# aspects

## usage

Run either `tf.jl`, e.g.

```sh
./tf.jl ../pride-and-prejudice.txt
```

or `tf-x.jl` in a similar way. The latter has the functionality defined in a module `TF.jl`, the profiling is handled by the module `A.jl` and the main program is run in `tf-x.jl`.

## `import TF: extract_words as extract_words_raw`

The profiling relies on importing a function and giving it a new name in the process, i.e. `import .. as ..`. The modules e.g. `TF` and `A` provide name spaces in which the wrapped functionn can be given its appropriate name without clashes.

The whole process can be rolled into a single file, see `tf.jl`.


### end
