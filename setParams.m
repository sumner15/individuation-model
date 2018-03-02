function [w,ssd] = setParams(N,focality,stroke,strokeLat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: Sumner Norman
% function [w,ssd] = setParams(N,focality,stroke,strokeLat)
% 
% inputs:
% N - number of neurons
% focality - how focal the uninjured network is
% stroke - severity of stroke (0 to 1)
% strokeLat - laterality of the stroke (unilateral or bilateral) 
% 
% 
% outputs: 
% w - weighting i x j matrix of i motoneuronal pools and j neurons
% ssd - variability of 1 x j matrix of j neurons
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% neuron weightings: WEIGHTING (w) = log normal dist. of (mean,var,N)
w(1,:) = abs(0.5*randn(1,N)+1.2);
w(2,:) = abs(0.5*randn(1,N)+1.2);
% w(1,:) = randn(1,N)+1.2;
% w(2,:) = randn(1,N)+1.2;

% setting up unimpaired network 
nFocalInds = round(focality*N/2);
focalIndsF1 = 1:nFocalInds;
focalIndsF2 = N-nFocalInds:N;
w(1,focalIndsF1) = 0;
w(2,focalIndsF2) = 0;

% inhibitory neurons
nInh = ceil(nFocalInds/100);
inhIndsF1 = focalIndsF1(nFocalInds-nInh:nFocalInds);
inhIndsF2 = focalIndsF2(1:nInh);
w(2,inhIndsF1) = -1 * w(2,inhIndsF1);
w(1,inhIndsF2) = -1 * w(1,inhIndsF2);    

% creating stroke (how many of the focal neurons are knocked out)
nStrokeInds = round(stroke*focality*N/2);
if strokeLat==1
    strokeIndsF1 = N-nStrokeInds:N;
    w(1,strokeIndsF1) = 0;
elseif strokeLat==2
    strokeIndsF1 = N-nStrokeInds:N;
    w(1,strokeIndsF1) = 0;
    strokeIndsF2 = 1:nStrokeInds;
    w(2,strokeIndsF2) = 0;
elseif nStrokeInds == 0
else
    warning('stroke laterality must be 1 or 2; simulating healthy...')
end

% stochastic standard deviation (fast/slow circuits)
ssd = 0.2*randn(1,N)+1;
% ssd = abs(0.2*randn(1,N)+2);