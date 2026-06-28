import numpy as np
import matplotlib.pyplot as plt


array1 = np.array((5,15,25,35))
array2 = np.array((10,20,30,40))

fig, axs = plt.subplots(4,2, figsize=(6.5, 5), sharex=True)#, sharey=True)
plt.rcParams['svg.fonttype'] = 'none'

for i in range(len(array1)):
	data = np.loadtxt('combined_pullX_mt_fk{}_rep1.dat'.format(array1[i]), skiprows=1)
	axs[i,0].plot(data[:500000,0], data[:500000,1]/data[0,1], label='Rep1', color='#007171')
	data = np.loadtxt('combined_pullX_mt_fk{}_rep2.dat'.format(array1[i]), skiprows=1)
	axs[i,0].plot(data[:500000,0], data[:500000,1]/data[0,1], label='Rep2', color='#00C6C6')
	data = np.loadtxt('combined_pullX_mt_fk{}_rep3.dat'.format(array1[i]), skiprows=1)
	axs[i,0].plot(data[:500000,0], data[:500000,1]/data[0,1], label='Rep3', color='#00FFFF')
	axs[i,0].set_ylim(0.75,1.5)
	axs[i,0].set_xlim(0,50)
	axs[i,0].set_title(f"Force = {array1[i]*1.66:.1f} pN")
#	axs[i,0].set_yticks([0, 50, 100])


for i in range(len(array2)):
	data = np.loadtxt('combined_pullX_mt_fk{}_rep1.dat'.format(array2[i]), skiprows=1)
	axs[i,1].plot(data[:500000,0], data[:500000,1]/data[0,1], color='#007171')
	data = np.loadtxt('combined_pullX_mt_fk{}_rep2.dat'.format(array2[i]), skiprows=1)
	axs[i,1].plot(data[:500000,0], data[:500000,1]/data[0,1], color='#00C6C6')
	data = np.loadtxt('combined_pullX_mt_fk{}_rep3.dat'.format(array2[i]), skiprows=1)
	axs[i,1].plot(data[:500000,0], data[:500000,1]/data[0,1], color='#00FFFF')
	axs[i,1].set_ylim(0.75,1.5)
	axs[i,1].set_xlim(0,50)
	axs[i,1].set_title(f"Force = {array2[i]*1.66:.1f} pN")
#	axs[i,1].set_yticks([0, 50, 100])

axs[3,0].set_xlabel('Time(ns)', fontsize=16)
axs[3,1].set_xlabel('Time(ns)', fontsize=16)
fig.supylabel('Extension (<x$_t$/x$_0$>)', fontsize=16)
fig.suptitle("S243E", fontsize=14)#, fontweight='bold')
plt.tight_layout()
#plt.savefig('extension_vs_time_MT.png', dpi=150)
plt.savefig('extension_vs_time_MT.svg')
plt.show()

