#! /usr/bin/env julia

using Test

function letter_count(id)
    dict = Dict()
    for (j, letter) in enumerate(id)
        if haskey(dict, letter)
            dict[letter] = dict[letter] + 1
        else
            dict[letter] = 1
        end
    end
    dict
end

function has_exactly_two(id)
    2 in values(letter_count(id))
end

function has_exactly_three(id)
    3 in values(letter_count(id))
end

function checksum(ids)
    twos = 0
    threes = 0
    for id in split(ids)
        if has_exactly_two(id)
            twos += 1
        end
        if has_exactly_three(id)
            threes += 1
        end
    end
    twos * threes
end

@testset "Day 2" begin
    @testset "letter_count" begin
        @test letter_count("abcdef") == Dict('a' => 1, 'b' => 1, 'c' => 1, 'd' => 1, 'e' => 1, 'f' => 1)
        @test letter_count("bababc") == Dict('a' => 2, 'b' => 3, 'c' => 1)
        @test letter_count("abbcde") == Dict('a' => 1, 'b' => 2, 'c' => 1, 'd' => 1, 'e' => 1)
        @test letter_count("aabcdd") == Dict('a' => 2, 'b' => 1, 'c' => 1, 'd' => 2)
    end

    @testset "has_exactly_two" begin
        @test has_exactly_two("abcdef") == false
        @test has_exactly_two("bababc") == true
        @test has_exactly_two("abbcde") == true
        @test has_exactly_two("aabcdd") == true
    end

    @testset "has_exactly_three" begin
        @test has_exactly_three("abcdef") == false
        @test has_exactly_three("bababc") == true
        @test has_exactly_three("abbcde") == false
        @test has_exactly_three("aabcdd") == false
    end

    @testset "checksum" begin
        input = "abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab"
        @test checksum(input) == 12
    end
end

input = read(open("day2.input"), String)

println("Day 2 Star 1 answer is ", checksum(input))
