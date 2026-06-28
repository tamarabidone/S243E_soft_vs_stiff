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


#Load wt data
wt1 = np.loadtxt('dist_wt_rep1.xvg', skiprows=3, usecols=1)
wt2 = np.loadtxt('dist_wt_rep2.xvg', skiprows=3, usecols=1)
wt3 = np.loadtxt('dist_wt_rep3.xvg', skiprows=3, usecols=1)
wt4 = np.loadtxt('dist_wt_rep4.xvg', skiprows=3, usecols=1)
wt5 = np.loadtxt('dist_wt_rep5.xvg', skiprows=3, usecols=1)
wt6 = np.loadtxt('dist_wt_rep6.xvg', skiprows=3, usecols=1)

#Bootstrapping
mean, err = block_bootstrap(wt1, block_size=100)
print('Rep1', mean, err)
mean, err = block_bootstrap(wt2, block_size=100)
print('Rep2', mean, err)
mean, err = block_bootstrap(wt3, block_size=100)
print('Rep3', mean, err)
mean, err = block_bootstrap(wt4, block_size=100)
print('Rep4', mean, err)
mean, err = block_bootstrap(wt5, block_size=100)
print('Rep5', mean, err)
mean, err = block_bootstrap(wt6, block_size=100)
print('Rep6', mean, err)

