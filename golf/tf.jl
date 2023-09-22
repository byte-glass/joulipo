#! /usr/bin/env julia

# golf/tf.jl

using StatsBase

stop_words = split(read(open("../stop_words.txt"), String), ",")
words = [w.match for w in eachmatch(r"[a-z]{2,}", read(open(ARGS[1]), String) |> lowercase)]
counts = countmap([w for w in words if !(w in stop_words)])
for (k, v) in sort(collect(counts); by = x -> x.second, rev = true)[1:25]
    println(k, " - ", v)
end

### end
