
# numbers = [1,20,11,6,12,0]
# numbers = [0,3,6]


spoken = Dict()

for entry in numbers
    try
        status = spoken[entry] 
    catch
        push!(spoken, entry => true)
        println("new")
    end
end

function startgame(numbers)
    previous = missing
    spoken = Dict()
    for (turn, entry) in enumerate(numbers)

        try
            push!(spoken[entry], turn)
        catch
            push!(spoken, entry => [turn])
        end

        previous = (turn, entry)
    end
    return previous, spoken
end


function taketurn(previous, spoken)
    prev_turn = previous[1]
    prev_speak = previous[2]

    this_turn = prev_turn + 1

    hist = spoken[prev_speak]
    if length(hist) == 1
        this_speak = 0
    else
        this_speak = hist[end] - hist[end-1]
    end

    try
        push!(spoken[this_speak], this_turn)
    catch
        push!(spoken, this_speak => [this_turn])
    end

    previous = (this_turn, this_speak)
    return previous
end

# previous = taketurn(previous)

function playgame(numbers, max_turn)
    previous, spoken = startgame(numbers)

    println(previous)

    for i in length(numbers):max_turn-1
        previous = taketurn(previous, spoken)
    end

    println("The $(previous[1]) number spoken is $(previous[2])")
end

playgame([1,20,11,6,12,0], 30000000)


# [i for i in length(numbers):3-1]
