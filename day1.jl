using Test

function new_frequency(change_string)
    accumulate(+, map(change -> parse(Int32, change),
                      split(change_string, r"[,\s]+", keepempty=false))
               )[end]
end

@testset "Day 1 Frequency Strings" begin
    @test new_frequency("+1, -2, +3, +1") == 3
    @test new_frequency("+1, +1, +1") == 3
    @test new_frequency("+1, +1, -2") == 0
    @test new_frequency("-1, -2, -3") == -6
end

input = open("day1.input")
println("Day 1 answer is ", new_frequency(read(input, String)))
