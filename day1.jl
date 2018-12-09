using Test

function freq_changes_str_to_arr(change_string)
    map(change -> parse(Int32, change),
        split(change_string, r"[,\s]+", keepempty=false))
end

function next_frequency_impl(changes)
    accumulate(+, changes)[end]
end

function next_frequency(change_string)
    next_frequency_impl(freq_changes_str_to_arr(change_string))
end

@testset "Day 1 Frequency Strings" begin
    @test next_frequency("+1, -2, +3, +1") == 3
    @test next_frequency("+1, +1, +1") == 3
    @test next_frequency("+1, +1, -2") == 0
    @test next_frequency("-1, -2, -3") == -6
end

input = open("day1.input")
println("Day 1 answer is ", next_frequency(read(input, String)))
