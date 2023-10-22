#! /usr/bin/env julia

word_space = Channel{Any}(32)
freq_space = Channel{Any}(32)

stop_words = split(read(open("../stop_words.txt"), String), ",")

poison_pill = "_POISON_PILL_"

function process_words()
    freqs = Dict{String, Int64}()
    while true
        w = take!(word_space)
        if w == poison_pill
            break
        end
        if !(w in stop_words)
            freqs[w] = get(freqs, w, 0) + 1
        end
    end
    put!(freq_space, freqs)
end

W = 5

workers = [@task begin process_words() end for _ in 1:W]

[schedule(t) for t in workers]

for w in eachmatch(r"[a-z]{2,}", read(open(ARGS[1]), String) |> lowercase)
    put!(word_space, w.match)
end
for _ in 1:W
    put!(word_space, poison_pill)
end

[wait(t) for t in workers]

counts = Dict{String, Int64}()
while !isempty(freq_space)
    u = take!(freq_space)
    for (w, c) in u
        counts[w] = get(counts, w, 0) + c
    end
end

for (k, v) in sort(collect(counts); by = x -> x.second, rev = true)[1:25]
    println(k, " - ", v)
end

### end

