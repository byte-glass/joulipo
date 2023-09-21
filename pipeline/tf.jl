#! /usr/bin/env julia

# pipeline/tf.jl


function read_file(path_to_file)
    open(path_to_file) do f
        read(f, String)
    end
end

function filter_chars_and_normalize(str_data)
    replace(str_data, r"[\W_]+" => " ") |> lowercase
end

function scan(str_data)
    str_data |> split
end

function remove_stop_words(words)
    stop_words = open("../stop_words.txt") do f
        split(read(f, String), ",")
    end
    ascii_lowercase = map(string, 'a':'z')
    stop = vcat(stop_words, ascii_lowercase)
    [w for w in words if !(w in stop)]
end

function frequencies(words)
    f = Dict{String, Int64}()
    for w in words
        f[w] = get(f, w, 0) + 1
    end
    f
end

function sort_frequencies(f)
    sort(collect(f); by = x -> x.second, rev = true)
end

function print_all(frequencies)
    for (word, frequency) in frequencies
        println(word, " - ", frequency)
    end
end

print_all(sort_frequencies(frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file(ARGS[1]))))))[1:25])


### end
