import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator

#Initials
fk = np.array((5,10,15,20,25,30,35,40))
#fk_ = [8.3, 16.6, 24.9, 33.2, 41.5, 49.8, 58.1, 66.4] # fk * 1.66
fk_ = [8, 17, 25, 33, 42, 50, 58, 66] # fk_ rounded to integer
x_positions = np.array((1, 4, 7, 10, 13, 16, 19, 22))

#Data
wt = np.loadtxt('1_wt/stiffness_each_replica_combined_wt_smd.dat')
mt = np.loadtxt('2_mt/stiffness_each_replica_combined_mt_smd.dat')

fig, ax = plt.subplots()
plt.rcParams['svg.fonttype'] = 'none'
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.tick_params(top=False, right=False)

ax.boxplot(wt[:,1:].T, positions=x_positions-0.3, showfliers=False, patch_artist=True,
                medianprops={'color': 'black', 'linewidth': 1},
                boxprops={'edgecolor': 'black', 'linewidth': 0.5, 'facecolor': 'gray'},
                  whiskerprops=dict(color='lightgrey', linewidth=1.0, linestyle='--'),
                  capprops = {'color': 'lightgrey', 'linewidth': 1, 'linestyle': '-'}, label='WT')#,
                   #patch_artist=True,  # fill with color
                   #tick_labels=labels)  # will be used to label x-ticks

ax.boxplot(mt[:,1:].T, positions=x_positions+0.35, showfliers=False, patch_artist=True,
                medianprops={'color': 'black', 'linewidth': 1},
                boxprops={'edgecolor': 'black', 'linewidth': 0.5, 'facecolor': '#03D5FB'},
                whiskerprops=dict(color='lightgrey', linewidth=1.0, linestyle= '--'),
                capprops = {'color': 'lightgrey', 'linewidth': 1, 'linestyle': '-'}, label='S243E')#,
                   
plt.xlabel('Force (pN)', fontsize=28)
plt.ylabel(r'Stiffness (pN$\cdot$nm$^{\mathrm{-1}}$)', fontsize=28)
#plt.ylim(0.91,1.345)
#ax.yaxis.set_major_locator(MultipleLocator(0.1))
plt.xticks(x_positions, fk_, fontsize=19)
plt.yticks(fontsize=19)
plt.legend(loc='upper right', fontsize=18, frameon=False)
plt.tight_layout()
#plt.savefig('stiffness_SMD_WT_mutant_40ns_50ns.png', dpi=300)
plt.savefig('stiffness_SMD_WT_mutant_40ns_50ns.svg')
plt.show()
