using Zygote
using DelimitedFiles
input_file ="collapse.dat"
# This file should be prepared as following format
# np_1 np_2... np_{np}...  f({p},x1) f({p},x2) f({p},x3)...
data = readdlm(input_file,Float64)

np = 2  #number of parameters used for fitting 
nv = 3  #number of variables need to fit
v = [1.0 1.0 1.0]  #initialization of variables
f(v,p,x) = t-> exp(-v[1]*exp(-v[2]*p[1])*p[2]^v[3]*x) # generic function which need to be fit

(data_nrow,data_ncol)=size(data)
data_nrow -= np
p_data = data[:,1:np]
f_data = data[:,np+1:data_ncol]

#Square-least method here
loss = v-> sum(([[f(v,p_data[i],x) for x in 1:data_ncol] for i in 1:data_nrow]-f_data).^2)


learning_rate = 0.05
steps = 1000

for i in 1:steps
    v -= learning_rate*gradient(loss,v)[1]
    print(v)


