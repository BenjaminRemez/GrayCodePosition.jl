using GrayCodePosition
using Test

@testset "Gray code generation & iteration" begin
    # Write your tests here.

    try
        c = GrayCode(-1) 
        @test false
        c = GrayCode(0)
        @test false
    catch
        @test true # test the exception was thrown
    end

    @test eltype(GrayCode(5)) == Int64
    for n in 1:8
        code = GrayCode(n);
        words = collect(code)
        @test length(words) == 2^n
        flag = true
        for i in 2:length(words)
            if count_ones(words[i] ⊻ words[i-1]) != 1
                flag = false;
                break
            end
        end
        @test flag
        @test sort(words) == 0:length(code)-1 
    end
end

@testset "Position generation & iteration" begin
    
    c = GrayCode(5)
    @test GrayCodePositions(c) == diff(c)
    @test eltype(diff(c)) == Int64
    for n in 1:8
        
        code = GrayCode(n);
        gcp = diff(code);
        @test length(gcp) == 2^n - 1;
        pos = collect(gcp);
        @test all(i -> 1 <= i <= n, pos)
        vs = [zero(eltype(gcp))]
        for i in pos
            # flip the i'th bit of the last entry and append
            push!(vs, last(vs) ⊻ (1 << (i-1)))
        end
        @test vs == collect(code)
    end

end