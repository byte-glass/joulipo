#! /bin/env -S JULIA_PROJECT=. julia

## usage
#
#   ./tf-b.jl ../pride-and-prejudice.txt
#


using JuliaDB

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


words = extract_words(ARGS[1])
n = ones(Int64, length(words))
t = table((w = words, n = n), pkey = [:w])
u = sort(groupby(sum, t, :w, select = :n), :sum, rev = true)
for (w, c) in rows(u)[1:25]
    println(w, " - ", c)
end



### end
