# README #

note: This project is stale. Refer to previous models for full functionality. This project was effectively replaced by "gold" model, which simulates handedness, bias, and variance before and after neural knockout. That project is led by Sumner Norman, John Krakauer, and Jeff Goldsmith. The repo is not yet published. - SL Norman (Nov 2020)

## Purpose

A firing-rate neural network model of M1 and SMA before and after stroke. We explore the roles of finger individuation and strength resulting from two motoneruonal pools.

Model is based on the model described in: [How do strength and coordination recovery interact after stroke? A computational model for informing robotic training](http://ieeexplore.ieee.org/abstract/document/8009243/)

## How do I get set up? 

* Open MAIN.m and run. This repository should have no external dependencies

## Prerequisites

[MATLAB 2017a](https://www.mathworks.com/products/matlab.html) or later. Matlab 2016 may also work, but has not been tested.

## Authors

* **Sumner Norman, Caltech** - *Original build* [GitHub](https://github.com/sumner15) 
* **Firas Mawase, Johns Hopkins** - intended collaborator (did not materialize)

Please feel free to add your name to this list!

## Model Definition

### stochastic search
during each simulated movement, each neuron firing rate is varied stochastically. 

### neuron variability
The amount of stochastic noise encountered by a specific neuron (ssd). A bimodal set of lognormal distributions are sampled for each set of neurons.

### force output
'''
F = SUM{g(w * x_i)} from i->N
F = output force
w_i = weighting for neuron i
ssd_I = stochastic search standard deviation (neuron variability)
x_i = neuron i firing rate 
g = saturation nonlinearities where g_fi and g_ei have a positive
saturation limit for excitatory cells, and a negative saturation
limit for inhibitory cells, respectively.
'''

### learning
'''
Best-first algorithm
X_i = X_0 + v_i 
v_i is random noise drawn from zero-mean normal distribution
if F_i > F_0, then X_0=X_i and F_0=F_i
'''

### synaptic weightings
w is the synaptic weighting between the neuron and network output. A bimodal set of lognormal distributions are sampled for each set of neurons. For now, these are fixed. In the structural neuroplasticity version of the model (coming soon), these weights will update.


## Upcoming Changes to the Model

- [X] Clean repository down to core model
- [ ] Implement structural neuroplasticity (updated weightings)
- [ ] Implement multiple tasks, which can swap activation patterns instantaneously
- [ ] Split parameter structures into brain parameters and task parameters
- [ ] Add save-to-file functionality for initializing brain/task parameters structs
