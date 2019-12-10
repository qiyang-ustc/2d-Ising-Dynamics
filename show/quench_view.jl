using Plots
using Random
shape = [300,300]
Lx = shape[1]
Ly = shape[2]
# Spin block
block = ones(Int,Lx,Ly)
# J/(kT)
Jcp = 0.4
t = 0

function metropolis(blck::Array{Int64,2},Jcp::Float64)
    for i = 1:1:Lx
        for j = 1:1:Ly
            nei= (
                blck[1+(i + Lx) % Lx,j] +
                blck[1+(i + Lx -2) % Lx,j] +
                blck[i,1+(j + Ly) % Ly] +
                blck[i,1+(j + Ly - 2) % Ly] 
                )

            if rand() < exp(-2*Jcp*nei*blck[i,j])
                blck[i,j] = - blck[i,j]
            end
        end
    end
end
function run()
    t=0
    Jcp = 0.3
    for i = 1:1:50
        metropolis(block,Jcp)
        p = heatmap(1:Lx,1:Ly,block)
        display(p)
        t = t + 1
        print(t,"\n")
    end
    Jcp = 0.5
    while true
        metropolis(block,Jcp)
        p = heatmap(1:Lx,1:Ly,block)
        display(p)
        t = t + 1
        print(t,"\n")
    end
end
run()