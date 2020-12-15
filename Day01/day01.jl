# Set the input file
input_file = "inputs.txt"
# Read the inputs
expenses = []
open(input_file) do file
    for l in readlines(file)
        push!(expenses, parse(Float64, l))
    end
end

using Combinatorics

for c in combinations(expenses, 2)
    if sum(c) == 2020
        println("this one")
    end
end

[c for c in combinations(expenses, 2) if sum(c)==2020]˝˝