#! /usr/bin/env julia


push!(LOAD_PATH, pwd())

using A     # or using TF to run with profiling


frequencies = order(counts(extract_words(ARGS[1])))

for (w, c) in frequencies[1:25]
    println(w, " - ", c)
end

### end
