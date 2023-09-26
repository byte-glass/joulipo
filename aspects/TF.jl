# TF.jl

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

### end
