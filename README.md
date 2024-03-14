# GrayCodePosition

Lightweight package for [Gray codes](https://en.wikipedia.org/wiki/Gray_code) and their transient index sequences. 

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://BenjaminRemez.github.io/GrayCodePosition.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://BenjaminRemez.github.io/GrayCodePosition.jl/dev/)
[![Build Status](https://github.com/BenjaminRemez/GrayCodePosition.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/BenjaminRemez/GrayCodePosition.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/BenjaminRemez/GrayCodePosition.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/BenjaminRemez/GrayCodePosition.jl)

## Usage

Gray codes can be easily generated.
```julia
using GrayCodePosition
code = GrayCode(3) # Gray code (collection of all codewords) over 3 bits
for c in code println(bitstring(c)[end-2:end]) end
#= 
000
001
011
010
110
111
101
100
=#
```

Note the position of the bit changing between two successive codewords: 1, 2, 1, 3, 1, 2, and finally 1. These positions are called the transient indices. They can be generated and iterated as follows
```julia
using GrayCodePosition
code = GrayCode(3)
gcp = GrayCodePositions(code) # Equivalently, gcp = diff(code)
collect(gcp)'
# 1×7 adjoint(::Vector{Int64}) with eltype Int64:
# 1  2  1  3  1  2  1
```

# Example Usage
The transient index sequence of Gray codes is useful for efficiently iterating over all subsets of a given set. For example, to sum over the squares of every subset sum:
```julia
using GrayCodePosition

function sumsubsets_manual(v)
    total = zero(eltype(v))
    for n = 0:(2^length(v)-1)
        setsum = zero(eltype(v))
        for i in 1:length(v)
            setsum += ifelse(n & (1 << (i-1)) != 0, v[i], zero(eltype(v)))
        end
        total += setsum*setsum;
    end
    total
end

function sumsubsets_gray(v)
    setsum = zero(eltype(v));
    total = setsum;
    sgcp = signed(diff(GrayCode(length(v))))
    for i in 1:length(sgcp) 
        pos = sgcp[i]
        val = v[abs(pos)];
        setsum += ifelse(pos > 0, val, -val)
        total += setsum*setsum
    end
    
    total
end

v = rand(1:100, 30);
sumsubsets_manual(v) == sumsubsets_gray(v)
# true
@time sumsubsets_manual(v);
# 16.871554 seconds 
@time sumsubsets_gray(v);
#  1.744238 seconds 
``` 