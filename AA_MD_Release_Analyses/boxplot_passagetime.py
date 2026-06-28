import numpy as np
import matplotlib.pyplot as plt

def filtered(data):
	threshold = 10
	filtered = [data[0]]
	for val in data[1:]:
		# Compare with last accepted value
		if  val - filtered[-1] > threshold:
			filtered.append(val)

	filtered = np.array(filtered)
	# Keep first value, subtract previous value from current ones
	passage_times = np.empty_like(filtered)
	passage_times[0] = filtered[0]
	passage_times[1:] = filtered[1:] - filtered[:-1]
	return passage_times


#Load wt data
wt1 = np.loadtxt('distance_cv_wt_release_rep1.xvg', skiprows=17)#, usecols=1)
wt2 = np.loadtxt('distance_cv_wt_release_rep2.xvg', skiprows=17)#, usecols=1)
wt3 = np.loadtxt('distance_cv_wt_release_rep3.xvg', skiprows=17)#, usecols=1)


#Load wt data
mt1 = np.loadtxt('distance_cv_mt_release_rep1.xvg', skiprows=17)#, usecols=1)
mt2 = np.loadtxt('distance_cv_mt_release_rep2.xvg', skiprows=17)#, usecols=1)
mt3 = np.loadtxt('distance_cv_mt_release_rep3.xvg', skiprows=17)#, usecols=1)

#Bent state
target_value = 9.25

time = np.arange(0, len(wt1))*0.01

#crossing time
cross_indices_wt1 = np.where(np.diff(np.sign(wt1[:,1] - target_value)))[0]
cross_indices_wt2 = np.where(np.diff(np.sign(wt2[:,1] - target_value)))[0]
cross_indices_wt3 = np.where(np.diff(np.sign(wt3[:,1] - target_value)))[0]
cross_indices_mt1 = np.where(np.diff(np.sign(mt1[:,1] - target_value)))[0]
cross_indices_mt2 = np.where(np.diff(np.sign(mt2[:,1] - target_value)))[0]
cross_indices_mt3 = np.where(np.diff(np.sign(mt3[:,1] - target_value)))[0]

wt1_ = filtered(time[cross_indices_wt1])
wt2_ = filtered(time[cross_indices_wt2])
wt3_ = filtered(time[cross_indices_wt3])
mt1_ = filtered(time[cross_indices_mt1])
mt2_ = filtered(time[cross_indices_mt2])
mt3_ = filtered(time[cross_indices_mt3])

passage_time_wt = np.concatenate((wt1_, wt2_, wt3_))
passage_time_mt = np.concatenate((mt1_, mt2_, mt3_))




fig, ax = plt.subplots()
plt.rcParams['svg.fonttype'] = 'none'
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.tick_params(top=False, right=False)

ax.boxplot(passage_time_wt, positions=[1], showfliers=False, patch_artist=True,
                medianprops={'color': 'black', 'linewidth': 1},
                boxprops={'edgecolor': 'black', 'linewidth': 0.5, 'facecolor': 'gray'},
                  whiskerprops=dict(color='lightgrey', linewidth=1.0, linestyle='--'),
                  capprops = {'color': 'lightgrey', 'linewidth': 1, 'linestyle': '-'}, label='WT')#,
                   #patch_artist=True,  # fill with color
                   #tick_labels=labels)  # will be used to label x-ticks

ax.boxplot(passage_time_mt, positions=[2], showfliers=False, patch_artist=True,
                medianprops={'color': 'black', 'linewidth': 1},
                boxprops={'edgecolor': 'black', 'linewidth': 0.5, 'facecolor': '#03D5FB'},
                whiskerprops=dict(color='lightgrey', linewidth=1.0, linestyle= '--'),
                capprops = {'color': 'lightgrey', 'linewidth': 1, 'linestyle': '-'}, label='S243E')#,

ax.set_ylabel('Passage time (ns)', fontsize=20)
ax.set_xticks([1, 2])
ax.set_xticklabels(['WT', 'S243E'], fontsize=20)
plt.yticks(fontsize=19)


#plt.xlabel('Force (pN)', fontsize=28)
#plt.ylabel('Passage time (ns)', fontsize=28)
#plt.ylim(0.91,1.345)
#ax.yaxis.set_major_locator(MultipleLocator(0.1))
#plt.xticks(x_positions, fk_, fontsize=19)
#plt.legend(loc='upper right', fontsize=18, frameon=False)
plt.tight_layout()
plt.savefig('passage_times_wt_s243e.png', dpi=300)
#plt.savefig('stiffness_SMD_WT_mutant_40ns_50ns.svg')
plt.show()
