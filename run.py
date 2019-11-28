import os
import platform
import time

L=32
dJ_set=['-0.08','-0.04','-0.02','-0.01','0.0','0.01','0.02','0.04','0.08']
steps=1600

for dJ in dJ_set:
    os.system("nohup julia ./main.jl {} {} {}& \n".format(L,dJ,steps))
    print("Running: julia ./main.jl {} {} {}".format(L,dJ,steps))
    time.sleep(1)