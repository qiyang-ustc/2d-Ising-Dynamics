import os
import platform
import time

L=64
Jnormalization = 1
dJ_set=[-0.001,-0.0005,-0.0002,-0.0001,-0.00005,0,0.00005,0.0001,0.0002,0.0005,0.001]
for i in range(len(dJ_set)):
    dJ_set[i] = dJ_set[i]/Jnormalization
steps=1600

for dJ in dJ_set:
    os.system("nohup julia ./cor.jl {} {} {}& \n".format(L,dJ,steps))
    print("Running: julia ./cor.jl {} {} {}".format(L,dJ,steps))
    time.sleep(1)   