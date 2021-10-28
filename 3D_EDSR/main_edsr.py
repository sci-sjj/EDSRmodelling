###main code for EDSR training
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
from load_data import TrainDatasetFromFolder,TestDatasetFromFolder
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
    "dir_train_data": '.\\Mini_data\\TRAIN\\',
    "dir_test_data": '.\\Mini_data\\TEST\\',
    "batchSize": 1,
    "nEpochs":1,
    "lr":1e-4,
    "step":10,
    "start_epoch":1,
    "momentum":0.9,
    "cuda":2,
    "threads":1,
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
    #load train/test data
    train_set = TrainDatasetFromFolder(opt.dir_train_data)
    test_set = TestDatasetFromFolder(opt.dir_test_data)
    training_data_loader = DataLoader(dataset=train_set, num_workers=opt.threads, batch_size=opt.batchSize,shuffle=True)
    test_data_loader = DataLoader(dataset=test_set, num_workers=opt.threads, batch_size=opt.batchSize,shuffle=False)
    print("===> Building model")
    model = EDSR()
    criterion = nn.L1Loss(size_average=True)
    print("===> Setting GPU")
    model = model.to(device)
    criterion = criterion.to(device)

    print("===> Setting Optimizer")
    print("===> Training")
    for epoch in range(opt.start_epoch, opt.nEpochs + 1):
        optimizer = optim.Adam(model.parameters(), lr=opt.lr, betas=(0.9, 0.999))
        lr = adjust_learning_rate(optimizer, epoch-1)
        for param_group in optimizer.param_groups:
            param_group["lr"] = lr
        print("Epoch={}, lr={}".format(epoch, optimizer.param_groups[0]["lr"]))
        train(training_data_loader, optimizer, model, criterion, epoch)
        save_checkpoint(model, epoch)
        test(test_data_loader, optimizer, model, criterion, epoch)
    torch.save(model.state_dict(),'.\\3D_EDSR.pt')
def adjust_learning_rate(optimizer, epoch):
    """Sets the learning rate to the initial LR decayed by 10"""
    lr = opt.lr * (0.1 ** (epoch // opt.step))
    return lr

def train(training_data_loader, optimizer, model, criterion, epoch):
    model.train()
    for iteration, batch in enumerate(training_data_loader, 1):
        input, target = Variable(batch[0]), Variable(batch[1],requires_grad=False)  #requires_grad=False
        input = input.to(device)
        target = target.to(device)
        sr = model(input)
        loss = criterion(sr, target)
        loss = loss.to(device)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        mse = torch.mean((sr - target) ** 2)
        psnr =  10 * math.log10(1.0 / torch.mean(mse))
        print("===> Epoch[{}]({}/{}): Loss: {:.10f} psnr:{:.10f}".format(epoch, iteration, len(training_data_loader), loss.item(),psnr))
def test(test_data_loader, optimizer, model, criterion, epoch):
    model.eval()
    for iteration, batch in enumerate(test_data_loader, 1):
        with torch.no_grad():
            input, target = Variable(batch[0]), Variable(batch[1], requires_grad=False)
            input = input.to(device)
            target = target.to(device)
            sr = model(input)
            loss = criterion(sr, target)
            loss = loss.to(device)
            mse = torch.mean((sr - target) ** 2)
            psnr = 10 * math.log10(1.0 / torch.mean(mse))
            print("===> Epoch[{}]({}/{}): Loss: {:.10f} psnr: {:.10f}".format(epoch, iteration, len(test_data_loader), loss.item(), psnr))

if __name__ == "__main__":
    main()