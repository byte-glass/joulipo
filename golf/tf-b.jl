#! /usr/bin/env julia

# golf/tf-b.jl

using Base.Iterators, DataStructures

stop_words = split(read(open("../stop_words.txt"), String), ",")
words = [w.match for w in eachmatch(r"[a-z]{2,}", read(open(ARGS[1]), String) |> lowercase) if !(w.match in stop_words)]
p = PriorityQueue{String, Int64}(Base.Order.Reverse); for w in words p[w] = get(p, w, 0) + 1 end
for (_, (k, v)) in take(enumerate(p), 25) println(k, " - ", v) end

    

### end
