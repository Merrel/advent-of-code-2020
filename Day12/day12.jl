
using DataFrames
using VegaLite

struct Command
    str::AbstractString
    dir::Char
    val::Int
    function Command(str::AbstractString)
        # split up the string
        dir = str[1]
        val = parse(Int, str[2:end])
        new(str, dir, val)
    end
end

function parseCommands(commands_txt::String)
    # Several methods to read to string
    # #
    # s = open(commands_txt) do file
    #     str_com = read(file, String)
    # end
    # #
    s = open(f->read(f, String), commands_txt)
    #
    # s = open(commands_txt) |> read |> string

    commands = Command.(split(s))
end

mutable struct Position
    x::Number
    y::Number
    az::Number
end

function move!(boat::Position, com::Command)
    # ------------------ Cardinal Directions
    if com.dir == 'N'
        boat.y += com.val
    elseif com.dir == 'S'
        boat.y -= com.val
    elseif com.dir == 'E'
        boat.x += com.val
    elseif com.dir == 'W'
        boat.x -= com.val
    # ------------------------------ Turning
    elseif com.dir == 'L'
        boat.az -= com.val
    elseif com.dir == 'R'
        boat.az += com.val
    # ----------------- Forward and Backward
    elseif com.dir == 'F'
        boat.x += (sind(boat.az) * com.val)
        boat.y += (cosd(boat.az) * com.val)
    # elseif com.dir == "B"
    #     boat.x -= (sind(boat.az) * com.val)
    #     boat.y -= (cosd(boat.az) * com.val)
    else
        println("Unable to process command: $com")
    end

    # Correct azimuth
    boat.az = boat.az % 360
end


function main()
    # Read the commands
    inp = joinpath(@__DIR__, "commands.txt")
    commands = parseCommands(inp)

    # Initialize the boat and position tracker
    boat = Position(0, 0, 90)
    df = DataFrame(x=boat.x, y=boat.y, az=boat.az)

    for c in commands
        move!(boat, c)
        push!(df, [boat.x boat.y boat.az])
    end

    return df
end

path = main()

path |> @vlplot(
    # mark={
    #     :line,
    #     point=true,
    # },
    :point,
    x=:x,
    y=:y,
    height=400, 
    width=400,
)
