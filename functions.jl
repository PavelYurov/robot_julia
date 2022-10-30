using (HorizonSideRobots)
HSR = HorizonSideRobots

mutable struct cord
    x::Int
    y::Int
end


abstract type SimpleRobot end
HSR.move!(robot::SimpleRobot,side) = move!(get_robot(robot),side)
HSR.isborder(robot::SimpleRobot,side) = isborder(get_robot(robot),side)
HSR.ismarker(robot::SimpleRobot) = ismarker(get_robot(robot))
HSR.putmarker!(robot::SimpleRobot) = putmarker(get_robot(robot))

struct Coord_Robot <: SimpleRobot
    robot::Robot
    coordinates::cord
end

function get_robot(robot::SimpleRobot)
   return robot.robot
end

function get_cord(robot::Coord_Robot)
    return robot.coordinates
end

function change_rotation(direction::HorizonSide, value)
    new_direction = HorizonSide((4 + Int(direction) + value) % 4)
    return new_direction
end
function move_in_cord(direction::HorizonSide,coord::cord)
    if direction == Nord 
        coord.y += 1
    end
    if direction == Sud
     coord.y -= 1
    end
    if direction == West 
    coord.x -= 1
    end
    if direction == Ost
    coord.x += 1
    end
    return coord
end

function try_to_move_in_cord(robot::Coord_Robot,direction)
   if !isborder(robot,direction)
        move!(robot,direction)
        new_coord = move_in_cord(direction,robot.coordinates)
   end
end
function recurse_get_data(data_array::Array,was_array::Array,robot::Coord_Robot)
    was_array[robot.coordinates.x , robot.coordinates.y] = true
    for i in 0:3
        direction = HorizonSide(i)
        if isborder(robot, direction)
            data_array[robot.coordinates.x , robot.coordinates.y, i+1] = true
        elseif !was_array[robot.coordinates.x + move_in_cord(direction,cord(0,0)).x , robot.coordinates.y + move_in_cord(direction,cord(0,0)).y]
            try_to_move_in_cord(robot,direction)
            recurse_get_data(data_array,was_array,robot)
            try_to_move_in_cord(robot,change_rotation(direction,2))
        end
    end
end


