#! /usr/bin/env julia

# a.jl

# println(ARGS[1])

f = open("input.txt")
s = read(f, String)
close(f)

s = open("input.txt") do f
    read(f, String)
end

# t = replace(s, r"[\W_]+" => " ")
# eachsplit(t) |> collect

words = replace(s, r"[\W_]+" => " ") |> split

words = open("input.txt") do f
    replace(read(f, String), r"[\W_]+" => " ") |> split
end

f = open("stop_words.txt")
s = read(f, String)
close(f)

stop_words = vcat(split(s, ","), map(string, 'a':'z'))

stop_words = open("stop_words.txt") do f
    vcat(split(read(f, String), ","), map(string, 'a':'z'))
end


[w for w in words if !(w in stop_words)]


### end
