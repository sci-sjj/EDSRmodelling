import torch
import torch.nn as nn
###3D EDSR model structure
def default_conv(in_channelss, out_channels, kernel_size, bias=True):
    return nn.Conv3d(
        in_channelss, out_channels, kernel_size,
        padding=(kernel_size // 2), bias=bias)

class ResBlock(nn.Module):
    def __init__(
            self, conv, n_feat, kernel_size,
            bias=True, bn=False, act=nn.ReLU(True), res_scale=1):

        super(ResBlock, self).__init__()
        modules_body = []
        for i in range(2):
            modules_body.append(conv(n_feat, n_feat, kernel_size, bias=bias))
            if bn: modules_body.append(nn.BatchNorm2d(n_feat))
            if i == 0: modules_body.append(act)

        self.body = nn.Sequential(*modules_body)
        self.res_scale = res_scale

    def forward(self, x):
        res = self.body(x).mul(self.res_scale)
        res += x

        return res


class EDSR(nn.Module):
    def __init__(self, conv=default_conv):
        super(EDSR, self).__init__()
        n_feats = 24 # 64
        kernel_size = 3
        n_resblock = 12  # 16
        act = nn.ReLU(True)
        res_scale = 1
        scale = 3

        self.head = nn.Sequential(conv(1, n_feats, kernel_size))

        modules_body = [
            ResBlock(
                conv, n_feats, kernel_size, act=act, res_scale=res_scale) for _ in range(n_resblock)]
        self.body = nn.Sequential(*modules_body)

        modules_tail = [
            nn.Upsample(scale_factor=scale, mode='trilinear'),
            conv(n_feats, 1, kernel_size)]
        self.tail = nn.Sequential(*modules_tail)

    def forward(self, x):
        x = x.contiguous()
        x = self.head(x)

        res = self.body(x)
        res += x

        x = self.tail(res)

        #x = torch.squeeze(x, dim=1)
        return x
