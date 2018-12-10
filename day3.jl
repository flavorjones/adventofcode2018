#! /usr/bin/env julia

using Test
using AutoHashEquals

struct Claim
    id::UInt16
    x::UInt16
    y::UInt16
    width::UInt16
    height::UInt16
end

CLAIM_RE = r"#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)"

function new_claim_from_desc(desc)
    match = Base.match(CLAIM_RE, desc)
    if match == nothing
        return nothing
    end
    args = map(m -> parse(UInt16, m), match.captures)
    Claim(args...)
end

function new_claims_from_desc(desc_dump)
    map(d -> new_claim_from_desc(d), split(desc_dump, "\n", keepempty=false))
end


@auto_hash_equals struct Fabric
    squares::Array{UInt16}
end

function visualize(fabric)
    output = []
    size = Base.size(fabric.squares)
    for y = 1:size[2]
        for x = 1:size[1]
            val = fabric.squares[x,y]
            if val == 0
                push!(output, ".")
            else
                push!(output, val)
            end
        end
        if y != size[2]
            push!(output, "/")
        end
    end
    join(output)
end

function Base.show(io::IO, fabric::Fabric)
    print(io, visualize(fabric))
end

function new_fabric(size)
    Fabric(zeros(UInt16, size, size))
end

function for_each_fabric_claim(lambda, fabric, claim)
    x_start = claim.x + 1
    x_end = x_start + claim.width - 1
    y_start = claim.y + 1
    y_end = y_start + claim.height - 1
    for y = y_start:y_end
        for x = x_start:x_end
            lambda(fabric, x, y)
        end
    end
end

function claim_fabric(fabric, claim)
    for_each_fabric_claim(fabric, claim) do fabric, x, y
        fabric.squares[x, y] += 1
    end
end

function count_of_overclaimed_inches(fabric)
    count(x -> x > 1, fabric.squares)
end

@testset "Day 3" begin
    claim_dump = "#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2"

    @testset "new_claim_from_desc()" begin
        @test new_claim_from_desc(" 1   1 3  4 4") == nothing
        @test new_claim_from_desc("#1 @ 1,3: 4x4") == Claim(1, 1, 3, 4, 4)
    end

    @testset "new_fabric()" begin
        @test ndims(new_fabric(10).squares) == 2
        @test size(new_fabric(11).squares) == (11,11)
        @test count(iszero, new_fabric(3).squares) == 9
    end

    @testset "claim_fabric()" begin
        @testset "simple" begin
            fabric = new_fabric(6)
            expected = new_fabric(6)

            claim = new_claim_from_desc("#1 @ 1,3: 2x2")
            expected.squares[2,4] = 1
            expected.squares[2,5] = 1
            expected.squares[3,4] = 1
            expected.squares[3,5] = 1

            claim_fabric(fabric, claim)
            @test fabric == expected

            claim = new_claim_from_desc("#1 @ 2,2: 2x2")
            expected.squares[3,3] = 1
            expected.squares[3,4] = 2
            expected.squares[4,3] = 1
            expected.squares[4,4] = 1

            claim_fabric(fabric, claim)
            @test fabric == expected
        end

        @testset "complex" begin
            fabric = new_fabric(8)
            for claim in new_claims_from_desc(claim_dump)
                claim_fabric(fabric, claim)
            end
            @test visualize(fabric) == "......../...1111./...1111./.112211./.112211./.111111./.111111./........"
        end
    end

    @testset "count_of_overclaimed_inches()" begin
        fabric = new_fabric(8)
        for claim in new_claims_from_desc(claim_dump)
            claim_fabric(fabric, claim)
        end
        @test count_of_overclaimed_inches(fabric) == 4
    end
end

input = read(open("day3.input"), String)
fabric = new_fabric(1000)
for claim in new_claims_from_desc(input)
    claim_fabric(fabric, claim)
end
println("Day 3 Star 1 answer is ", count_of_overclaimed_inches(fabric))
