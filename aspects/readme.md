# aspects

## `tf-x.jl`

Define the environment variable JULIA_LOAD_PATH and run the script `tf-x.jl`, e.g.

```sh
JULIA_LOAD_PATH="$JULIA_LOAD_PATH:$(pwd)" ./tf-x.jl ../pride-and-prejudice.txt
```

This will see to it that the necessary modules can be loaded.

Calculating the term frequencies is taken care of in the module `TF.jl` and the profiling is handled by the module `A.jl`.

### `import TF: extract_words as extract_words_raw`

The profiling relies on importing a function and giving it a new name in the process, i.e. `import .. as ..`. The modules e.g. `TF` and `A` provide name spaces in which the wrapped functionn can be given its appropriate name without clashes.

## `tf.jl`

The whole process can be rolled into a single file, see `tf.jl`.

## `setglobal!`

A different solution is implemented in `tf-b.jl`. It is more or less equivalent to the approach taken in the python original. There is something to look out for.

If a function is declared as follows,

```julia
function h(x)
    2x + 1
end
```

then `h` is a constant as far as julia is concerned and trying to change it with a call to `setglobal!` such as,

```julia
setglobal!(@__MODULE__, :h, profile(h))
```

will cause an error!

The way around this is to use slightly different syntax, namely

```julia
h = function (x) 2x + 1 end
```

I'm not sure what I make of this?!



### end
