using HorizonSideRobots
#include("sus_func_2.jl")
include("zadanie.jl")

r = Robot("untitled.sit",animate = true)
cr = coordrobot(r,Coord(0,0))
println("введите zadanie_ и номер задания в (робота и доп условия по типу N в задании 10 если нужно)")
zadanie_40(r)

