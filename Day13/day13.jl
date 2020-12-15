using DataFrames

input = joinpath(@__DIR__, "input.txt")

function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

notes = readInput(input)


timestamp, shuttles = parse(Int, split(notes)[1]), split(notes)[2]

in_service = [parse(Int, id) for id in split(shuttles, ",") if id != "x"]

for shuttle_id ∈ in_service
    println(timestamp/shuttle_id)
end

min_cycles = timestamp .÷ in_service
remainders = timestamp .% in_service

waiting_times = min_cycles .* in_service .+ in_service

best_shuttle = in_service[argmin(waiting_times)]
lowest_wait = waiting_times[argmin(waiting_times)]

result = best_shuttle * remainders[argmin(waiting_times)]

answer = "Choose shuttle id $best_shuttle for waiting time of $lowest_wait"


df = DataFrame(
    id = in_service,
    cycles = min_cycles,
    remainders = remainders,
    total_time = waiting_times,
    wait_time = waiting_times .- timestamp
)

show(df, allrows=true)
