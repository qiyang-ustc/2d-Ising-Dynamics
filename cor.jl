using Random
using Statistics
using DelimitedFiles
const L = parse(Int,ARGS[1])
const dJ = parse(Float64,ARGS[2])

const RANDOM_SEED = 321
const D = 2
const NSAMP = parse(Int,ARGS[3])  #simulated system
const NBLCK = 20480  #simulation time
const NTOSS = 4000
const EPSILON = 1E-14
const J0 = 0.4406867935
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
m2 = zeros(Float64,NBLCK,NSAMP)
m4 = zeros(Float64,NBLCK,NSAMP)
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
    for i=1:1:Vol
        spin[i] = rand([-1,1])
    end
    for itoss=1:1:NTOSS
        for i = 1:1:Lx
            for j = 1:1:Ly
                sum_spin = 0
                # index = (i-1)*Lx + j
                index = rand(1:Lx*Ly)
                for k = 1:1:4
                    sum_spin += spin[neib[index,k]]
                end
                #if rand()<exp()  #We should not use Metropolis here
                dE = 2*spin[index]*sum_spin*Jcp
                if rand()<exp(-dE)
                    spin[index] = -spin[index]
                end
            end
        end
    end
    for isamp=1:1:NSAMP
        for i = 1:1:Lx
            for j = 1:1:Ly
                sum_spin = 0
                # index = (i-1)*Lx + j
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

COR_TIME = 600
COR_LENGTH = 1200
cor_m = zeros(Float64,NBLCK,COR_TIME)
for i=1:1:NBLCK
    for t=1:1:COR_TIME
        t1 = m[i,1:COR_LENGTH-COR_TIME]
        t2 = m[i,1+t:COR_LENGTH-COR_TIME+t]
        cor_m[i,t] = cor(t1,t2)
    end
end
# ave_m = mean(cor_m,dims=1)
ave_m = zeros(Float64,COR_TIME)
for j=1:1:COR_TIME
    for i=1:1:NBLCK
        ave_m[j] += cor_m[i,j]/NBLCK
        if isnan(ave_m[j])
            error(i,"  ",j," ",cor_m[i,j])
        end
    end
end 

# err = std(m,dims=1)/sqrt(NBLCK)  #std is occupied
f = open("./Data/cor_$L,$dJ.dat","w")
writedlm(f,transpose(ave_m))
# writedlm(f,err)
close(f)

