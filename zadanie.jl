using HorizonSideRobots
include("sus_func_2.jl")

const razmer_x = 100
const razmer_y = 100

#snake(cr)
#recurse(was_array,cr,none_function)
#recurse(was_array,cr,save_data,data_array)

function recurse_prepared(r, func::Function, arg_1 = 0, _razmer_x = razmer_x,_razmer_y = razmer_y)
    was_array = zeros(Bool,_razmer_x,_razmer_y)
    cr = coordrobot(get_robot(r),Coord(_razmer_x ÷ 2,_razmer_y ÷ 2))
    recurse(was_array,cr,_razmer_x, _razmer_y,func,arg_1)
end

function recurse_prepared_for_38_39(r,bord_data, func::Function, arg_1 = 0, add_value = 1)
    raz_x = bord_data[2] - bord_data[1] + add_value
    raz_y = bord_data[4] - bord_data[3] + add_value
    was_array = zeros(Bool,raz_x,raz_y)
    cr = coordrobot(get_robot(r),Coord(1-bord_data[1],1-bord_data[3]))
    recurse(was_array,cr,raz_x, raz_y,func,arg_1)
end


function zadanie_1(r)
    data_array = zeros(Bool,razmer_x,razmer_y,6)
    was_array = zeros(Bool,razmer_x,razmer_y)
    cr = coordrobot(get_robot(r),Coord(razmer_x ÷ 2,razmer_y ÷ 2))

    recurse(was_array,cr, razmer_x, razmer_y, save_data,data_array)

    for x in 1:razmer_x
       for y in 1:razmer_y
          if x == razmer_x ÷ 2 || y == razmer_y ÷ 2 
               data_array[x,y,6] = true
           end
        end
    end
    was_array = zeros(Bool,razmer_x,razmer_y)
    recurse(was_array,cr, razmer_x, razmer_y, put_all_markers,data_array)

end

function recurse_bomb(was_array::Array, arr_data::Array, x::Int, y::Int, border_x_1::Int, border_x_2::Int, border_y_1::Int, border_y_2::Int, func::Function)
    if (x > border_x_1 && x < border_x_2) && (y > border_y_1 && y < border_y_2) && !was_array[x,y]
        was_array[x,y] = true
        if func(arr_data, x, y) 
            recurse_bomb(was_array,arr_data, x+1, y, border_x_1, border_x_2, border_y_1, border_y_2, func)
            recurse_bomb(was_array,arr_data, x-1, y, border_x_1, border_x_2, border_y_1, border_y_2, func)
            recurse_bomb(was_array,arr_data, x, y-1, border_x_1, border_x_2, border_y_1, border_y_2, func)
            recurse_bomb(was_array,arr_data, x, y+1, border_x_1, border_x_2, border_y_1, border_y_2, func)
        end
    end
end

function zad_6a(data_array::Array, x::Int, y::Int)
    if data_array[x,y,5] == true
        return false
    else
        for i in -1:1
            for ii in -1:1
                data_array[x+i,y+ii,6] = true
            end
        end
        return true
    end
end

function zad_6b(data_array::Array, x::Int, y::Int)
    if data_array[x,y,5] == true 
        return false
    else
        if x == razmer_x ÷ 2 || y == razmer_y ÷ 2
            data_array[x+1,y,6] = true
            data_array[x-1,y,6] = true
            data_array[x,y+1,6] = true
            data_array[x,y-1,6] = true
        end
        return true
    end
end

function border_check(data_array::Array, x::Int, y::Int)
    for i in 0:3
        if data_array[x,y,i+1] == true
            c_1 = Coord(x,y)
            c_2 = move(Coord(x,y),change_rotation(HorizonSide(i),1))
            c_3 = move(Coord(x,y),change_rotation(HorizonSide(i),-1))
            data_array[c_1.x,c_1.y,6] = true
            data_array[c_2.x,c_2.y,6] = true
            data_array[c_3.x,c_3.y,6] = true
        end
    end
end
function zad_2(arr_data::Array)
    for x in 2:(razmer_x-1)
        for y in 2:(razmer_y-1)
            border_check(arr_data,x,y)
        end
    end
end

function zadanie_2(r)
    data_array = zeros(Bool,razmer_x,razmer_y,6)
    recurse_prepared(get_robot(r),save_data,data_array)
    zad_2(data_array)
    recurse_prepared(get_robot(r),put_all_markers,data_array)
end

function zadanie_3(r)
    recurse_prepared(get_robot(r),putmarkers_for_recurce)
end

function zadanie_4(r)

    data_array = zeros(Bool,razmer_x,razmer_y,6)
    recurse_prepared(get_robot(r),save_data,data_array)
    for x in 1:razmer_x
        for y in 1:razmer_y
           if abs(x - (razmer_x / 2)) == abs(y - (razmer_y / 2))
                data_array[x,y,6] = true
            end
         end
     end
    recurse_prepared(get_robot(r),put_all_markers,data_array)
end

function zadanie_5(r)
    zadanie_2(r)
end


function recurse_bomb_prepared(data_array::Array, func::Function)
    was_array = zeros(Bool,razmer_x,razmer_y)
    recurse_bomb(was_array,data_array, 2, 2, 1, razmer_x ÷ 2, 1,razmer_y ÷ 2, func)
    recurse_bomb(was_array,data_array, razmer_x - 1, 2, razmer_x ÷ 2 - 1, razmer_x, 1,razmer_y ÷ 2, func)
    recurse_bomb(was_array,data_array, 2, razmer_y - 1, 1, razmer_x ÷ 2, razmer_y ÷ 2 - 1, razmer_y, func)
    recurse_bomb(was_array,data_array, razmer_x - 1, razmer_y - 1, razmer_x ÷ 2 - 1, razmer_x,razmer_y ÷ 2 - 1, razmer_y, func)
end
function zadanie_6a(r)
    data_array = zeros(Bool,razmer_x,razmer_y,6)
    recurse_prepared(get_robot(r),save_data,data_array)
    recurse_bomb_prepared(data_array,zad_6a)
    recurse_prepared(get_robot(r),put_all_markers,data_array)
end 
function zadanie_6b(r)
    data_array = zeros(Bool,razmer_x,razmer_y,6)
    recurse_prepared(get_robot(r),save_data,data_array)
    recurse_bomb_prepared(data_array,zad_6b)
    recurse_prepared(get_robot(r),put_all_markers,data_array)
end 

function zadanie_7(r)
    right_left(get_robot(r),found_gap)
    move!(get_robot(r),Nord)
end

function zadanie_8(r::Robot)
#?
end

function zadanie_9(r)
    data_array = zeros(Bool,razmer_x,razmer_y,6)
    recurse_prepared(get_robot(r),save_data,data_array)
    for x in 1:razmer_x
        for y in 1:razmer_y
            if mod(x,2) == mod(y,2)
                data_array[x,y,6] = true
            end
        end
    end
    recurse_prepared(get_robot(r),put_all_markers,data_array)
end

function zadanie_10(r, n::Int)

    data_array = zeros(Bool,razmer_x,razmer_y,6)
    recurse_prepared(get_robot(r),save_data,data_array)
    border_data = zeros(Int,4)

    border_data = find_border_cord(data_array,border_data);
    print(border_data)
	for i in border_data[2]-1:razmer_x
		for ii in border_data[1]-1:razmer_y
			if ((mod(div(i - border_data[2], n), 2)) == mod((div((ii - border_data[1]), n)) , 2))
				data_array[i,ii,6] = true
            else
                data_array[i,ii,6] = false
            end
        end
    end
    recurse_prepared(get_robot(r),put_all_markers,data_array)
end

function zadanie_39(r)
    s = 0
    cr = coordrobot(get_robot(r),Coord(0,0))
    border_arr = zeros(Int,4)#x_min, x_max, y_min, y_max
    #recurse_prepare_2(cr,none_function)
    border_arr = get_conture_coord(border_arr,cr)
    raz_x = border_arr[2] - border_arr[1]+1
    raz_y = border_arr[4] - border_arr[3] + 1
    data_array = zeros(Bool,(border_arr[2] - border_arr[1]+1), (border_arr[4] - border_arr[3] + 1),6)
    recurse_prepared_for_38_39(get_robot(r),border_arr,save_data,data_array)
    for i in data_array[1:end,1:end,5]
        if !i
            s+=1
        end
    end
    print(s)
end

function zadanie_38(r)
    cr = coordrobot(get_robot(r),Coord(0,0))
    border_arr = zeros(Int,4)#x_min, x_max, y_min, y_max
    border_arr = get_conture_coord(border_arr,cr)
    raz_x = border_arr[2] - border_arr[1] + 3
    raz_y = border_arr[4] - border_arr[3] + 3
    data_array = zeros(Bool,(border_arr[2] - border_arr[1]+3), (border_arr[4] - border_arr[3] + 3),6)
    recurse_prepared_for_38_39(get_robot(r),border_arr,save_data,data_array,3)
    if data_array[end,end,5]
        print("снаружи")
    else
        print("внутри")
    end
end

function zadanie_40(r, animate::Bool = false)
    razmer = 4
    amount = 0
    data_array = zeros(Bool,razmer,razmer,5)
    recurse_prepared(get_robot(r),save_data,data_array,razmer,razmer)
    while border_is_free(data_array)
        razmer += 10
        data_array = zeros(Bool,razmer,razmer,5)
        recurse_prepared(get_robot(r),save_data,data_array,razmer,razmer)
    end
    
    wall_arr = bigs_data(data_array,razmer,animate)

    was_arr = zeros(Bool,razmer*3,razmer*3)
    #wall_arr = zeros(Bool,razmer,razmer)
    #wall_arr = get_walls(wall_arr,data_array,razmer,razmer)
    amount = recurse_bomb_v2(was_arr, wall_arr,razmer*3,razmer*3)
    print(amount-1)
end

