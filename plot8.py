# Only for degeneracies:
import matplotlib.pyplot as plt
import numpy as np
import os
import platform
import math

L=8
dJ_set=['-0.1','-0.01','-0.001','-0.0005','-0.0002','-0.0001','0.0','0.0001','0.0002','0.0005','0.001','0.01','0.1']

color_map_name =  'plasma'
color_interval = 10
color_map = plt.get_cmap(color_map_name)
color_set= [color_map.colors[i*color_interval] for i in range(256//color_interval)]
fig,(ax1,ax2,ax3)= plt.subplots(nrows=1,ncols=3,figsize=(30,8))

for i in range(len(dJ_set)):
    dJ = dJ_set[i]
    color = [color_set[i]]
    data = np.loadtxt('./Data/{},{}.dat'.format(L,dJ))

    ave = np.log(np.abs(data[0,:])+0.00001)
    # std = np.log(data[:,1])
    tim = [np.log(i+1) for i in range(ave.size)]
    ax1.scatter(tim,ave,s=1,c=color,marker='o',label="L={},dJ={}".format(L,dJ))

    ax1.legend(loc='lower left')
    ax1.set_title("M(t,L,J)")
    ax1.set_xlabel("log(t)")
    ax1.set_ylabel("log(M)")
    ax1.set_ylim(-4.0,0)
    ax1.set_xlim(0,7.5)

    # std = np.log(data[:,1])
    ave = data[0,:]
    tim = np.array([i+1 for i in range(ave.size)])
    ax2.scatter(tim,ave,s=1,c=color,marker='o',label="L={},dJ={}".format(L,dJ))

    ax2.legend(loc='best')
    ax2.set_title("M(t,L,J)")
    ax2.set_xlabel("t")
    ax2.set_ylabel("M")
    ax2.set_ylim(0.0,1.0)
    ax2.set_xlim(0,1600)

    ave = np.log(np.abs(data[0,:])+0.00001)
    tim = np.array([i+1 for i in range(ave.size)])
    # ax3.errorbar(tim,ave,err,marker='o',label="L={},dJ={}".format(L,dJ))
    ax3.scatter(tim,ave,s=1,c=color,marker='o',label="L={},dJ={}".format(L,dJ))

    ax3.legend(loc='best')
    ax3.set_title("M(t,L,J)")
    ax3.set_xlabel("t")
    ax3.set_ylabel("log(M)")
    ax3.set_ylim(-4.0,0)
    ax3.set_xlim(0,1600)


plt.savefig('./figure/fig{}.png'.format(L))