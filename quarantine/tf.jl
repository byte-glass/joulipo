#! /usr/bin/env julia


## Quarantine

mutable struct Quarantine
    functions::Vector{Any}
    function Quarantine(v::Any)
        new([v])
    end
end

function bind!(q::Quarantine, f::Any)
    push!(q.functions, f)
    q
end

function execute(q::Quarantine)
    function guard_callable(v)
        if isa(v, Function)
            v()
        else
            v
        end
    end
    value = () -> nothing
    for f in q.functions
        value = f(guard_callable(value))
    end
    value
end


## basic functions

function get_input(_arg)
    () -> ARGS[1]
end

function extract_words(path_to_file)
    function ()
        s = open(path_to_file) do f 
            read(f, String) 
        end
        replace(s, r"[\W_]+" => " ") |> lowercase |> split
    end
end

function remove_stop_words(word_list)
    function ()
        stop_words = open("../stop_words.txt") do f
            split(read(f, String), ",")
        end
        ascii_lowercase = map(string, 'a':'z')
        stop = vcat(stop_words, ascii_lowercase)
        [w for w in word_list if !(w in stop)]
    end
end


function counts(word_list)
    c = Dict{String, Int64}()
    for w in word_list
        c[w] = get(c, w, 0) + 1
    end
    c
end

import Base.sort

function sort(counts::Dict)
    sort(collect(counts); by = x -> x.second, rev = true)
end

function top25(counts)
    s = ""
    for (w, c) in counts[1:25]
        s *= string(w, " - ", c, "\n")
    end
    return s
end


## main program

Quarantine(get_input) |>
    q -> bind!(q, extract_words) |>
    q -> bind!(q, remove_stop_words) |>
    q -> bind!(q, counts) |>
    q -> bind!(q, sort) |>
    q -> bind!(q, top25) |>
    execute |> print


### end
