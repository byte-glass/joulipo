# A.jl

module A


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


import TF: extract_words as extract_words_raw, counts as counts_raw, order as order_raw


extract_words = profile(NamedFunction(extract_words_raw, "extract_words"))
counts = profile(NamedFunction(counts_raw, "counts"))
order = profile(NamedFunction(order_raw, "order"))


export extract_words, counts, order


end

### end
