function [finger1,finger2,indiv,A,Xf] = simulateModel(P)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: Sumner Norman
% function [finger1,finger2,indiv,Xf] = simulateModel(P)
% 
% inputs:
% P, params - a parameter structure that must contain
% nDays, minRate, maxRate, w, X0, ssd, dosage, mode, alpha, task
% mode is feedback mode: 0 F-or-I | 1 F | 2 I | 3 amalgmation
% alpha is value function weighting: a(F)+(1-a)(I)
% 
% outputs: 
% finger1 - finger 1 force vector (1 x n, number of days)
% finger2 - finger 2 force vector
% indiv - individuation index vector
% Xf - final activation vector (neuron firing rates)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

finger1 = zeros(1,P.nDays);     % finger 1 force 
finger2 = zeros(1,P.nDays);     % finger 2 force
indiv = zeros(1,P.nDays);       % individuation measure each day
A = zeros(1,P.nDays);           % amalgamation measure each day

fprintf('Simulating ...')

%% initial force production & individuation

% max force possible with unimpaired arm
xMax = repmat(P.maxRate,1,P.N);
f1Max = mean(P.w(1,:).*xMax);
f2Max = mean(P.w(2,:).*xMax);

% initial force production
X0 = P.X0;
[finger1(1),finger2(1)] = getFinger(P.X0,P.w);
F0 = getTotal(P.X0,P.w);

% individuation 
I0 = getIndividuation(P.X0,P.w);
indiv(1) = I0;

% amalgamation of force and individuation measure
A0 = getA(P.X0,P.w,P.task);
A(1) = A0;

%% simulate
iMode = 1; % mode index iterator
for day = 2:P.nDays    
    % a number of trials for the given day
    for trial = 1:P.dosage(day)   
                
        % swap feedback modes
        feedback = P.mode(iMode);
        if iMode < length(P.mode)
            iMode = iMode+1;
        else 
            iMode = 1;
        end
        
        % add stochastic noise on every trial and calculate new activation 
        % vectors X and force vectors F        
        vi = randn(1,P.N);        %stochastic noise (normal distribution)
        Xi = X0+P.ssd.*vi;        %new firing rate 
        Xi = max(P.minRate,Xi);   %set saturation limits on x
        Xi = min(P.maxRate,Xi);   %set saturation limits on x       
        Ii = getIndividuation(Xi,P.w);  %get individuation
        Ai = getA(Xi,P.w,P.task); %get amalgamation of f&i for the task
        if P.task==1
            Fi = getTotal(Xi,P.w);    %get force
        elseif P.task==2
            [Fi,~] = getFinger(Xi,P.w);
        end
        
        % simulate force production and individuation (& best first update)
        if Ai>A0 && feedback==3
            update()
        end            
        if abs(Ii-0)<abs(I0-0) && feedback==2
            update()
        end
        if Fi>F0 && feedback==1
            update()           
        end     
        if ((abs(Ii-0)<abs(I0-0)) || (Fi>F0)) && feedback==0 && P.task==1
            update()
        end        
        if (Ii > I0 || Fi > F0) && feedback==0 && P.task==2
            update()
        end
    end
    
    % save force for the current day to the force vector       
    [finger1(day),finger2(day)] = getFinger(X0,P.w);
    indiv(day) = getIndividuation(X0,P.w);   
    A(day) = getA(X0,P.w,P.task);
end
Xf = X0;
fprintf('Done.\n');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [f1,f2] = getFinger(x,w)
    f1 = mean(w(1,:).*x)/f1Max;
    f2 = mean(w(2,:).*x)/f2Max;
    f1 = max(f1,0);
    f2 = max(f2,0);
end

function F = getTotal(x,w)
    [f1,f2] = getFinger(x,w);
    F =  mean([f1 f2]);
end

function indi = getIndividuation(x,w)
    [f1,f2] = getFinger(x,w);
    indi = (f1-f2)/(f1+f2);            
    if(isnan(indi))
        indi = -1;
    end
end

function A = getA(x,w,task)    
    if task==1
        F = getTotal(x,w);
        I = 1-abs(getIndividuation(x,w));    
    else
        [F,~] = getFinger(x,w);
        I = getIndividuation(x,w);
    end
    A = P.alpha*(F)+(1-P.alpha)*I;
end

function update()
    F0 = Fi;
    I0 = Ii;        
    A0 = Ai;
    X0 = Xi;
end
        

end