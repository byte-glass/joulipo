#! /usr/bin/env julia


struct TheOne
    value::Any
end

function value(t::TheOne)
    return t.value
end

function printme(t::TheOne)
    print(value(t))
end

function bind(t::TheOne, func)
    TheOne(func(value(t)))
end

function read_file(path_to_file)
    open(path_to_file) do f
        read(f, String)
    end
end

function filter_chars(str_data)
    replace(str_data, r"[\W_]+" => " ")
end

function scan(str_data)
    split(str_data)
end

function remove_stop_words(words)
    stop_words = open("../stop_words.txt") do f
        vcat(split(read(f, String), ","), map(string, 'a':'z'))
    end
    [w for w in words if !(w in stop_words)]
end

function count(words)
    counts = Dict{String, Int64}()
    for w in words
        counts[w] = get(counts, w, 0) + 1
    end
    return counts
end

import Base.sort

function sort(counts)
    sort(collect(counts); by = x -> x.second, rev = true)
end

function top25(counts)
    s = ""
    for (w, c) in counts[1:25]
        s *= string(w, " - ", c, "\n")
    end
    return s
end


ARG = ["../pride-and-prejudice.txt"]

t = TheOne(ARGS[1]) |> 
    t -> bind(t, read_file) |>
    t -> bind(t, filter_chars) |>
    t -> bind(t, lowercase) |>
    t -> bind(t, split) |>
    t -> bind(t, remove_stop_words) |>
    t -> bind(t, count) |>
    t -> bind(t, sort) |>
    t -> bind(t, top25) |>
    printme


### end
