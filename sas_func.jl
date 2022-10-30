using HorizonSideRobots

arr = [0,0,0,0]

function _move_up_1(ptr_robot)
    i = 0
    while i < 4
        ord = HorizonSide(i)
        i+= 1
        a = 0
        while ! isborder(ptr_robot, ord)
            move!(ptr_robot,ord)
            putmarker!(ptr_robot)
            a+= 1
        end
        save_coords(i,a)
        ord = rotate(ord,2)
        while ismarker(ptr_robot)
            move!(ptr_robot,ord)
        end
    end
end

function _move_up_4(ptr_robot)
    i = 0
    while i < 4
        ord = HorizonSide(i)
        i+= 1
        while (! isborder(ptr_robot, ord) && ! isborder(ptr_robot, rotate(ord,1)))
            if ! isborder(ptr_robot, ord)
                move!(ptr_robot,ord)
            end
            if ! isborder(ptr_robot, rotate(ord,1))
                move!(ptr_robot, rotate(ord,1))
            end
            putmarker!(ptr_robot)
        end
        ord = rotate(ord,2)
        while ismarker(ptr_robot)
            move!(ptr_robot, rotate(ord,1))
            move!(ptr_robot,ord)
        end
    end
end

function rotate(prev_ord, ord)::HorizonSide
   return HorizonSide((Int(prev_ord)+ord + 4)%4)
end

function move(ptr_robot, direction)
    if !isborder(ptr_robot,direction)
        move!(ptr_robot,direction)
        return 1
    end
    return 0
end

function check(ptr_robot):: Int
    a = 0
    for i in 0:3
            if isborder(ptr_robot, HorizonSide(i))
                a += 1
            end
    end
    return a
end
function get_border(ptr_robot) #unused
    putmarker!(ptr_robot)
    direction = Nord
    a = 0
    while true
        x = 0
        y = 0
        y+= move(ptr_robot,direction);
        x+= move(ptr_robot,rotate(direction,1))
        while(!(check(ptr_robot) > 1))
            y+= move(ptr_robot,direction);
            x+= move(ptr_robot,rotate(direction,1))
        end
        direction = rotate(direction, 1)
        putmarker!(ptr_robot)
        a+= 1
        if (ismarker(ptr_robot) && (check(ptr_robot) >= 2) && a >=5)
            break
        end
    end
end

function check_final_border(ptr_robot,direction, b)
    res = true
    a = rotate(direction,-1)
    #b = rotate(diraction,-1)
    while(!isborder(ptr_robot,a))
        move!(ptr_robot,a)
        if !isborder(ptr_robot,direction)
            res = false
        end
    end
    return res
end

function _move_up_3(ptr_robot, direction)
    a = rotate(direction,1)
    x = 0
    y = 0
    final_border = false
    while !final_border
        while !isborder(ptr_robot,a)
            if (check(ptr_robot)> 0)
                putmarker!(ptr_robot)
            end
        end
        final_border = check_final_border(ptr_robot,direction,a)
    end
end

abstract type Abstract_Robot end

HSR = HorizonSideRobots
HSR.move!(ptr_robot::Abstract_Robot,side) = move!(get_robot(ptr_robot),side);
HSR.isborder(ptr_robot::Abstract_Robot,side) = isborder(get_robot(ptr_robot),side);
HSR.ismarker(ptr_robot::Abstract_Robot) = ismarked(get_obot(ptr_robot));
HSR.putmarker!(ptr_robot::Abstract_Robot) = putmarker!(get_robot(ptr_robot));

struct cord
    x::Int64
    y::Int64
end

function move!(coord::cord, side)
    coord.x += (2 - Int(side)) * Int(Int(side)%2 == 1);  coord.y += (1 - Int(side)) * Int(Int(side)%2 == 0);
end
struct cordrobot <: Abstract_Robot
    robot::Robot;
    cord::cord;
end

function get_robot(ptr_robot::cordrobot)
    return ptr_robot.robot
end;

function HSR.move!(ptr_robot::cordrobot, side)
    move!(get_robot(ptr_robot),side)
    move!(ptr_robot.cord,side)
end

struct data
    marker::Bool
    #border[4]::Bool

end

#array_data[100][100];


