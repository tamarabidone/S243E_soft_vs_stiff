import numpy as np
import matplotlib.pyplot as plt


array = np.array((5,10,15,20,25,30,35,40))
avg_extension = np.zeros((len(array), 30000))
for i in range(len(array)):
	k_ = 0
	for j in range(1,4):
		prev_ = k_
		data = np.loadtxt('combined_pullX_mt_fk{}_rep{}.dat'.format(array[i], j), skiprows=1)
		exten = data[:,1]/data[0,1]
		#avg_extension[i,j-1] = np.mean(exten[40000:45000])
		strip_data = exten[40000:50000]
		k_ += len(strip_data)
		avg_extension[i,prev_:k_] = strip_data
	
np.savetxt('average_extension_ratio_each_replica_mt_smd.dat', np.column_stack((array, avg_extension)))
