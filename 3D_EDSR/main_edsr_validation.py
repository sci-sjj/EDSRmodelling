## generate 3D SR sub-images and stack sub-images to whole images
import argparse, os
import torch
import math, random
import torch.backends.cudnn as cudnn
import torch.nn as nn
import torch.optim as optim
from torch.autograd import Variable
from torch.utils.data import DataLoader
from skimage import img_as_ubyte
from edsr_x3_3d import EDSR
from load_data import ValidationDatasetFromFolder
import math
import matplotlib.pyplot as plt
import numpy as np
import sys
from skimage import io
import cv2
from math import log10
import easydict
#Training settings
opt = easydict.EasyDict({
    "dir_validation_data": 'validation image root',
    "batchSize": 1,
    "nEpochs":1,
    "cuda":2,
})
device = torch.device("cuda:{}".format(opt.cuda))
def main():
    global opt, model
    cuda = opt.cuda
    if cuda and not torch.cuda.is_available():
        raise Exception("No GPU found, please run without --cuda")
    opt.seed = random.randint(1, 10000)
    print("Random Seed: ", opt.seed)
    torch.manual_seed(opt.seed)
    cudnn.benchmark = True
    print("===> Loading datasets")
    validation_set = ValidationDatasetFromFolder(opt.dir_validation_data)
    validation_data_loader = DataLoader(dataset=validation_set, num_workers=opt.threads, batch_size=opt.batchSize,shuffle=False)
    print("===> Building model")
    model = EDSR()
    print("===> Setting GPU")
    model = model.to(device)
    print("===> Training")
    model_trained = torch.load('.\\3D_EDSR.pt')
    model.load_state_dict(model_trained,strict=False)
    validate(validation_data_loader, optimizer, model, criterion, epoch)
def adjust_learning_rate(optimizer, epoch):
    """Sets the learning rate to the initial LR decayed by 10"""
    lr = opt.lr * (0.1 ** (epoch // opt.step))
    return lr

def validate(validate_data_loader, optimizer, model, criterion, epoch):
    model.eval()
    count = 1
    for iteration, batch in enumerate(test_data_loader, 1):
        with torch.no_grad():
            input, target = Variable(batch[0]), Variable(batch[0], requires_grad=False)
            input = input.to(device)
            input = target.to(device)
            sr = model(input)
            sr = sr.squeeze()
            sr = sr.cpu().numpy()
            sr = img_as_ubyte(np.clip(sr, 0, 1))
            sr = np.swapaxes(sr, 0, 1)
            sr = np.swapaxes(sr, 1, 2)
            io.imsave(sr_img_root + str(count) +'.tif',sr)
            count +=1
    stack_img3d(sr_img_root)
def stack_img3d(sr_img_root):
    list = []
    for i in range(1,num,1):
        img = io.imread(sr_img_root + str(i) +'.tif')
        list.append(img)
    volume3d = np.vstack(list)
    io.imsave(sr_img_root + str(i) +'.tif',volume3d)
    
    return volume3d

if __name__ == "__main__":
    main()