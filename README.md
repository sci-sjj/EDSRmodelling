EDSR modelling
=====
A Github repository for deep-learning image enhancement, pore-network and continuum modelling from X-Ray Micro-CT images

![3D drainage simulation in heterogeneous core](media/workflow.png)
*Summary of the workflow, flowing from left to right. First, the EDSR network is \textit{trained \& tested} on paired LR and HR data to produce SR data which emulates the HR data. Second, the trained EDSR is \textit{applied} to the whole core LR data to generate a whole core SR image. A pore-network model (PNM) is then used to generate 3D continuum properties at REV scale from the post-processed image. Finally, the 3D digital model is \textit{validated} through continuum modelling (CM) of the muiltiphase flow experiments.*
