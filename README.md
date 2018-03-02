# README #

##Purpose

A firing-rate neural network model of M1 and SMA before and after stroke. We explore the roles of finger individuation and strength resulting from two motoneruonal pools.

Model is based on the model described in: [How do strength and coordination recovery interact after stroke? A computational model for informing robotic training](http://ieeexplore.ieee.org/abstract/document/8009243/)

## model definition:

### FORCE
F = SUM{g(w * x_i)} from i->N
F = output force
w_i = weighting for neuron i
ssd_I = stochastic search standard deviation (neuron variability)
x_i = neuron i firing rate 
g = saturation nonlinearities where g_fi and g_ei have a positive
saturation limit for excitatory cells, and a negative saturation
limit for inhibitory cells, respectively.

###STOCHASTIC SEARCH
during each simulated movement, each neuron firing rate is varied stochastically. 

###NEURON VARIABILITY
The amount of stochastic noise encountered by a specific neuron (ssd). A bimodal set of lognormal distributions are sampled for each set of neurons.

### SYNAPTIC WEIGHTING
w is the synaptic weighting between the neuron and network output. A bimodal set of lognormal distributions are sampled for each set of neurons.

### LEARNING
Best-first algorithm
X_i = X_0 + v_i 
v_i is random noise drawn from zero-mean normal distribution
if F_i > F_0, then X_0=X_i and F_0=F_i

### How do I get set up? ###

* Open MAIN.m and run. This repository should have no external dependencies

### Prerequisites

[MATLAB 2017a](https://www.mathworks.com/products/matlab.html) or later. Matlab 2016 may also work, but has not been tested.

## Authors

* **Sumner Norman** - *Original build* [GitHub](https://github.com/sumner15) | [bitbucket](https://bitbucket.org/sumner15/)
* **Firas Mawase** - 

Please feel free to add your name to this list!
