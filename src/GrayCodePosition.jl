module GrayCodePosition

import Base: eltype, length, diff, iterate, getindex, signed

export GrayCode, GrayCodePositions, gray, graytransient, signedgraytransient

"""
GrayCode(n::Integer)
Represents the [Gray code](https://en.wikipedia.org/wiki/Gray_code) over `n` bits. `n` must be positive. 
GrayCode implements iteration to generate all codewords.
"""
struct GrayCode
    nbits::Int64
    function GrayCode(n::Integer)
        n <= 0 && Base.throw(ArgumentError("Code must have positive length!")) 
        new(n)
    end
end
eltype(::GrayCode) = Int64
diff(code::GrayCode) = GrayCodePositions(code)
length(code::GrayCode) = (1 << code.nbits)

iterate(code::GrayCode) = (0,1)
"""
    gray(n::Integer)

Compute the `n`th Gray codeword.
"""
@inline gray(n::Integer) = n ⊻ (n >> 1)
function iterate(code::GrayCode, state)  
    state == length(code) && return nothing
    (gray(state),state + 1)
end
Base.@propagate_inbounds function Base.getindex(code::GrayCode, n::Integer)
    1 <= n <= length(code) || Base.throw(BoundsError(code,n))
    gray(n-1) # As we use 1-based indexing
end

"""
    GrayCodePositions[{signed::Bool}](code::GrayCode)

Represents the sequence of transient indices of a Gray code. 
The `i`th transient index is the position of the bit of `code[i]` that is flipped to obtain `code[i+1]`.
The entire sequence can be generated by iteration. 
The optional `signed` type parameter (default `false`) gives the signed transient sequence, a positive (negative) sign indicating the bit is set (reset).

**Note:** The returned transient indices are `1`-based.  
"""
struct GrayCodePositions{signed} 
    code::GrayCode
    GrayCodePositions(code) = new{false}(code)
    function GrayCodePositions{T}(code) where T
        typeof(T) == Bool || throw(ArgumentError("Type argument must be Bool")); 
        return new{T}(code)
    end
end
const GCP = GrayCodePositions;
issigned(::GCP{signed}) where signed = signed
signed(gcp::GCP{true}) = gcp; signed(gcp::GCP{false}) = GCP{true}(gcp.code)
eltype(::GCP) = Int64; 
# Note the varying positions are one less than the total number of codes
length(gcp::GCP) = length(gcp.code) - 1

iterate(gcp::GCP) =  (graytransient(1), 1)
"""
    graytransient(n::Integer)

Compute the `n`th Gray code transient index, in `1`-based indexing.
"""
@inline graytransient(n::Integer) = trailing_zeros(n) + 1
function Base.iterate(gcp::GCP, state) 
    state == length(gcp) && return nothing
    state+=1;
    if !issigned(gcp) 
        return (graytransient(state), state)
   else
        return (signedgraytransient(state), state)
   end 
end
Base.@propagate_inbounds function Base.getindex(gcp::GCP, n ::Integer) 
   1 <= n <= length(gcp) || Base.throw(BoundsError(gcp, n))
   if !issigned(gcp) 
        return graytransient(n)
   else
        return signedgraytransient(n)
   end 
end

"""
    signedgraytransient(n::Integer)

Compute the `n`th signed Gray code transient index, in `1`-based indexing.
"""
@inline function signedgraytransient(n::T) where T <:Integer
    g = gray(n);
    pos = graytransient(n);
    ifelse(g & (1 << (pos - one(T))) == 0, -pos, pos) 
end 

end

