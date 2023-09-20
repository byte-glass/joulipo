#! /usr/bin/env julia

# b.jl

pride_and_prejudice = "pride-and-prejudice.txt"

all_words = open(pride_and_prejudice) do f
    replace(read(f, String) |> lowercase, r"[\W_]+" => " ") |> split
end

stop_words = open("stop_words.txt") do f
    vcat(split(read(f, String), ","), map(string, 'a':'z'))
end

words = [w for w in all_words if !(w in stop_words)]

counts = Dict{String, Int64}()

for w in words
    counts[w] = get(counts, w, 0) + 1
end

t = sort(collect(counts); by = x -> x.second, rev = true)[1:25]

for (k, v) in t
    println(k, " - ", v)
end

println("length(words) is $(length(words))")


### end
