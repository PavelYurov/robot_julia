using (HorizonSideRobots)
abstract type Abstract_Robot end

const data_array_size = 100

HSR = HorizonSideRobots
HSR.move!(ptr_robot::Abstract_Robot,side, stop_condition::Function = none_stop) = !stop_condition && move!(get_robot(ptr_robot),side);
HSR.isborder(ptr_robot::Abstract_Robot,side) = isborder(get_robot(ptr_robot),side);
HSR.ismarker(ptr_robot::Abstract_Robot) = ismarked(get_obot(ptr_robot));
HSR.putmarker!(ptr_robot::Abstract_Robot) = putmarker!(get_robot(ptr_robot));

mutable struct Coord
    x::Int64
    y::Int64
end

function move(coord::Coord, side::HorizonSide)
    (Int(side)%2 == 1) && (coord.x += 1*(2 - Int(side))); (Int(side)%2 == 0) && (coord.y += (1 - Int(side))) ;
    return coord
end

struct coordrobot <: Abstract_Robot
    robot::Robot
    cordinates::Coord
end

function get_robot(ptr_robot::coordrobot)
    return ptr_robot.robot
end;

function none_stop()
    return false
end

function none_function(arg_1, arg_2)
end

function HSR.move!(ptr_robot::coordrobot, side::HorizonSide)
        move!(get_robot(ptr_robot),side)
        move(ptr_robot.cordinates,side)
end

function get_cord(robot::coordrobot)
    return robot.cordinates
end

function change_rotation(direction::HorizonSide, value)
    new_direction = HorizonSide((4 + Int(direction) + value) % 4)
    return new_direction
end

#function move_in_cord(direction::HorizonSide,coord::Coord)
#    if direction == Nord 
#        coord.y += 1
#    end
#    if direction == Sud
#     coord.y -= 1
#    end
#    if direction == West 
#    coord.x -= 1
#    end
#    if direction == Ost
#    coord.x += 1
#    end
#    return coord
#end

function save_data(ptr_robot::coordrobot, arr_data::Array)
    for i in 0:3
        arr_data[ptr_robot.cordinates.x , ptr_robot.cordinates.y, i+1] = isborder(ptr_robot,HorizonSide(i))
    end
    arr_data[ptr_robot.cordinates.x , ptr_robot.cordinates.y, 5] = true
end

function put_all_markers(ptr_robot, arr_data::Array)
    if (arr_data[ptr_robot.cordinates.x , ptr_robot.cordinates.y, 6] == true)
        putmarker!(ptr_robot)
    end
end

function putmarkers_for_recurce(ptr_robot, arg_1)
    putmarker!(ptr_robot)
end

function try_to_move_in_cord(robot::coordrobot,direction::HorizonSide)
   if !isborder(robot,direction)
        move!(robot,direction)
        #new_r = move_in_cord(direction,robot.cordinates)
   end
end
function recurse(was_array::Array,robot::coordrobot, border_x::Int, border_y::Int,  func::Function, arg_1 = 0)
    was_array[robot.cordinates.x , robot.cordinates.y] = true
    func(robot, arg_1)
    for i in 0:3
        direction = HorizonSide(i)
        if isborder(robot, direction)

        elseif is_in_border(move(Coord(0,0),direction).x + robot.cordinates.x,move(Coord(0,0),direction).y +  robot.cordinates.y, border_x,border_y) && !was_array[move(Coord(0,0),direction).x + robot.cordinates.x, move(Coord(0,0),direction).y +  robot.cordinates.y]
            try_to_move_in_cord(robot,direction)
            recurse(was_array,robot, border_x, border_y, func, arg_1)
            try_to_move_in_cord(robot,change_rotation(direction,2))
        end
    end
end
function is_in_border(x,y,bx,by)
    return Bool(x in 1:bx && y in 1:by)
end

function snake(robot)
    razmer_x = 30
    razmer_y = 30
    was_array = zeros(Bool,razmer_x,razmer_y)
    temp_r = coordrobot(get_robot(robot),Coord(razmer_x ÷ 2 ,razmer_y ÷2))
    snake_recurse(was_array, temp_r)
end

function snake_recurse(was_array::Array,robot::coordrobot)
    was_array[robot.cordinates.x , robot.cordinates.y] = true
    for i in [1,3,0]
        direction = HorizonSide(i)
        if !isborder(robot, direction)
        if !was_array[move(Coord(0,0),direction).x + robot.cordinates.x, move(Coord(0,0),direction).y +  robot.cordinates.y]
            try_to_move_in_cord(robot,direction)
            snake_recurse(was_array,robot)
            try_to_move_in_cord(robot,change_rotation(direction,2))
        end
        end
    end
end
function move_for(ptr_robot, side::HorizonSide, value::Int, stop_cond::Function)
    for i in 1:value
        if !stop_cond(ptr_robot)
            move!(ptr_robot,side)
        else 
            break
        end
    end
end

function found_gap(robot)
    return !isborder(robot, Nord)
end

function right_left(robot, func::Function, side::HorizonSide = West)
    value = 1
    while(!func(robot))
        value *= 2
        move_for(robot,side,value,func)
        side = change_rotation(side,2)
    end
end

function find_border_cord(data_array::Array, border_data::Array)

    for y in 1:razmer_y
		found = false
		for x in 1:razmer_x
			if data_array[x,y,5] != false 
				border_data[1] = y;
				found = true;
            end
		end
		if found
			break;
        end
	end
    for x in 1:razmer_x
		found = false
		for y in 1:razmer_y
			if data_array[x,y,5] != false 
				border_data[2] = x;
				found = true;
            end
		end
		if found
			break;
        end
	end
    for y in razmer_y:1
		found = false
		for x in razmer_x:1
			if data_array[x,y,5] != false 
				border_data[3] = y;
				found = true;
            end
		end
		if found
			break;
        end
	end
    for x in razmer_x:1
		found = false
		for y in razmer_y:1
			if data_array[x,y,5] != false 
				border_data[4] = x;
				found = true;
            end
		end
		if found
			break;
        end
	end
    print(border_data)
    return border_data
end

function recurse_prepare_2(cr::coordrobot, func::Function, arg_1 = 0)#не работает!
    was_mn = Set{Coord}()
function recurse_with_mn()
    if (get_cord(cr) ∉ was_mn)
        push!(was_mn,get_cord(cr))
        func(cr, arg_1)
        for i in 0:3
            direction = HorizonSide(i)
            if !isborder(cr, direction)
                try_to_move_in_cord(cr,direction)
                print(was_mn, cr.cordinates)
                recurse_with_mn()
                try_to_move_in_cord(cr,change_rotation(direction,2))
            end
         end
    end
end
recurse_with_mn()
end

function get_border_side(r)
    for i in 0:3
        if(isborder(get_robot(r),HorizonSide(i)))
            return HorizonSide(i)
        end
    end
    throw("ERR: no border nearby")
    return Nord
end

function move_border(cr,direction)
    if !isborder(cr, change_rotation(direction, -1))
        direction = change_rotation(direction,-1)
    else
        if isborder(cr,direction)
            direction = change_rotation(direction,1)
            if isborder(cr,direction)
                direction = change_rotation(direction,1)
            end
        end
    end
    if !isborder(cr,direction)
        move!(cr,direction)
    end
    return direction

end

function get_conture_border_cord(arr,cr::coordrobot)
    if cr.cordinates.x > arr[2]
        arr[2] = cr.cordinates.x
    elseif cr.cordinates.x < arr[1]
        arr[1] = cr.cordinates.x
    end
    if cr.cordinates.y > arr[4]
        arr[4] = cr.cordinates.y
    elseif cr.cordinates.y < arr[3]
        arr[3] = cr.cordinates.y
    end
    return arr
end

function get_conture_coord(border_arr, cr::coordrobot)
    direction = change_rotation(get_border_side(cr),1)
    #min_x = 0; min_y = 0; max_x = 0; max_y = 0
    direction = move_border(cr, direction)
    while !(cr.cordinates.x == 0 && cr.cordinates.y == 0)
        direction = move_border(cr, direction)
        border_arr = get_conture_border_cord(border_arr, cr)
    end
    return border_arr
end

function border_is_free(arr)
    for i in arr[1:end,1,5]
        
        if i
            return true
        end
    end
    for i in arr[1:end,end,5]
        
        if i
            return true
        end
    end
    for i in arr[1,1:end,5]
        
        if i
            return true
        end
    end
    for i in arr[end,1:end,5]
        
        if i
            return true
        end
    end
    return false
end

function check_for_free_area(arr,x,y,bord_x,bord_y)
    for i in 0:3
        c = move(Coord(x,y),HorizonSide(i))
        if is_in_border(c.x,c.y,bord_x,bord_y)
            if arr[c.x,c.y,5]
                return true
            end
        end
        c1 = move(c,change_rotation(HorizonSide(i),1))
        if is_in_border(c.x,c.y,bord_x,bord_y)
            if arr[c.x,c.y,5]
                return true
            end
        end
    end
    return false
end

function get_walls(wall_arr,data_arr,raz_x,raz_y)
    for x in 1:raz_x
        for y in 1:raz_y
            if !data_arr[x,y,5]
                wall_arr[x,y] = check_for_free_area(data_arr,x,y,raz_x,raz_y)
            end
        end
    end
    return wall_arr
end

function recurse_bomb_v2(was_arr, wall_arr, raz_x, raz_y)
    amount = 0
    for x in 1:raz_x
        for y in 1:raz_y
            if !was_arr[x,y] && wall_arr[x,y]
                amount+=1
                recurse_bomb_wall_counter(was_arr,wall_arr,x,y,raz_x,raz_y)
            end
        end
    end
    return amount
end

function recurse_bomb_wall_counter(was_arr, wall_arr,x,y,raz_x,raz_y)
    was_arr[x,y] = true
    for i in 0:3
        side = HorizonSide(i)
        c = move(Coord(x,y),side)
        if is_in_border(c.x,c.y,raz_x,raz_y) && !was_arr[c.x,c.y] && wall_arr[c.x,c.y]
            recurse_bomb_wall_counter(was_arr,wall_arr,c.x,c.y,raz_x,raz_y)
        end
    end
end