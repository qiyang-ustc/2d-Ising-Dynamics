using Random
using Statistics
using DelimitedFiles
const L = parse(Int,ARGS[1])
const dJ = parse(Float64,ARGS[2])

const RANDOM_SEED = 123
const D = 3
const NSAMP = parse(Int,ARGS[3])  #simulated system
const NBLCK = 8192  #simulation time
const EPSILON = 1E-14
const J0 = 0.22165455
# const DJ = J0 .+ collect(Float64,-1:0.5:1)
const Jcp = J0 + dJ

Random.seed!(RANDOM_SEED)
const Lx = L
const Ly = L
const Lz = L
const Vol = Lx*Ly*Lz

spin = ones(Int,Vol)
neib = zeros(Int,Vol,4)

# We only sample order-parameter in this program.
m = zeros(Float64,NBLCK,NSAMP)
m2 = zeros(Float64,NBLCK,NSAMP)
m4 = zeros(Float64,NBLCK,NSAMP)
# 1up 2down 3left 4right
# set neighbourhood matrix
for i=1:1:Lx
    for j=1:1:Ly
        for k=1:1:Lz
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
end
for iblck=1:1:NBLCK
    spin .= 1
    for isamp=1:1:NSAMP
        for i = 1:1:Lx
            for j = 1:1:Ly
                sum_spin = 0
                #index = (i-1)*Lx + j
                index = rand(1:Lx*Ly)
                for k = 1:1:4
                    sum_spin += spin[neib[index,k]]
                end
                #if rand()<exp()  #We should not use Metropolis here
                dE = exp(-2*spin[index]*sum_spin*Jcp)
                if rand()<dE/(1+dE)
                    spin[index] = -spin[index]
                end
            end
        end
        m[iblck,isamp] = mean(spin)
        m2[iblck,isamp] = m[iblck,isamp]^2
        m4[iblck,isamp] = m[iblck,isamp]^4
    end
end

ave_m = mean(m,dims=1)
ave_m2 =mean(m2,dims=1)
ave_m4 =mean(m4,dims=1)
ave_binder = ave_m4./(ave_m2).^2
# err = std(m,dims=1)/sqrt(NBLCK)  #std is occupied
f = open("./Data/$L,$dJ.dat","w")
writedlm(f,ave_m)
writedlm(f,ave_m2)
writedlm(f,ave_m4)
writedlm(f,ave_binder)
# writedlm(f,err)
close(f)

