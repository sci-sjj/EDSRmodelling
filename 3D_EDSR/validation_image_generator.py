###validation mini data preparation
from skimage import io
#Generating mini validation sub-volumes to as the input data into trained EDSR
img = io.imread('.\\Core1_Subvol2_LR.tif')
count = 1
step = 5 #step is the counts related to how many sclies in per sub-volumes in z axis.
for i in range(0,2,step):
    img1 = img[i:i+step,:,:]
    io.imsave('.\\validation_data\\' + str(count) +'.tif',img1,imagej = True)
    count+=1


