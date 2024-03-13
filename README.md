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
