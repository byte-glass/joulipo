#! /usr/bin/env julia


function extract_words!(obj, path_to_file)
    s = open(path_to_file) do f read(f, String) end
    obj["data"] = replace(s, r"[\W_]+" => " ") |> lowercase |> split
    return
end

function load_stop_words!(obj)
    s = open("../stop_words.txt") do f read(f, String) end
    obj["stop_words"] = vcat(split(s, ","), map(string, 'a':'z'))
    return
end

function increment_count!(obj, w)
    obj["counts"][w] = get(obj["counts"], w, 0) + 1
    return
end

##

data_storage_obj = 
    Dict(
         "data" => Vector{String}(),
         "init" => path_to_file -> extract_words!(data_storage_obj, path_to_file),
         "words" => () -> data_storage_obj["data"])

stop_words_obj =
    Dict(
         "stop_words" => Vector{String}(),
         "init" => () -> load_stop_words!(stop_words_obj),
         "is_stop_word" => word -> word in stop_words_obj["stop_words"])

word_counts_obj =
    Dict(
         "counts" => Dict{String, Int64}(),
         "increment_count" => w -> increment_count!(word_counts_obj, w),
         "sorted" => () -> sort(collect(word_counts_obj["counts"]); by = x -> x.second, rev = true))

##

data_storage_obj["init"](ARGS[1])
stop_words_obj["init"]()

for w in data_storage_obj["words"]()
    if !stop_words_obj["is_stop_word"](w)
        word_counts_obj["increment_count"](w)
    end
end

for (w, c) in word_counts_obj["sorted"]()[1:25]
    println(w, " - ", c)
end


### end
