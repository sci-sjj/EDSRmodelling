EDSR modelling
=====
A Github repository for deep-learning image enhancement, pore-network and continuum modelling from X-Ray Micro-CT images. The repository contains all code necessary to recreate the results in the paper [1]. The images that are used in various parts of the code are found on Zenodo, at DOI: 10.5281/zenodo.5542624. There is previous experimental and modelling work performed in the papers of [2,3]. 


![Workflow](media/workflow.png)
*Summary of the workflow, flowing from left to right. First, the EDSR network is trained \& tested on paired LR and HR data to produce SR data which emulates the HR data. Second, the trained EDSR is applied to the whole core LR data to generate a whole core SR image. A pore-network model (PNM) is then used to generate 3D continuum properties at REV scale from the post-processed image. Finally, the 3D digital model is validated through continuum modelling (CM) of the muiltiphase flow experiments.*

The workflow image above summarises the general approach. We summarise the files and folders below. Each matlab .m file contains a detailed description of the program usage, and dependencies. The files are ordered numerically in their intended usage. The codes below operate on the low resolution (LR), high resolution (HR) and super-resolution (SR) images. These can be downloaded at the Zenodo repository above. The SR image was created using the LR data and the EDSR deep learning model, contained in the folder 'EDSR'. There are specific usage instructions as well as a Jupyter notebook therein detailing how the network was trained, and tested. Once these raw images have been created, the following files can be run:

Files
=====
1. A0_0_0_Generate_LR_bicubic.m. This code generates Cubic interpolation images from LR images, artifically decreasing the pixel size and interpolating. 
2. A0_0_1_Generate_filtered_images_LR_HR.m. This code performs non-local means filtering of the LR, cubic and HR images, given the settings in the paper.
3. A0_0_2_Generate_histogram_data.m. This code generates histograms of the image grey scale values for comparison.
4. A0_0_3_Generate_SSIM_2D_3D.m. This code generates structural similarity index measures between the Cubic, HR and SR images.
5. A0_0_4_Generate_run_PNM_LR_Cubic_HR_SR_subvolumes.m. This generates the pore-network model (PNM) of the 4 subvolume images from Core 1 and Core 2. It generates multiple networks across different segmentation realizations for the LR, Cubic, HR and SR images. 
6. A0_0_5_Plot_EDSR_loss.m
7. A0_1_0_Plot_raw_filtered_images_2D.m
8. A0_1_1_Plot_histograms.m
9. A0_1_2_Plot_filtered_image_similarities.m
10. A0_1_3_Plot_PNM_LR_HR_EDSR_sensitivity.m
11. A1_0_0_Generate_run_PNM_whole_core.m
12. A1_0_1_Compile_whole_core_PNM.m
13. A1_0_2_Plot_whole_core_PNM.m
14. A1_1_0_Generate_run_IMEX_continuum_model_core_1.m
15. A1_1_1_Generate_run_IMEX_continuum_model_core_2.m
16. A1_1_2_Plot_IMEX_continuum_results.m
17. CMG_IMEX_files
18. Whole_core_results_exp_sim.xlsx

Folders
=====
1. Continuum_modelling_results
2. EDSR_training_results
3. Exp_data
4. Functions
5. Matlab_results
6. PNM_whole_core_LR_EDSR_results
7. media

References
=====
[1] Jackson, S.J, Niu, Y., Manoorkar, S., Mostaghimi, P. and Armstrong, R.T. 2021. Deep learning of multi-resolution X-Ray micro-CT images for multi-scale modelling.

[2] Jackson, S.J., Lin, Q. and Krevor, S. 2020. Representative Elementary Volumes, Hysteresis, and Heterogeneity in Multiphase Flow from the Pore to Continuum Scale. Water Resources Research, 56(6), e2019WR026396

[3] Zahasky, C., Jackson, S.J., Lin, Q., and Krevor, S. 2020. Pore network model predictions of Darcy‐scale multiphase flow heterogeneity validated by experiments. Water Resources Research, 56(6), e e2019WR026708.



