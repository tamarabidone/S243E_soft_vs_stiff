import numpy as np
import matplotlib.pyplot as plt

#Load wt data
wt1 = np.loadtxt('dist_wt_rep1.xvg', skiprows=3, usecols=1)
wt2 = np.loadtxt('dist_wt_rep2.xvg', skiprows=3, usecols=1)
wt3 = np.loadtxt('dist_wt_rep3.xvg', skiprows=3, usecols=1)
wt4 = np.loadtxt('dist_wt_rep4.xvg', skiprows=3, usecols=1)
wt5 = np.loadtxt('dist_wt_rep5.xvg', skiprows=3, usecols=1)
wt6 = np.loadtxt('dist_wt_rep6.xvg', skiprows=3, usecols=1)

#Load wt data
mt1 = np.loadtxt('dist_mt_rep1.xvg', skiprows=3, usecols=1)
mt2 = np.loadtxt('dist_mt_rep2.xvg', skiprows=3, usecols=1)
mt3 = np.loadtxt('dist_mt_rep3.xvg', skiprows=3, usecols=1)
mt4 = np.loadtxt('dist_mt_rep4.xvg', skiprows=3, usecols=1)
mt5 = np.loadtxt('dist_mt_rep5.xvg', skiprows=3, usecols=1)
mt6 = np.loadtxt('dist_mt_rep6.xvg', skiprows=3, usecols=1)

fig, axs = plt.subplots(2,1, figsize=(6.5, 4.5), sharex=True, layout='constrained', gridspec_kw={'hspace': 0.2})
plt.rcParams['svg.fonttype'] = 'none'
axs[0].plot(np.arange(0, len(wt1))*0.00001, wt1, color='#000000', label='Rep. 1')
axs[0].plot(np.arange(0, len(wt2))*0.00001, wt2, color='#444444', label='Rep. 2')
axs[0].plot(np.arange(0, len(wt3))*0.00001, wt3, color='#696969', label='Rep. 3')
axs[0].plot(np.arange(0, len(wt4))*0.00001, wt4, color='#808080', label='Rep. 4')
axs[0].plot(np.arange(0, len(wt5))*0.00001, wt5, color='#C0C0C0', label='Rep. 5')
axs[0].plot(np.arange(0, len(wt6))*0.00001, wt6, color='#DCDCDC', label='Rep. 6')
axs[0].tick_params(axis='both', which='major', labelsize=14)
axs[0].set_ylim(6, 12.5)
axs[0].set_title('WT', fontsize=14, y=0.85)#, pad=10)
axs[0].spines['top'].set_visible(False)
axs[0].spines['right'].set_visible(False)
leg = axs[0].legend(loc='center right', bbox_to_anchor=(1.3, 0.5), fontsize=12, frameon=False)
leg_lines = leg.get_lines()
leg_lines[0].set_linewidth(3.5)  # Set line 1 in legend to width 5
leg_lines[1].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[2].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[3].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[4].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[5].set_linewidth(3.5)  # Set line 2 in legend to width 2


axs[1].plot(np.arange(0, len(mt1))*0.00001, mt1, color='#007171', label='Rep. 1')
axs[1].plot(np.arange(0, len(mt2))*0.00001, mt2, color='#008B8B', label='Rep. 2')
axs[1].plot(np.arange(0, len(mt3))*0.00001, mt3, color='#00AAAA', label='Rep. 3')
axs[1].plot(np.arange(0, len(mt4))*0.00001, mt4, color='#00C6C6', label='Rep. 4')
axs[1].plot(np.arange(0, len(mt5))*0.00001, mt5, color='#00E3E3', label='Rep. 5')
axs[1].plot(np.arange(0, len(mt6))*0.00001, mt6, color='#00FFFF', label='Rep. 6')
axs[1].tick_params(axis='both', which='major', labelsize=14)
axs[1].set_ylim(6, 12.5)
axs[1].set_xlim(0,1)
axs[1].set_title('S243E', fontsize=14, y=0.85)
axs[1].set_xlabel(r'Time ($\mathrm{\mu}$s)', fontsize=16)
#fig.supylabel(r'Distance ($\mathrm{\AA}$)', fontsize=16)
fig.supylabel('Distance (nm)', fontsize=16)
axs[1].spines['top'].set_visible(False)
axs[1].spines['right'].set_visible(False)
leg = axs[1].legend(loc='center right', bbox_to_anchor=(1.3, 0.5), fontsize=12, frameon=False)
leg_lines = leg.get_lines()
leg_lines[0].set_linewidth(3.5)  # Set line 1 in legend to width 5
leg_lines[1].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[2].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[3].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[4].set_linewidth(3.5)  # Set line 2 in legend to width 2
leg_lines[5].set_linewidth(3.5)  # Set line 2 in legend to width 2
#plt.savefig('distance_replica_wt_mt.png', dpi=300)
plt.savefig('distance_replica_wt_mt.svg')#
plt.show()
