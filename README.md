# A Physical Model of Non-stationary Blur in Ultrasound Imaging
[Ecole Polytechnique Fédérale de Lausanne (EPFL)]: http://www.epfl.ch/
[Signal Processing Laboratory (LTS5)]: http://lts5www.epfl.ch
[Laboratoire de Communications Audiovisuelles (LCAV)]: http://lcav.epfl.ch/
[Cognitive Computing Department]: https://www.zurich.ibm.com/ics/
[IBM Research]: https://www.zurich.ibm.com/
[Institute of Sensors, Signals and Systems]: https://www.hw.ac.uk/schools/engineering-physical-sciences/institutes/sensors-signals-systems/basp.htm
[Heriot-Watt University]: https://www.hw.ac.uk/
[paper]: https://infoscience.epfl.ch/record/254887?&ln=en
[PICMUS submodule]:https://bitbucket.org/picmus/picmus

Adrien Besson<sup>1</sup>, Lucien Roquette<sup>2</sup>, Dimitris Perdios<sup>1</sup>, Matthieu Simeoni<sup>2,3</sup>, Marcel Arditi<sup>1</sup>, Paul Hurley<sup>2</sup>, Yves Wiaux<sup>4</sup> and Jean-Philippe Thiran<sup>1,5</sup>

<sup>1</sup>[Signal Processing Laboratory (LTS5)], [Ecole Polytechnique Fédérale de Lausanne (EPFL)], Switzerland

<sup>2</sup>[Cognitive Computing Department], [IBM Research], Switzerland

<sup>3</sup>[Laboratoire de Communications Audiovisuelles (LCAV)], [Ecole Polytechnique Fédérale de Lausanne (EPFL)], Switzerland

<sup>4</sup>[Institute of Sensors, Signals and Systems], [Heriot-Watt University] , UK

<sup>5</sup>Department of Radiology, University Hospital Center (CHUV), Switzerland

Code used to reproduce the results presented in this [paper], submitted to IEEE Transactions on Computational Imaging

## Abstract
Conventional ultrasound (US) imaging relies on delay-and-sum (DAS) beamforming which retrieves a radio-
frequency (RF) image, a blurred estimate of the tissue reflectivity function (TRF). Despite the non-stationarity of the blur induced by propagation effects, most state-of-the-art US restoration approaches exploit shift-invariant models and are inaccurate in realistic situations. Recent techniques approximate the shift- variant blur using sectional methods resulting in improved accuracy. But such methods assume shift-invariance of the blur in the lateral dimension which is not valid in many US imaging configurations. In this work, we propose a physical model of the non-stationary blur, which accounts for the diffraction effects related to the propagation. We show that its evaluation results in the sequential application of a forward and an adjoint propagation operators under some specific assumptions that we define. Taking into account this sequential structure, we exploit efficient formulations of the operators in the discrete domain and provide an evaluation strategy which exhibits linear complexity with respect to the grid size. We also show that the proposed model can be interpreted in terms of common simplification strategies used to model non-stationary blur. Through simulations and *in vivo* experimental data, we demonstrate that using the proposed model in the context of maximum-a-posteriori image restoration results in higher image quality than using state-of-the-art shift-invariant models. The supporting code is available
on github: https://github.com/LTS5/us-non-stationary-deconv.

## Requirements
  * MATLAB (code tested on MATLAB R2017a)
  * git

## Installation
Clone the repository (``--recursive`` is used to download the [PICMUS submodule] when cloning the repo) using the following command:
```bash
git clone --recursive https://github.com/LTS5/us-non-stationary-deconv.git
```
## Usage
1. If you want to reproduce Figures displayed in the paper, use the script `display_experiments.m`
1. If you want to reproduce the experiments, run one of the following scripts
  * `bmode_pointreflector_pw_experiment.m` reproduces the results of the plane wave experiment with point reflectors (Section V.A)
  * `bmode_pointreflector_dw_experiment.m` reproduces the results of the plane wave experiment with point reflectors (Section V.A)
  * `bmode_picmus_experiment.m` reproduces the results of the experiment on the PICMUS phantom (Section V.B)
  * `bmode_carotid_experiment.m` reproduces the results of the experiment on the *in vivo* carotid (Section V.C)
  * `computational_complexity_experiment_1.m` reproduces the first experiment on evaluation time (Section V.D, Table VI)
  * `computational_complexity_experiment_2.m` reproduces the second experiment on evaluation time (Section V.D, Figure 9)

## Contact
 Adrien Besson (adrien.besson@epfl.ch)

## License
[License](LICENSE.txt) for non-commercial use of the software. Please cite the following [paper] when using the code.
