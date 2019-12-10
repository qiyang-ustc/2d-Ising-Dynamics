import numpy as np
import matplotlib.pyplot as plt
import os
import platform
import math

L_set = [4,8,16]
J_set = ['-0.02','-0.01','0.0','0.01','0.02']
alpha = [-20.0624,-39.17,-66.7201] #given by fitting

T = 15 
color_map_name =  'plasma'
color_interval = len(L_set)*len(J_set)
color_map = plt.get_cmap(color_map_name)
color_set= [color_map.colors[i*color_interval] for i in range(256//color_interval)]
fig,ax1= plt.subplots(nrows=1,ncols=1,figsize=(8,5))

for i in range(len(L_set)):
    for j in range(len(J_set)):
        L = L_set[i]
        dJ = J_set[j]
        color = [color_set[i*len(L_set)+j]]
        data = np.loadtxt('./Data/{},{}.dat'.format(L,dJ))
        logm = np.log(data[0,0:T])
        ave = np.log(np.abs(data[0,:])+0.0001)/(math.exp(5.62*math.exp(-11.0*eval(J_set[j]))))
        err = np.log(data[1,:])
        tim = np.array([i+1 for i in range(ave.size)])
        # ax3.errorbar(tim,ave,err,marker='o',label="L={},dJ={}".format(L,dJ))
        ax1.scatter(tim,ave,s=2,c=color,marker='o',label="L={},dJ={}".format(L,dJ))


ax1.legend(loc='best')
ax1.set_title("M(t,L,J)")
ax1.set_xlabel("t")
ax1.set_ylabel("log(M)")
ax1.set_ylim(-0.05,0)
ax1.set_xlim(0,800)

plt.savefig('./figure/collapse.png')


