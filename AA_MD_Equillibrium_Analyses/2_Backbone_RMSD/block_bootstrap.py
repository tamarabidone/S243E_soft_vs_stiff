import numpy as np

def block_bootstrap(data, block_size, n_boot=1000):
    data = np.array(data)
    n = len(data)
    n_blocks = n // block_size
    
    # reshape into blocks
    blocks = data[:n_blocks * block_size].reshape(n_blocks, block_size)
    
    means = []
    
    for _ in range(n_boot):
        # resample blocks with replacement
        sampled_blocks = blocks[np.random.randint(0, n_blocks, n_blocks)]
        sample = sampled_blocks.flatten()
        means.append(np.mean(sample))
    
    return np.mean(data), np.std(means)

# data
mt1 = np.loadtxt('2_MT/backbone_rmsd_mt_rep1.dat', usecols=1)
mt2 = np.loadtxt('2_MT/backbone_rmsd_mt_rep2.dat', usecols=1)
mt3 = np.loadtxt('2_MT/backbone_rmsd_mt_rep3.dat', usecols=1)
mt4 = np.loadtxt('2_MT/backbone_rmsd_mt_rep4.dat', usecols=1)
mt5 = np.loadtxt('2_MT/backbone_rmsd_mt_rep5.dat', usecols=1)
mt6 = np.loadtxt('2_MT/backbone_rmsd_mt_rep6.dat', usecols=1)


#Bootstrapping
mean, err = block_bootstrap(mt1*0.1, block_size=50)
print('Rep1', mean, err)
mean, err = block_bootstrap(mt2*0.1, block_size=50)
print('Rep2', mean, err)
mean, err = block_bootstrap(mt3*0.1, block_size=50)
print('Rep3', mean, err)
mean, err = block_bootstrap(mt4*0.1, block_size=50)
print('Rep4', mean, err)
mean, err = block_bootstrap(mt5*0.1, block_size=50)
print('Rep5', mean, err)
mean, err = block_bootstrap(mt6*0.1, block_size=50)
print('Rep6', mean, err)

