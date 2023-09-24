#! /usr/bin/env julia

struct DataStorageManager
    _words::Vector{String}
    function DataStorageManager(path_to_file::String)
        s = open(path_to_file) do f
            read(f, String)
        end
        w = replace(s, r"[\W_]+" => " ") |> lowercase |> split
        new(w)
    end
end

words(m::DataStorageManager) = m._words


struct StopWordManager
    _stop_words::Vector{String}
    function StopWordManager()
        s = open("../stop_words.txt") do f
            read(f, String)
        end
        new(vcat(split(s, ","), map(string, 'a':'z')))
    end
end

is_stop_word(m::StopWordManager, w::String) = w in m._stop_words


struct WordCountManager
    _counts::Dict{String, Int64}
    WordCountManager() = new(Dict{String, Int64}())
end

function increment(m::WordCountManager, w::String) 
    m._counts[w] = get(m._counts, w, 0) + 1
end

function most_common(m::WordCountManager, n::Int)
    sort(collect(m._counts); by = x -> x.second, rev = true)[1:n]
end


struct WordFrequencyController
    data_storage_manager
    stop_word_manager
    word_count_manager
    function WordFrequencyController(path_to_file::String)
        new(DataStorageManager(path_to_file), StopWordManager(), WordCountManager())
    end
end

function run(c::WordFrequencyController)
    for w in words(c.data_storage_manager)
        if !is_stop_word(c.stop_word_manager, w)
            increment(c.word_count_manager, w)
        end
    end
    for (w, c) in most_common(c.word_count_manager, 25)
        println(w, " - ", c)
    end
end


run(WordFrequencyController(ARGS[1]))


### end
