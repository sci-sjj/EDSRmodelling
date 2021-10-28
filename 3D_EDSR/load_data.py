###training/testing/validation data generation
import torch.utils.data as data
import torch
import glob
import random
import os
from torch.utils.data import Dataset
from PIL import Image
import torchvision.transforms as transforms
from os import listdir
from skimage import io
from os.path import join
import numpy as np
from torchvision.transforms import Compose,ToTensor
class TrainDatasetFromFolder(Dataset):
    def __init__(self, root):
        super(TrainDatasetFromFolder, self).__init__()
        self.image_filenames1 = [join(root, x) for x in listdir(root)][0]
        self.image_filenames2 = [join(root, x) for x in listdir(root)][1]
        LIST1 = listdir(self.image_filenames1)
        LIST2 = listdir(self.image_filenames2)
        LIST1.sort(key=lambda x: int(x[:-4]))
        LIST2.sort(key=lambda x: int(x[:-4]))
        self.img1 = [join(self.image_filenames1, x) for x in LIST1]
        self.img2 = [join(self.image_filenames2, x) for x in LIST2]
        self.train_hr_transform = tensor_transform()
        self.train_lr_transform = tensor_transform()

    def __getitem__(self, index):
        hr_image = self.train_lr_transform(io.imread(self.img1[index]))
        lr_image = self.train_lr_transform(io.imread(self.img2[index]))
        hr_image = np.expand_dims(hr_image, axis=0)
        lr_image = np.expand_dims(lr_image, axis=0)
        return lr_image,hr_image

    def __len__(self):
        return len(self.img1)

def tensor_transform():
    return Compose([
        ToTensor(),
    ])

class TestDatasetFromFolder(Dataset):
    def __init__(self, root):
        super(TestDatasetFromFolder, self).__init__()
        self.image_filenames1 = [join(root, x) for x in listdir(root)][0]
        self.image_filenames2 = [join(root, x) for x in listdir(root)][1]
        LIST1 = listdir(self.image_filenames1)
        LIST2 = listdir(self.image_filenames2)
        LIST1.sort(key=lambda x: int(x[:-4]))
        LIST2.sort(key=lambda x: int(x[:-4]))
        self.img1 = [join(self.image_filenames1, x) for x in LIST1]
        self.img2 = [join(self.image_filenames2, x) for x in LIST2]
        self.train_hr_transform = tensor_transform()
        self.train_lr_transform = tensor_transform()

    def __getitem__(self, index):
        hr_image = self.train_lr_transform(io.imread(self.img1[index]))
        lr_image = self.train_lr_transform(io.imread(self.img2[index]))
        hr_image = np.expand_dims(hr_image, axis=0)
        lr_image = np.expand_dims(lr_image, axis=0)
        return lr_image,hr_image

    def __len__(self):
        return len(self.img1)

class ValidationDatasetFromFolder(Dataset):
    def __init__(self, root):
        super(ValidationDatasetFromFolder, self).__init__()
        self.image_filenames1 = [join(root, x) for x in listdir(root)][0]
        LIST1 = listdir(self.image_filenames1)
        LIST1.sort(key=lambda x: int(x[:-4]))
        self.img1 = [join(self.image_filenames1, x) for x in LIST1]
        self.train_lr_transform = tensor_transform()

    def __getitem__(self, index):
        lr_image = self.train_lr_transform(io.imread(self.img1[index]))
        lr_image = np.expand_dims(lr_image, axis=0)
        return lr_image

    def __len__(self):
        return len(self.img1)
