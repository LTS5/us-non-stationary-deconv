# Fast Non-stationary Deconvolution in Ultrasound Imaging
[Ecole Polytechnique Fédérale de Lausanne (EPFL)]: http://www.epfl.ch/
[Signal Processing Laboratory (LTS5)]: http://lts5www.epfl.ch
[Laboratoire de Communications Audiovisuelles (LCAV)]: http://lcav.epfl.ch/
[Cognitive Computing Department]: https://www.zurich.ibm.com/ics/
[IBM Research]: https://www.zurich.ibm.com/
[Institute of Sensors, Signals and Systems]: https://www.hw.ac.uk/schools/engineering-physical-sciences/institutes/sensors-signals-systems/basp.htm
[Heriot-Watt University]: https://www.hw.ac.uk/
[paper]: http://infoscience.epfl.ch/record/254887?&ln=fr
[PICMUS submodule]:https://bitbucket.org/picmus/picmus

Adrien Besson<sup>1</sup>, Lucien Roquette<sup>2</sup>, Dimitris Perdios<sup>1</sup>, Matthieu Simeoni<sup>2,3</sup>, Marcel Arditi<sup>1</sup>, Paul Hurley<sup>2</sup>, Yves Wiaux<sup>4</sup> and Jean-Philippe Thiran<sup>1,5</sup>

<sup>1</sup>[Signal Processing Laboratory (LTS5)], [Ecole Polytechnique Fédérale de Lausanne (EPFL)], Switzerland

<sup>2</sup>[Cognitive Computing Department], [IBM Research], Switzerland

<sup>3</sup>[Laboratoire de Communications Audiovisuelles (LCAV)], [Ecole Polytechnique Fédérale de Lausanne (EPFL)], Switzerland

<sup>4</sup>[Institute of Sensors, Signals and Systems], [Heriot-Watt University] , UK

<sup>5</sup>Department of Radiology, University Hospital Center (CHUV), Switzerland

Code used to reproduce the results presented in this [paper], submitted to IEEE Transactions on Computational Imaging

## Abstract
Pulse-echo ultrasound (US) aims at imaging tissue using an array of piezoelectric elements by transmitting short US pulses and receiving backscattered echoes. Conventional US imaging relies on delay-and-sum (DAS) beamforming which retrieves a radio-frequency (RF) image, a blurred estimate of the tissue reflectivity function (TRF).
To address the problem of the blur induced by the DAS, deconvolution techniques have been extensively studied as a post-processing tool for improving the resolution. Most approaches assume the blur to be spatially invariant, i.e. stationary, across the imaging domain. However, due to physical effects related to the propagation, the blur is non-stationary across the imaging domain.
In this work, we propose a continuous-domain formulation of a model which accounts for the diffraction effects related to the propagation. 
We define a PSF operator as a sequential application of the forward and adjoint operators associated with this model, under some specific assumptions that we precise.
Taking into account this sequential structure, we exploit efficient formulations of the operators in the discrete domain and provide a PSF operator which exhibits linear complexity with respect to the grid size.
We use the proposed model in a maximum-a-posteriori estimation algorithm, with a generalized Gaussian distribution prior for the TRF. Through simulations and in vivo experimental data, we demonstrate its superiority against state-of-the-art deconvolution methods based on a stationary PSF.

## Requirements
  * MATLAB (code tested on MATLAB R2017a) 
  * git
  * 20 GB of RAM to store the matrices

## Installation
Clone the repository (``--recursive`` is used to download the [PICMUS submodule] when cloning the repo) using the following command:
```bash
git clone --recursive https://github.com/LTS5/us-non-stationary-deconv.git
```
## Usage
1. `display_experiments.m` reproduces Figures and Tables displayed in the paper 
1. `main_deconvolution.m` allows you to launch the lp-deconvolution algorithm to reconstruct images
        
## Contact
 Adrien Besson (adrien.besson@epfl.ch)
 
## License
[License](LICENSE.txt) for non-commercial use of the software. Please cite the following [paper] when using the code.
