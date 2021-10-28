###cropping training image patches
import skimage as io
'''
'size1' is half of the LR image patches size
'size2' is half of the HR image patches size,size2 = 4*size1
'step1' is overlappping interval for LR
'step2' is overlappping interval for HR,step2 = 4*step1
'''
#
#generate mini LR data
from skimage import io
count1=1
img1 = io.imread('.\\Core1_Subvol1_LR.tif')
for z in range(15,210,15):
    for y in range(15,210,15):
        for x in range(15,210,15):
            if count1<25:
                img = img1[z-15:z+15,y-15:y+15,x-15:x+15]
                io.imsave('.\\Mini_data\\TRAIN\\LR\\' + str(count1)+'.tif',img)
                count1+=1
            elif 24<count1<31:
                img = img1[z-15:z+15,y-15:y+15,x-15:x+15]
                io.imsave('.\\Mini_data\\TEST\\LR\\' + str(count1)+'.tif',img)
                count1+=1
            else:
                break
#generate mini HR data
count1=1
img1 = io.imread('.\\Core1_Subvol1_HR.tif')
for z in range(15*3,210*3,15*3):
    for y in range(15*3,210*3,15*3):
        for x in range(15*3,210*3,15*3):
            if count1<25:
                img = img1[z-15*3:z+15*3,y-15*3:y+15*3,x-15*3:x+15*3]
                io.imsave('.\\Mini_data\\TRAIN\\HR\\' + str(count1)+'.tif',img)
                count1+=1
            elif 24<count1<31:
                img = img1[z-15*3:z+15*3,y-15*3:y+15*3,x-15*3:x+15*3]
                io.imsave('.\\Mini_data\\TEST\\HR\\' + str(count1)+'.tif',img)
                count1+=1
            else:
                break

