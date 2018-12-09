#! /usr/bin/env julia

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


function find_repeat_frequency_impl(changes)
    sum = 0
    freq_set = Set(sum)

    for (j, change) in enumerate(Iterators.cycle(changes))
        sum += change
        if in(sum, freq_set)
            break
        end
        push!(freq_set, sum)
    end

    sum
end

function find_repeat_frequency(change_string)
    find_repeat_frequency_impl(freq_changes_str_to_arr(change_string))
end

@testset "Day 1 Frequency Repeat" begin
    @test find_repeat_frequency("+1, -2, +3, +1") == 2
    @test find_repeat_frequency("+1, -1") == 0
    @test find_repeat_frequency("+3, +3, +4, -2, -4") == 10
    @test find_repeat_frequency("-6, +3, +8, +5, -6") == 5
    @test find_repeat_frequency("+7, +7, -2, -7, -4") == 14
end


function input()
    read(open("day1.input"), String)
end

println("Day 1 Star 1 answer is ", next_frequency(input()))
println("Day 1 Star 2 answer is ", find_repeat_frequency(input()))
