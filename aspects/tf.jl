#! /usr/bin/env julia

## TF

module TF

function extract_words(path_to_file)
    str_data = open(path_to_file) do f
        read(f, String)
    end
    words = replace(str_data, r"[\W_]+" => " ") |> lowercase |> split
    stop_words = open("../stop_words.txt") do f
        split(read(f, String), ",")
    end
    ascii_lowercase = map(string, 'a':'z')
    stop = vcat(stop_words, ascii_lowercase)
    [w for w in words if !(w in stop)]
end

function counts(words)
    c = Dict{String, Int64}()
    for w in words
        c[w] = get(c, w, 0) + 1
    end
    c
end

function order(counts::Dict)
    sort(collect(counts); by = x -> x.second, rev = true)
end

export extract_words, counts, order

end


## setup profiling

struct NamedFunction
    f::Function
    name::String
end

name(f::NamedFunction) = f.name

(phi::NamedFunction)(args...) = phi.f(args...)


function profile(f::NamedFunction)
    t = 
        function(args...)
            t0 = time()
            v = f(args...)
            t1 = time()
            println("$(name(f)) took $(t1 - t0) seconds")
            return v
        end
    return t
end


## profile functions from TF

import .TF: extract_words as extract_words_raw, counts as counts_raw, order as order_raw


extract_words = profile(NamedFunction(extract_words_raw, "extract_words"))
counts = profile(NamedFunction(counts_raw, "counts"))
order = profile(NamedFunction(order_raw, "order"))


## main 

frequencies = order(counts(extract_words(ARGS[1])))

for (w, c) in frequencies[1:25]
    println(w, " - ", c)
end


### end
