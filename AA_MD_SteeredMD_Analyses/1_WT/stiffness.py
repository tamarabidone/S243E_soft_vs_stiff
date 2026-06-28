import numpy as np
import matplotlib.pyplot as plt


array = np.array((5,10,15,20,25,30,35,40))
fk_ = array * 1.66 
stiffness_replica = np.zeros((len(array), 30000))
for i in range(len(array)):
	for j in range(3):
		data = np.loadtxt('combined_pullX_wt_fk{}_rep{}.dat'.format(array[i], j+1), skiprows=1)
		integer_ = 10000
		stiffness_replica[i,integer_*j:integer_*(j+1)] = np.abs(fk_[i] / (data[30000:40000,1]-data[0,1]))
		#stiffness_replica[i,j-1] = fk_[i] / np.abs(np.mean(data[40000:50000,1])-data[0,1])
		#stiffness_replica[i,j-1] = fk_[i] / np.sqrt(np.mean((data[41000:42000,1] - data[0,1])**2))
		#stiffness_replica[i,j-1] = fk_[i] / np.sqrt(np.mean((data[43000:44000,1] - data[0,1])**2))
	
np.savetxt('stiffness_each_replica_combined_wt_smd.dat', np.column_stack((array, stiffness_replica)))
