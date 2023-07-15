import matplotlib.pyplot as plt
import matplotlib.animation as animation
import nibabel as nib

"""
This script takes a functional image and animates its time points.
"""

# Read functional image
functional_image_path = 'sub-4793/func/sub-4793_task-Words_run-01_bold.nii.gz' 
functional_image = nib.load(functional_image_path)
functional_data = functional_image.get_fdata()

# Choose a slice
slice = 32

# Create figure and initial data
fig, ax = plt.subplots()

time = functional_data[slice, :, :, 0]

img = ax.imshow(time.T, cmap='gray', origin='lower')
ax.axis('off')

def update(frame):
    time = functional_data[slice, :, :, frame]
    time = time.T
    img.set_array(time)
    return [img]

ani = animation.FuncAnimation(fig=fig, func=update, frames=functional_data.shape[3], interval=200, blit = False)
plt.show()