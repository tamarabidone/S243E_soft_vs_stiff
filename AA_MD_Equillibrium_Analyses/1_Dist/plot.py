import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator

#Load wt data
wt_rep1 = np.loadtxt('dist_wt_rep1.xvg', skiprows=3, usecols=1)
wt_rep2 = np.loadtxt('dist_wt_rep2.xvg', skiprows=3, usecols=1)
wt_rep3 = np.loadtxt('dist_wt_rep3.xvg', skiprows=3, usecols=1)
wt_rep4 = np.loadtxt('dist_wt_rep4.xvg', skiprows=3, usecols=1)
wt_rep5 = np.loadtxt('dist_wt_rep5.xvg', skiprows=3, usecols=1)
wt_rep6 = np.loadtxt('dist_wt_rep6.xvg', skiprows=3, usecols=1)
wt_ = np.concatenate((wt_rep1, wt_rep2, wt_rep3, wt_rep4, wt_rep5, wt_rep6), axis=0)
print(wt_.shape)

#Load mt data
mt_rep1 = np.loadtxt('dist_mt_rep1.xvg', skiprows=3, usecols=1)
mt_rep2 = np.loadtxt('dist_mt_rep2.xvg', skiprows=3, usecols=1)
mt_rep3 = np.loadtxt('dist_mt_rep3.xvg', skiprows=3, usecols=1)
mt_rep4 = np.loadtxt('dist_mt_rep4.xvg', skiprows=3, usecols=1)
mt_rep5 = np.loadtxt('dist_mt_rep5.xvg', skiprows=3, usecols=1)
mt_rep6 = np.loadtxt('dist_mt_rep6.xvg', skiprows=3, usecols=1)
mt_ = np.concatenate((mt_rep1, mt_rep2, mt_rep3, mt_rep4, mt_rep5, mt_rep6), axis=0)
print(mt_.shape)

#Histogram
hist_w, bins_w = np.histogram(wt_, range=(7,12), density=True, bins=100)
hist_s, bins_s = np.histogram(mt_, range=(7,12), density=True, bins=100)
#hist_w, bins_w = np.histogram(dist_wt, range=(6.5,12), bins=100)
#hist_s, bins_s = np.histogram(dist_mt, range=(6.5,12), bins=100)
midpoints_w = bins_w[:-1]+(np.diff(bins_w)[0]/2)
midpoints_s = bins_s[:-1]+(np.diff(bins_s)[0]/2)
fe_w = -np.log(hist_w)
fe_s = -np.log(hist_s)

#Error Calculation WT
hist_w_E = np.zeros((6, len(bins_w)-1))
hist_w_E[0] = np.histogram(wt_rep1, range=(7,12), density=True, bins=100)[0]
hist_w_E[1] = np.histogram(wt_rep2, range=(7,12), density=True, bins=100)[0]
hist_w_E[2] = np.histogram(wt_rep3, range=(7,12), density=True, bins=100)[0]
hist_w_E[3] = np.histogram(wt_rep4, range=(7,12), density=True, bins=100)[0]
hist_w_E[4] = np.histogram(wt_rep5, range=(7,12), density=True, bins=100)[0]
hist_w_E[5] = np.histogram(wt_rep6, range=(7,12), density=True, bins=100)[0]
std_w = np.std(hist_w_E, axis=0)/np.sqrt(6)
std_w /= hist_w
std_w *= 0.434

#Error Calculation MT
hist_m_E = np.zeros((6, len(bins_s)-1))
hist_m_E[0] = np.histogram(mt_rep1, range=(7,12), density=True, bins=100)[0]
hist_m_E[1] = np.histogram(mt_rep2, range=(7,12), density=True, bins=100)[0]
hist_m_E[2] = np.histogram(mt_rep3, range=(7,12), density=True, bins=100)[0]
hist_m_E[3] = np.histogram(mt_rep4, range=(7,12), density=True, bins=100)[0]
hist_m_E[4] = np.histogram(mt_rep5, range=(7,12), density=True, bins=100)[0]
hist_m_E[5] = np.histogram(mt_rep6, range=(7,12), density=True, bins=100)[0]
std_m = np.std(hist_m_E, axis=0)/np.sqrt(6)
std_m /= hist_s
std_m *= 0.434


#Plotting
fig, ax = plt.subplots()
plt.rcParams['svg.fonttype'] = 'none'
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.tick_params(top=False, right=False)
color_wt = (0.35, 0.35, 0.35)
color_mt = (0.0, 0.77, 1) 
#eb1 = plt.errorbar(midpoints_w, fe_w-np.amin(fe_w), yerr=std_w, ecolor='lightgrey', capsize=3, elinewidth=1.5, lw=3.5, label='WT', color='gray', errorevery=3)
eb1 = plt.errorbar(midpoints_w, fe_w-np.amin(fe_w), yerr=std_w, ecolor='lightgrey', capsize=3, elinewidth=1.5, lw=3.5, label='WT', color=color_wt, errorevery=3)
eb1[-1][0].set_linestyle('--')
#eb2 = plt.errorbar(midpoints_w+0.15, fe_s-np.amin(fe_s), yerr=std_m, ecolor='lightgrey', capsize=3, elinewidth=1.5, lw=3.5, label='S243E', color='#03D5FB', errorevery=3)
eb2 = plt.errorbar(midpoints_w+0.15, fe_s-np.amin(fe_s), yerr=std_m, ecolor='lightgrey', capsize=3, elinewidth=1.5, lw=3.5, label='S243E', color=color_mt, errorevery=3)
eb2[-1][0].set_linestyle('--')

plt.ylim(-0.15,4.5)
plt.xlim(7.0,11.5)
plt.legend(loc='lower left', fontsize=18, frameon=False)
ax.yaxis.set_major_locator(MultipleLocator(1))
ax.xaxis.set_major_locator(MultipleLocator(1))
plt.xticks(fontsize=24)
plt.yticks(fontsize=24)
#plt.xlabel(r'D$_{\mathrm{Headgroup-Transmembrane}}$ (nm)', fontsize=28)
plt.xlabel('Distance (nm)', fontsize=30)
plt.ylabel(r'FE (k$_\beta$T)', fontsize=30)
#plt.grid(visible=True, linestyle='--')
plt.tight_layout()
#plt.savefig('FE_dist_HG-TM_wild_mutant.png', dpi=300)#, transparent=True)
plt.savefig('FE_dist_HG-TM_wild_mutant.svg', dpi=300)#, transparent=True)
plt.show()
