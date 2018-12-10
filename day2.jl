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

function off_by_one_substr(id1, id2)
    id1 = collect(id1)
    id2 = collect(id2)
    if (length(id1) != length(id2))
        return nothing
    end
    diff = id1 - id2
    if (length(filter(c -> c != 0, diff)) == 1)
        rval = Char[]
        for j = 1:length(id1)
            if id1[j] == id2[j]
                push!(rval, id1[j])
            end
        end
        return join(rval)
    end
    nothing
end

function find_first_off_by_one(inputs)
    ids = split(inputs, r"[\s]+", keepempty=false)
    for j = 1:length(ids)
        for k = (j+1):length(ids)
            result = off_by_one_substr(ids[j], ids[k])
            if result != nothing
                return result
            end
        end
    end
    return nothing
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

    @testset "off_by_one_substr" begin
        @test off_by_one_substr("abcde", "abcd") == nothing
        @test off_by_one_substr("abcde", "axcye") == nothing
        @test off_by_one_substr("fghij", "fguij") == "fgij"
    end

    @testset "find_first_off_by_one" begin
        input = "abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz"

        @test find_first_off_by_one(input) == "fgij"
    end
end

input = read(open("day2.input"), String)

println("Day 2 Star 1 answer is ", checksum(input))
println("Day 2 Star 1 answer is ", find_first_off_by_one(input))
