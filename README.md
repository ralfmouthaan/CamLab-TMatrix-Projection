# CamLab-TMatrix-Projection

Scripts to perform calculations for projecting images through a scattering medium or multimode fibre.

First:
- Take the appropriate transmission matrix measurements using CamLab-TMatrix-Measure
- Calculate the transmission matrix using CamLab-TMatrix-Calculation
- Generate the desired target fields using the Target Generation scripts in CamLab-TMatrix-Imaging

These scripts implement various phase retrieval algorithms to generate a light field that, upon scrambling by a scattering medum or a multimode fibre, creates the desired output field. These algorithms need to take into account the constraints of the SLM.

The following algorithms have been implemented:
- Use of conjugate transmission matrix
- Use of inverse transmission matrix
- Direct Search
- Gerchberg Saxton algorithm
- Gerchberg Saxton algorithm with Tikhonov-regularised transmission matrix
- the Yang-Gu algorithm

Additionally, variants of the Yang-Gu algorithm have been implemented that allow output phase as well as the output amplitude to be controlled - this gives depth control and the ability to project 3D images. The results of this work will be published as a paper at some point.

To run, the scripts need to be in the same folder as a T-Matrix.mat file (as generated using CamLab-TMatrix-Calculation), and need to point to a folder containing target images. The results of this calculation can be displayed on the SLM using CamLab-TMatrix-Measure, and the PlotMeasuredResult.m script allows the result to be plotted.
