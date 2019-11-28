import numpy as np
L_set = [16]
J_set = ['-0.08','-0.04','-0.02','-0.01','0.0','0.01','0.02','0.04','0.08']
dJ_set = [eval(J_set[i]) for i in range(len(J_set))]
alpha = np.zeros(len(J_set))
T1 = 20
T2 = 150

for l in L_set:
    for ij in range(len(J_set)):
        j = J_set[ij]
        data = np.loadtxt('./Data/{},{}.dat'.format(l,j))
        logm = np.log(data[0,T1:T2])
        t = np.array([i+1 for i in range(T2-T1)])
        z = np.polyfit(t,logm,1)
        print(j,np.log(-z[0]))
        alpha[ij]=np.log(-z[0])

result = np.polyfit(dJ_set,alpha,1)
print(result)

