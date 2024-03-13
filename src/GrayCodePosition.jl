module GrayCodePosition

import Base: eltype, length, diff, iterate

export GrayCode, GrayCodePositions

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
function iterate(code::GrayCode, state)  
 state == length(code) && return nothing
 (state ⊻ (state >> 1),state + 1)
end

struct GrayCodePositions
    code::GrayCode
end
const GCP = GrayCodePositions;


eltype(::GCP) = Int64; 
# Note the varying positions are one less than the total number of codes
length(gcp::GCP) = length(gcp.code) - 1
iterate(gcp::GCP) =  (one(eltype(gcp)), 1)

function Base.iterate(gcp::GCP, state) 
    state == length(gcp) && return nothing
    n = state + 1;
    (trailing_zeros(n) + 1, n)
end 

end
