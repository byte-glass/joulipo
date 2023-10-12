#! /usr/bin/env julia

##
## usage: define the environment variable JULIA_LOAD_PATH and run the script `tf-x.jl`, e.g.
##
##  JULIA_LOAD_PATH="$JULIA_LOAD_PATH:$(pwd)" ./tf-x.jl ../pride-and-prejudice.txt
##


using A     # or using TF to run without profiling


frequencies = order(counts(extract_words(ARGS[1])))

for (w, c) in frequencies[1:25]
    println(w, " - ", c)
end

### end
