#! /usr/bin/env julia


## basic functions

extract_words = function(path_to_file)
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

counts = function(words)
    c = Dict{String, Int64}()
    for w in words
        c[w] = get(c, w, 0) + 1
    end
    c
end

order = function(counts::Dict)
    sort(collect(counts); by = x -> x.second, rev = true)
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


for f in [:extract_words, :counts, :order]
    setglobal!(@__MODULE__, f, profile(NamedFunction(getglobal(@__MODULE__, f), string(f))))
end


## main program

frequencies = order(counts(extract_words(ARGS[1])))

for (w, c) in frequencies[1:25]
    println(w, " - ", c)
end


### end
