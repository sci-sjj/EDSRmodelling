EDSR modelling
=====
A Github repository for deep-learning image enhancement, pore-network and continuum modelling from X-Ray Micro-CT images. The repository contains all code necessary to recreate the results in the paper [1]. The images that are used in various parts of the code are found on Zenodo, at DOI: 10.5281/zenodo.5542624. There is previous experimental and modelling work performed in the papers of [2,3]. 


![Workflow](media/workflow.png)
*Summary of the workflow, flowing from left to right. First, the EDSR network is trained \& tested on paired LR and HR data to produce SR data which emulates the HR data. Second, the trained EDSR is applied to the whole core LR data to generate a whole core SR image. A pore-network model (PNM) is then used to generate 3D continuum properties at REV scale from the post-processed image. Finally, the 3D digital model is validated through continuum modelling (CM) of the muiltiphase flow experiments.*

The files are ordered numerically in their intended usage. The codes below operate on the low resolution (LR), high resolution (HR) and super-resolution (SR) images. These can be downloaded at the Zenodo repository above. The SR image was created using the LR data and the EDSR deep learning model, contained in the folder 'EDSR'. There are specific usage instructions as well as a Jupyter notebook therein detailing how the network was trained, and tested. Once these raw images have been created, the following files can be run:


The workflow image above summarises the general approach. We list the detailed steps in the workflow below, linking to specific files and folders where necesary. 

# 1. Generating LR, Cubic and HR data
The low resolution (LR) and high resolution (HR) can be downloaded from Zenodo at DOI: 10.5281/zenodo.5542624. The following code can then be run:

* [A0_0_0_Generate_LR_bicubic.m](./A0_0_0_Generate_LR_bicubic.m) This code generates Cubic interpolation images from LR images, artifically decreasing the pixel size and interpolating, for use in comparison to HR and SR images later.
* [A0_0_1_Generate_filtered_images_LR_HR.m](./A0_0_1_Generate_filtered_images_LR_HR.m). This code performs non-local means filtering of the LR, cubic and HR images, given the settings in the paper [1]. 

# 2. EDSR network training 
The 3d EDSR (Enhanced Deep Super Resolution) convolution neural network used in this work is based on the implementation of the CVPR2017 workshop Paper: "Enhanced Deep Residual Networks for Single Image Super-Resolution" (https://arxiv.org/pdf/1707.02921.pdf) using PyTorch. 

The folder [3D_EDSR](./3D_EDSR) contains the EDSR network training & testing code. The code is written in Python, and tested in the following environment:
* Windows 10
* Python 3.7.4
* Pytorch 1.8.1
* cuda 11.2
* cudnn 8.1.0

The Jupyter notebook [Train_review.ipynb](./3D_EDSR/Train_review.ipynb), contains cells with the individual .py codes copied in to make one continuous workflow that can be run for EDSR training and validation. In this file, and those listed below, the LR and HR data used for training should be stored in the top level of [3D_EDSR](./3D_EDSR), respectively, as:

* Core1_Subvol1_LR.tif
* Core1_Subvol1_HR.tif

To generate suitable training images (sub-slices of the full data above), the following code can be run:

* [train_image_generator.py](./3D_EDSR/train_image_generator.py). This generates LR and registered x3 HR sub-images for EDSR training, sub-image sizes are of  flexible size, dependent on the pore-structure. The LR/HR sub-images are separated into two different folders [LR](./3D_EDSR/Mini_data/TEST/LR) and [HR](./3D_EDSR/Mini_data/TEST/HR)

The EDSR model can then be trained on the LR and HR sub-sampled data via:

* [main_edsr.py](./3D_EDSR/main_edsr.py). This trains the EDSR network on the LR/HR data. it requires the code [load_data.py](./3D_EDSR/load_data.py), which is the sub-image loader for EDSR trainin. It also requires the 3D EDSR model structure code [edsr_x3_3d.py](./3D_EDSR/edsr_x3_3d.py). The code then saves the trained network as [3D_EDSR.pt](./3D_EDSR/3D_EDSR.pt). The version supplied here is that trained and used in the paper.  

To view the training loss performance, the data can be output and saved to .txt files. The data can then be used in:

* [A0_0_5_Plot_EDSR_loss.m](./A0_0_5_Plot_EDSR_loss.m). This simply plots the trained EDSR model loss and PSNR. The data for the publication EDSR are stored in  [EDSR_training_results](./EDSR_training_results). 

# 3. EDSR network verification

The trained EDSR network at [3D_EDSR.pt](./3D_EDSR/3D_EDSR.pt) can be verified by generating SR images from a different LR image to that which was used in training. Here we use the second subvolume from core 1, found on from Zenodo at DOI: 10.5281/zenodo.5542624:

* Core1_Subvol2_LR.tif

The trained EDSR model can then be run on the LR data using:

* [validation_image_generator.py](./3D_EDSR/validation_image_generator.py). This creates input validation LR images. The validation LR images have large size in x,y axes and small size in z axis to reduce computational cost.
* [main_edsr_validation.py](./3D_EDSR/main_edsr_validation.py).  The to validation LR images are used with the trained EDSR model ato generate 3D SR subimages. These can be saved in the folder [SR_subdata](./3D_EDSR/SR_subdata) as the  Jupyter notebook [Train_review.ipynb](./3D_EDSR/Train_review.ipynb) does. The  SR subimages are then stacked to form a whole 3D SR image.

Follow the generation of suitable verification images, various metrics can be calculated from the images to judge performance against the true HR data:

* [A0_0_2_Generate_histogram_data.m](./A0_0_2_Generate_histogram_data.m). This code generates histograms of the LR, Cubic, HR and SR image grey scale values for comparison. The results are saved to [Matlab_results](./Matlab_results).
* [A0_0_3_Generate_SSIM_2D_3D.m](./A0_0_3_Generate_SSIM_2D_3D.m). This code generates structural similarity index measures between the Cubic, HR and SR images. The results are saved to [Matlab_results](./Matlab_results).
* [A0_0_4_Generate_run_PNM_LR_Cubic_HR_SR_subvolumes.m](./A0_0_4_Generate_run_PNM_LR_Cubic_HR_SR_subvolumes.m). This generates a pore-network model (PNM) of the LR, Cubic and SR subvolume images. The code as default does this for all 4 subvolumes in Core 1 and Core 2, but can be set to only run for one validation subvolume as required. The code generates multiple networks across different segmentation realizations for the LR, Cubic, HR and SR images. The networks are used in the pore-network modelling approach from the ICL Github: (https://github.com/ImperialCollegeLondon/pnextract, https://github.com/ImperialCollegeLondon/pnflow). The results are saved to [Matlab_results](./Matlab_results) as [Results_PNM_whole_core_LR_EDSR.m](./Matlab_results/Results_PNM_whole_core_LR_EDSR.m) 

Following the generation of these metrics, several plotting codes can be run to compare LR, Cubic, HR and SR results:

* [A0_1_0_Plot_raw_filtered_images_2D.m](./A0_1_0_Plot_raw_filtered_images_2D.m). This plots the raw and filtered LR, Cubic, HR and SR images for comparison. It plots a selected 2D slice. 
* [A0_1_1_Plot_histograms.m](./A0_1_1_Plot_histograms.m). This plots the histograms of the image greyscale values on top of each other for comparison purposes from [Matlab_results](./Matlab_results).
* [A0_1_2_Plot_filtered_image_similarities.m](./A0_1_2_Plot_filtered_image_similarities.m). The plots the fitlered SSIM from [Matlab_results](./Matlab_results).
* [A0_1_3_Plot_PNM_LR_HR_EDSR_sensitivity.m](./A0_1_3_Plot_PNM_LR_HR_EDSR_sensitivity.m). This plots the petrophysical predictions from the PNM across the different image subvolumes and segmentation realisations for the LR, Cubic, HR and SR images from [Results_PNM_whole_core_LR_EDSR.m](./Matlab_results/Results_PNM_whole_core_LR_EDSR.m) 

# 3. Continuum modelling and validation

After the EDSR images have been verified using the image metrics and pore-network model simulations, the EDSR network can be used to generate continuum scale models, for validation with experimental results. First, the following codes are run on each subvolume of the whole core images, as per the verification section:

* [validation_image_generator.py](./3D_EDSR/validation_image_generator.py).
* [main_edsr_validation.py](./3D_EDSR/main_edsr_validation.py). 

These should be run on subvolumes from the whole core images. The subvolumes (and whole-core) images can be found on the [Digital Rocks Portal](http://digitalrocksportal.org/projects/229) and on the [BGS National Geoscience Data Centre](http://dx.doi.org/10.5285/5f899de8-4085-4370-a45e-e613f27e8f1d), respectively. 






11. A1_0_0_Generate_run_PNM_whole_core.m. This code generates pore-networks for each subvolume in the full core images. It generates this for both the LR and SR images. The networks are then used in the pore-network modelling approach from the ICL Github: (https://github.com/ImperialCollegeLondon/pnextract, https://github.com/ImperialCollegeLondon/pnflow). The results are saved to individual subvolume files for each core. 



13. A1_0_1_Compile_whole_core_PNM.m. This compiles the individual subvolume results from the previous code into one single .mat file. 
14. A1_0_2_Plot_whole_core_PNM.m. This plots various petrophysical results for each subvolume in the whole cores.

14. A1_1_0_Generate_run_IMEX_continuum_model_core_1.m. This generates continuum models in CMG IMEX using the PNM petrophysical data from files 11 - 13 above. It does this for Core 1. It then runs the files in CMG IMEX (if installed) and then processing and saves the data. 
15. A1_1_1_Generate_run_IMEX_continuum_model_core_2.m. This generates continuum models in CMG IMEX using the PNM petrophysical data from files 11 - 13 above. It does this for Core 2.It then runs the files in CMG IMEX (if installed) and then processing and saves the data. 
16. A1_1_2_Plot_IMEX_continuum_results.m. This plots the continuum model results from 14, 15 above in terms of 3D saturations and pressure compared to the experimental results from [2]. 
17. Whole_core_results_exp_sim.xlsx. This is a summary file containing experimental and simualtions results in tabular form, which also appear in the paper [1].

Folders
=====
1. CMG_IMEX_files. This contains example CMG imex .dat and .inc files generated using file 14 above. 
2. Continuum_modelling_results. This contains the processed results from the continuum modelling simulations in files 14 and 15. 
4. Exp_data. This contains experimental data from [2]. 
5. Functions. This contains functions used in the .m files 1 - 17 above. 
6. Matlab_results. This contains various matab .mat datafiles used in the plotting codes above.
7. PNM_whole_core_LR_EDSR_results. This contains the PNM whole core results for each subvolume in each core, at two different segmentation realisations. Used in files 13-16 above.
8. media. This folder contains the workflow image.

References
=====
[1] Jackson, S.J, Niu, Y., Manoorkar, S., Mostaghimi, P. and Armstrong, R.T. 2021. Deep learning of multi-resolution X-Ray micro-CT images for multi-scale modelling.

[2] Jackson, S.J., Lin, Q. and Krevor, S. 2020. Representative Elementary Volumes, Hysteresis, and Heterogeneity in Multiphase Flow from the Pore to Continuum Scale. Water Resources Research, 56(6), e2019WR026396

[3] Zahasky, C., Jackson, S.J., Lin, Q., and Krevor, S. 2020. Pore network model predictions of Darcy‐scale multiphase flow heterogeneity validated by experiments. Water Resources Research, 56(6), e e2019WR026708.



