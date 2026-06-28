import numpy as np

wt = np.loadtxt('1_wt/combined_pullX_wt_fk20_rep2.dat', skiprows=1, usecols=1)
mt = np.loadtxt('2_mt/combined_pullX_mt_fk20_rep3.dat', skiprows=1, usecols=1)

# Find common values
common = np.intersect1d(wt, mt)

# Get indices in each array
idx_wt = np.where(np.isin(wt, common[-1]))[0]
idx_mt = np.where(np.isin(mt, common[-1]))[0]

print(idx_wt)
print(idx_mt)
