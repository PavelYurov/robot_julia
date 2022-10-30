using HorizonSideRobots
#include()
function cross!(robot)
    for side in (Nord, West, Ost, Sud)
        n= numsteps_putmarker!(robot, side)
        along!(robot, inverse(side), n)
    end
putmarker!(robot)
end
function along!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end 
end
function numsteps_putmarkers!(robot,side)
    num_steps=0
    while !isborder(robot, side)
        move!(robor, side)
        putmarker!(robot)
        num_steps+=1
    end
    return num_steps
end
inverse(side::HorizonSide)= HorizonSide((int(side)+2)%4)