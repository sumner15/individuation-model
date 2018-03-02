%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: Sumner Norman
% purpose: A firing-rate neural network model of M1 and SMA before and
% after stroke. Here, we explore the roles of individuation and strength 
% resulting from two motoneruonal pools, rather than the single pool 
% explored in previous models. 
%
% model definition:
%
% FORCE
% F = SUM{g(w * x_i)} from i->N
%
% F = output force
% w_i = weighting for neuron i
% ssd_I = stochastic search standard deviation (neuron variability)
% x_i = neuron i firing rate 
% g = saturation nonlinearities where g_fi and g_ei have a positive
% saturation limit for excitatory cells, and a negative saturation
% limit for inhibitory cells, respectively.
%
% STOCHASTIC SEARCH
% during each simulated movement, each neuron firing rate is varied
% stochastically. 
% 
% NEURON VARIABILITY
% The amount of stochastic noise encountered by a specific neuron (ssd).
% A bimodal set of lognormal distributions are sampled for each set of
% neurons.
%
% SYNAPTIC WEIGHTING
% w is the synaptic weighting between the neuron and network output.
% A bimodal set of lognormal distributions are sampled for each set of
% neurons.
%
% LEARNING
% Best-first algorithm
% X_i = X_0 + v_i 
% v_i is random noise drawn from zero-mean normal distribution
% if F_i > F_0, then X_0=X_i and F_0=F_i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; clc; set(0,'defaultlinelinewidth',2.5)

%% set parameters here
P.task = 2;           % 1 wheelchair | 2 finger individuation
P.N = 200;            % number of neurons
P.maxRate = 100;      % max firing rate
P.minRate = 0;        % minimum firing rate (if not defined)
P.X0 = ones(1,P.N);   % initial firing pattern
P.nDays = 300;        % number of days to run the simulation
P.nSubs = 54;         % number of subjects for population testing
P.alpha = 0.5;        % ratio for value function | 0 indiv | 1 force
P.mode = 3;           % feedback type (can be a vector to cycle)
% 0 force OR indiv | 1 force  | 2 individuation | 3 value function

%% dependent parameters
P.strokeLat = 1;  % 1 - unilateral, 2 - bilateral
P.focal = 0.9;    % focality of the network
P.stroke = 0.4;   % level of stroke (0 to 1) 

%% set any simulation parameters and run
load dosage.mat

% test the healthy network
[P.w,P.ssd] = setParams(P.N,P.focal, 0 ,P.strokeLat);
P.dosage = ones(1,P.nDays)*200;  
[f1H,f2H,indivH,AH,~] = simulateModel(P);

% test the impaired network
[P.w,P.ssd] = setParams(P.N,P.focal,P.stroke,P.strokeLat);
P.dosage = acute(1:P.nDays);
[f1,f2,indiv,A,Xf] = simulateModel(P);

%% save results for later use and begin plotting
save('modelData');
plotResults()


