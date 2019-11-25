using Random
using Statistics
using DelimitedFiles

const RANDOM_SEED = 123
const D = 2
const L = 100 
const NSAMP = 2000  #simulated system
const NBLCK = 1024  #simulation time
const EPSILON = 1E-14
const J0 = 0.4406867935
const dJ = 0.0
# const DJ = J0 .+ collect(Float64,-1:0.5:1)
const Jcp = J0 + dJ

Random.seed!(RANDOM_SEED)
const Lx = L
const Ly = L
const Vol = Lx*Ly

spin = ones(Int,Vol)
neib = zeros(Int,Vol,4)

# We only sample order-parameter in this program.
m = zeros(Float64,NBLCK,NSAMP)

# 1up 2down 3left 4right
# set neighbourhood matrix
for i=1:1:Lx
    for j=1:1:Ly
        if i==1 
            neib[(i-1)*Lx+j,1] = j+(Lx-1)*Lx
            neib[(i-1)*Lx+j,2] = j+i*Lx
        elseif i==Lx
            neib[(i-1)*Lx+j,1] = j+(i-2)*Lx
            neib[(i-1)*Lx+j,2] = j
        else 
            neib[(i-1)*Lx+j,1] = j+(i-2)*Lx
            neib[(i-1)*Lx+j,2] = j+i*Lx
        end

        if j==1 
            neib[(i-1)*Lx+j,3] = Ly+(i-1)*Lx
            neib[(i-1)*Lx+j,4] = j+1+(i-1)*Lx
        elseif j==Ly
            neib[(i-1)*Lx+j,3] = j-1+(i-1)*Lx
            neib[(i-1)*Lx+j,4] = 1+(i-1)*Lx
        else 
            neib[(i-1)*Lx+j,3] = j-1+(i-1)*Lx
            neib[(i-1)*Lx+j,4] = j+1+(i-1)*Lx
        end
    end
end
for iblck=1:1:NBLCK
    spin .= 1
    for isamp=1:1:NSAMP
        for i = 1:1:Lx
            for j = 1:1:Ly
                sum_spin = 0
                index = (i-1)*Lx + j
                for k = 1:1:4
                    sum_spin += spin[neib[index,k]]
                end
                if rand()<exp(-2*spin[index]*sum_spin*Jcp)
                    spin[index] = -spin[index]
                end
            end
        end
        m[iblck,isamp] = mean(spin)
    end
end

ave = mean(m,dims=1)
sdm = std(m,dims=1)  #std is occupied
f = open("./Data/$L,$dJ.dat","w")
writedlm(f,ave)
writedlm(f,sdm)
close(f)