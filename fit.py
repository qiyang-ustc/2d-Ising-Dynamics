import numpy as np
L_set = [16]
J_set = [-0.0025,0.0,0.0025]
dJ_set = [J_set[i] for i in range(len(J_set))]
alpha = np.zeros(len(J_set))
T1 = 0
T2 = 20

for l in L_set:
    for ij in range(len(J_set)):
        j = J_set[ij]
        data = np.loadtxt('./Data/{},{}.dat'.format(l,j))
        logm = np.log(data[0,T1:T2])
        logt = np.log(np.array([i+1 for i in range(T2-T1)]))
        z = np.polyfit(logt,logm,1)
        # print(logm,logt)
        # print(j,np.log(-z[0]))
        print(j,z[0],z[1])
        alpha[ij]=np.log(-z[0])

result = np.polyfit(dJ_set,alpha,1)
print(result)

