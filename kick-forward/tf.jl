#! /usr/bin/env julia

function read_file(path_to_file, func)
    data = open(path_to_file) do f
        read(f, String)
    end
    func(data, normalize)
end

function filter_chars(str_data, func)
    func(replace(str_data, r"[\W_]+" => " "), scan)
end

function normalize(str_data, func)
    func(lowercase(str_data), remove_stop_words)
end

function scan(str_data, func)
    func(split(str_data), count)
end

function remove_stop_words(words, func)
    stop_words = open("../stop_words.txt") do f
        vcat(split(read(f, String), ","), map(string, 'a':'z'))
    end
    func([w for w in words if !(w in stop_words)], sort)
end

function count(words, func)
    counts = Dict{String, Int64}()
    for w in words
        counts[w] = get(counts, w, 0) + 1
    end
    func(counts, print_counts)
end

import Base.sort

function sort(counts, func)
    func(sort(collect(counts); by = x -> x.second, rev = true), no_op)
end

function print_counts(counts, func)
    for (k, v) in counts[1:25]
        println(k, " - ", v)
    end
    func(false)
end

function no_op(func)
    return
end

path_to_file = "../pride-and-prejudice.txt"

read_file(ARGS[1], filter_chars)


### end
