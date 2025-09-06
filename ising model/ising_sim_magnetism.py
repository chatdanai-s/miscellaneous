import numpy as np
import matplotlib.pyplot as plt

# Parameters
N = 50             # Array side size
steps = 10000      # Monte carlo steps
T = [1, 2, 3, 4]          # Temperatures (K)

# Create empty array for plotting
M = np.empty((4, int(steps/50)))

# Create value plot
for k in range(len(T)):
    temp = T[k]
    
    # Generate a random NxN matrix containing up and down spins at random
    lattice = np.random.choice([-1, 1], size=(N, N))
    
    # Metropolis algorithm for Ising model at temp = T
    for step in range(steps):
        # Observable change storing matrix
        # 1 denotes no change, -1 denotes change
        changes = np.full((N, N), 1)
        
        for i in range(N):
            # Pick random coordinate in lattice
            x, y = np.random.randint(0, N, size=2)
            
            # Calculate Hamiltonian difference if flipped
            neighbor_spins = \
                lattice[(x+1)%N, y] + lattice[(x-1)%N, y] + \
                lattice[x, (y+1)%N] + lattice[x, (y-1)%N]       
            dE = 2 * lattice[x, y] * neighbor_spins
            
            # Spin-flipping conditions
            # If resultant energy is decreased, else
            # there exists a probability of flipping
            if dE <= 0 or np.random.rand() < np.exp(-dE/temp):
                changes[x, y] *= -1
    
        # Flip spin according to change matrix
        lattice *= changes
        
        # Add magnetization to M every 50 steps
        if step % 50 == 0:

            magnetization = np.count_nonzero(lattice == 1) - np.count_nonzero(lattice == -1)
            
            index = int(step/50)
            M[k][index] = magnetization

    # Show progress
    print(f'T = {temp}')
        
M = np.abs(M)/N**2

# Plot graph
X = np.linspace(0, N*steps, int(steps/50))
plt.plot(X, M[0], color='red', label='T = 1K')
plt.plot(X, M[1], color='orange', label='T = 2K')
plt.plot(X, M[2], color='green', label='T = 3K')
plt.plot(X, M[3], color='blue', label='T = 4K')

plt.xlabel('Step count')
plt.ylabel('Absolute magnetization per site |M|/N')

plt.xlim((0, N*steps))
plt.ylim((0, 1.01))

plt.title(f'Evolution of |M|/N over step count on a {N}x{N} 2D Ising model')
plt.legend()




