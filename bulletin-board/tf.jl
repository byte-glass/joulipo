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

event_manager = 
    Dict(
         "subscriptions" => Dict{String, Vector}(),
         "subscribe" => 
            function (event_type, handler) 
                if !haskey(event_manager["subscriptions"], event_type)
                    event_manager["subscriptions"][event_type] = Vector()
                end
                push!(event_manager["subscriptions"][event_type], handler)
                return
            end,
         "publish" => 
            function (event)
                event_type = event[1]
                if haskey(event_manager["subscriptions"], event_type)
                    for h in event_manager["subscriptions"][event_type]
                        h(event[2])
                    end
                end
            end)




data_storage_obj = 
    Dict(
         "data" => Vector{String}(),
         "load" => path_to_file -> extract_words!(data_storage_obj, path_to_file),
         "produce_words" => 
            function (null)
                for w in data_storage_obj["data"]
                    event_manager["publish"](("word", w))
                end
                # event_manager["publish"](('eof', false))
            end)

event_manager["subscribe"]("load", data_storage_obj["load"])
event_manager["subscribe"]("start", data_storage_obj["produce_words"])


stop_word_filter =
    Dict(
         "stop_words" => Vector{String}(),
         "load" => null -> load_stop_words!(stop_word_filter),
         "is_stop_word" => 
             function (w)
                 if !(w in stop_word_filter["stop_words"])
                     event_manager["publish"](("valid_word", w))
                 end
             end)


event_manager["subscribe"]("load", stop_word_filter["load"])
event_manager["subscribe"]("word", stop_word_filter["is_stop_word"])


word_counts_obj =
    Dict(
         "counts" => Dict{String, Int64}(),
         "increment_count" => w -> increment_count!(word_counts_obj, w),
         "print_counts" =>
             function (null)
                 for (w, c) in sort(collect(word_counts_obj["counts"]); by = x -> x.second, rev = true)[1:25]
                     println(w, " - ", c)
                 end
             end
        )

event_manager["subscribe"]("valid_word", word_counts_obj["increment_count"])
event_manager["subscribe"]("print", word_counts_obj["print_counts"])


# ARG = ["../pride-and-prejudice.txt"]

event_manager["publish"](("load", ARGS[1]))
event_manager["publish"](("start", false))
event_manager["publish"](("print", false))




### end
