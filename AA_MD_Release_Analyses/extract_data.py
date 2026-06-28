import numpy as np
import matplotlib.pyplot as plt

#Load wt data
wt1 = np.loadtxt('distance_cv_wt_release_rep1.xvg', skiprows=17)#, usecols=1)
wt2 = np.loadtxt('distance_cv_wt_release_rep2.xvg', skiprows=17)#, usecols=1)
wt3 = np.loadtxt('distance_cv_wt_release_rep3.xvg', skiprows=17)#, usecols=1)

np.savetxt('distance_cv_wt_release_rep1.dat', np.column_stack((np.arange(0,len(wt1[:,0]))*0.01, wt1[:,1])))
np.savetxt('distance_cv_wt_release_rep2.dat', np.column_stack((np.arange(0,len(wt2[:,0]))*0.01, wt2[:,1])))
np.savetxt('distance_cv_wt_release_rep3.dat', np.column_stack((np.arange(0,len(wt3[:,0]))*0.01, wt3[:,1])))

#Load wt data
mt1 = np.loadtxt('distance_cv_mt_release_rep1.xvg', skiprows=17)#, usecols=1)
mt2 = np.loadtxt('distance_cv_mt_release_rep2.xvg', skiprows=17)#, usecols=1)
mt3 = np.loadtxt('distance_cv_mt_release_rep2.xvg', skiprows=17)#, usecols=1)

np.savetxt('distance_cv_mt_release_rep1.dat', np.column_stack((np.arange(0,len(mt1[:,0]))*0.01, mt1[:,1])))
np.savetxt('distance_cv_mt_release_rep2.dat', np.column_stack((np.arange(0,len(mt2[:,0]))*0.01, mt2[:,1])))
np.savetxt('distance_cv_mt_release_rep3.dat', np.column_stack((np.arange(0,len(mt3[:,0]))*0.01, mt3[:,1])))
