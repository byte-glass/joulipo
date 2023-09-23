#! /usr/bin/env julia

function count!(words, stop_words, counts)
    if isempty(words)
        return
    else
        w = words[1]
        if !(w in stop_words)
            counts[w] = get(counts, w, 0) + 1
        end
        return count!(view(words, 2:length(words)), stop_words, counts)
    end
end

function wf_print(counts)
    if isempty(counts)
        return
    else
        (w, c) = counts[1]
        println(w, " - ", c)
        wf_print(view(counts, 2:length(counts)))
    end
end

stop_words = split(read(open("../stop_words.txt"), String), ",")
words = [w.match for w in eachmatch(r"[a-z]{2,}", read(open(ARGS[1]), String) |> lowercase)]
N = length(words)
BLOCK = 15000
counts = Dict{String, Int64}()
for i in range(1, N, step = BLOCK)
    count!(view(words, i:min(i + BLOCK - 1, N)), stop_words, counts)
end
wf_print(sort(collect(counts); by = x -> x.second, rev = true)[1:25])


### end
