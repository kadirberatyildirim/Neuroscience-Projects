"""
The purpose of this script is to generate a 3D structure that simulates a simple, abstract representation of the brain.

The idea behind this script is to simulate brain matter clusters using 3D Gaussian distributions within a defined 
volume. 

- Create an empty 3D array of a specified size to represent the brain volume. 
    - Random 'brain matter' clusters are created as Gaussian blobs at random locations within this volume. 
- Simulate ten such clusters. 
- Blur using a Gaussian filter to create smoother transitions between the brain matter and 
empty space, creating a more realistic appearance. 
- Threshold the resulting volume to generate a binary 3D image. Any values in the smoothed array below 0.5 
are set to 0 (representing empty space), and values equal to or above 0.5 are set to 1 (representing brain matter). 
- Visualize the result as a 3D plot using matplotlib's 'voxels' function, which visualizes the 3D 
numpy array as a set of voxels. 

Note that this is a highly simplified model and does not create a realistic brain image.
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage import gaussian_filter
from mpl_toolkits.mplot3d import Axes3D

# Define the size of the volume (e.g. 64x64x64)
shape = (64, 64, 64)

# Create an empty volume
brain = np.zeros(shape)

# Add random "brain matter" clusters
for _ in range(10):
    # Pick a random location for the center of the cluster
    x, y, z = (
        np.random.randint(0, shape[0]),
        np.random.randint(0, shape[1]),
        np.random.randint(0, shape[2]),
    )

    # Add a random-sized Gaussian at this location
    x_grid, y_grid, z_grid = np.ogrid[
        -x : shape[0] - x, -y : shape[1] - y, -z : shape[2] - z
    ]
    d = np.sqrt(x_grid * x_grid + y_grid * y_grid + z_grid * z_grid)
    sigma, mu = 15.0, 0.0
    g = np.exp(-((d - mu) ** 2 / (2.0 * sigma**2)))
    brain += g

# Apply a Gaussian filter to smooth the brain
brain = gaussian_filter(brain, sigma=2)

# Create a threshold to create binary image
brain[brain < 0.5] = 0
brain[brain >= 0.5] = 1

# Visualize the result
fig = plt.figure(figsize=(10, 10))
ax = fig.add_subplot(111, projection="3d")
ax.voxels(brain, edgecolor="k")
plt.show()
