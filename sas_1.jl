
using HorizonSideRobots                                         #попробуй запустить (=

function move_to(ptr_robot, diraction, duration::Int = 1)
    i = 0
    while i < duration
        move!(ptr_robot,diraction);i += 1
    end
end

f = Robot(animate = true)
move!(f,Nord)
move_to(f,Nord,3)
move_to(f,Ost,3)
while true
move_to(f,Nord,5)
move_to(f,Ost,5)
move_to(f,Sud,5)
move_to(f,West,5)
end