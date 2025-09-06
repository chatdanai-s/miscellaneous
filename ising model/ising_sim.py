import numpy as np
import matplotlib.pyplot as plt
import gif     # Turns successive plots into gifs

# Define plotting function
@gif.frame
def plot(LATTICE, STEP, SIZE, TEMPERATURE):
    # Create a new figure
    fig = plt.figure(figsize=(6,6))
    plt.imshow(LATTICE, interpolation='None', cmap='plasma')
    
    plt.title(f'2D Ising model Monte carlo simulation\nwith size {SIZE}x{SIZE} (T={TEMPERATURE}, step {STEP})')
    fig.tight_layout() 
    
    # Return fig
    return fig

# Parameters
N = 50         # Array side size
steps = 10000  # Monte carlo steps
T = 4          # Temperature (K)

# Generate a random NxN matrix containing up and down spins at random
lattice = np.random.choice([-1, 1], size=(N, N))

# List containing monte carlo simulation frames
frames = []


# Metropolis algorithm for Ising model
for step in range(steps):
    # Creates "snapshot" and saves plot to frames
    if step % (steps/100) == 0:
        frames.append(plot(lattice, step*N, N, T))    
    
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
        if dE <= 0 or np.random.rand() < np.exp(-dE/T):
            changes[x, y] *= -1

    # Flip spin according to change matrix
    lattice *= changes
    
    # Show progress
    if step % (steps / 20) == 0:
        print(f'{step}/{steps}')

# Save frames to gif
gif.save(frames, 'ising_fast_T4.gif', duration=1)
