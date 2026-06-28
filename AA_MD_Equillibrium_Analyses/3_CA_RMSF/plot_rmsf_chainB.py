import numpy as np
import matplotlib.pyplot as plt

#Load wt data
wt1 = np.loadtxt('RMSF_wt/rmsf_ca_wt_rep1.dat', skiprows=1)#, usecols=1)
wt2 = np.loadtxt('RMSF_wt/rmsf_ca_wt_rep2.dat', skiprows=1)#, usecols=1)
wt3 = np.loadtxt('RMSF_wt/rmsf_ca_wt_rep3.dat', skiprows=1)#, usecols=1)
wt4 = np.loadtxt('RMSF_wt/rmsf_ca_wt_rep4.dat', skiprows=1)#, usecols=1)
wt5 = np.loadtxt('RMSF_wt/rmsf_ca_wt_rep5.dat', skiprows=1)#, usecols=1)
wt6 = np.loadtxt('RMSF_wt/rmsf_ca_wt_rep6.dat', skiprows=1)#, usecols=1)

#Load wt data
mt1 = np.loadtxt('RMSF_mt/rmsf_ca_mt_rep1.dat', skiprows=1)#, usecols=1)
mt2 = np.loadtxt('RMSF_mt/rmsf_ca_mt_rep2.dat', skiprows=1)#, usecols=1)
mt3 = np.loadtxt('RMSF_mt/rmsf_ca_mt_rep3.dat', skiprows=1)#, usecols=1)
mt4 = np.loadtxt('RMSF_mt/rmsf_ca_mt_rep4.dat', skiprows=1)#, usecols=1)
mt5 = np.loadtxt('RMSF_mt/rmsf_ca_mt_rep5.dat', skiprows=1)#, usecols=1)
mt6 = np.loadtxt('RMSF_mt/rmsf_ca_mt_rep6.dat', skiprows=1)#, usecols=1)

fig, axs = plt.subplots(2,1, figsize=(6.5, 4.5), sharex=True, layout='constrained', gridspec_kw={'hspace': 0.2})
plt.rcParams['svg.fonttype'] = 'none'

axs[0].plot(wt1[1018:,0], wt1[1018:,1]*0.1, color='#000000', label='Rep. 1')
axs[0].plot(wt2[1018:,0], wt2[1018:,1]*0.1, color='#444444', label='Rep. 2')
axs[0].plot(wt3[1018:,0], wt3[1018:,1]*0.1, color='#696969', label='Rep. 3')
axs[0].plot(wt4[1018:,0], wt4[1018:,1]*0.1, color='#808080', label='Rep. 4')
axs[0].plot(wt5[1018:,0], wt5[1018:,1]*0.1, color='#C0C0C0', label='Rep. 5')
axs[0].plot(wt6[1018:,0], wt6[1018:,1]*0.1, color='#DCDCDC', label='Rep. 6')
axs[0].tick_params(axis='both', which='major', labelsize=14)
axs[0].set_ylim(0, 2.5)
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


axs[1].plot(mt1[1018:,0], mt1[1018:,1]*0.1, color='#007171', label='Rep. 1')
axs[1].plot(mt2[1018:,0], mt2[1018:,1]*0.1, color='#008B8B', label='Rep. 2')
axs[1].plot(mt3[1018:,0], mt3[1018:,1]*0.1, color='#00AAAA', label='Rep. 3')
axs[1].plot(mt4[1018:,0], mt4[1018:,1]*0.1, color='#00C6C6', label='Rep. 4')
axs[1].plot(mt5[1018:,0], mt5[1018:,1]*0.1, color='#00E3E3', label='Rep. 5')
axs[1].plot(mt6[1018:,0], mt6[1018:,1]*0.1, color='#00FFFF', label='Rep. 6')
axs[1].tick_params(axis='both', which='major', labelsize=14)
axs[1].set_ylim(0, 2.5)
axs[1].set_xlim(1,762)
axs[1].set_title('S243E', fontsize=14, y=0.85)
axs[1].set_xlabel(r'Residue No. / Chain $\mathrm{\beta}$', fontsize=16)
fig.supylabel('RMSF (nm)', fontsize=16)
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

#plt.savefig('rmsf_chainB_replica_wt_mt.png', dpi=300)
plt.savefig('rmsf_chainB_replica_wt_mt.svg')
plt.show()
