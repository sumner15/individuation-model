function plotResults()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: Sumner Norman
% function plotResults()
%
% Plots the network results
% 
% inputs:
% N/A
% 
% outputs: 
% N/A
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load data and set common vars
load modelData.mat
day = 1:P.nDays;
dayAfter = P.nDays+1:P.nDays*2;

%% plot network structure 
if P.task==1
    set(figure,'Position',[600 140 1400 1100])
elseif P.task==2
    set(figure,'Position',[600 140 700 1100])
end
subplot(3,2,1:4)
graphNetwork(P);

subplot(3,2,5:6)
allWeights = [P.w(1,:) P.w(2,:)];
excitatory = allWeights(allWeights>0);
inhibitory = allWeights(allWeights<0);
histogram(excitatory);
hold on
histogram(inhibitory)
legend({'excitatory','inhibitory'},'FontSize',16)
xlabel('synaptic weighting','FontSize',20)
ylabel('number of neurons','FontSize',20)
title('excitatory/inhibitory neuron DF','FontSize',24)
grid on

%% plot simple force before/after stroke

%fit for healthy
fitF1H = f1H/max(f1H)*100;
inds1 = fitF1H<55;
inds2 = fitF1H>55;
mdlh1 = fitlm(fitF1H(inds1),indivH(inds1));
mdlh2 = fitlm(fitF1H(inds2),indivH(inds2));
% fit for stroke
mdl = fitlm(f1,indiv);

set(figure,'Position',[600 540 1000 400])
subplot(121)
plot(day,f1H/max([f1H f2H])*100,'r','linewidth',4)
hold on
plot(day,f2H/max([f1H f2H])*100,'b','linewidth',4)
plot([day(end) dayAfter(1)],[1 f2H(end)]*100,'-.k','linewidth',4)
plot(dayAfter,f1/max([f1H f2H])*100,'-.r','linewidth',4)
plot(dayAfter,f2/max([f1H f2H])*100,'-.b','linewidth',4)
grid on
ax = gca;
ax.XTick = ([100 P.nDays 500]);
ax.XTickLabel = {'100','stroke','500'};
axis([0 P.nDays*2 0 105])
xlabel('day'); ylabel('force (% of max)')     

subplot(122)
plot(day,indivH,'k','linewidth',4)
hold on
plot(dayAfter,indiv,'-.k','linewidth',4)
plot([day(end) dayAfter(1)],[indivH(end) indiv(1)],'k','linewidth',4)
grid on
ax = gca;
ax.XTick = ([100 P.nDays 500]);
ax.XTickLabel = {'100','stroke','500'};
xlabel('day','fontsize',20)
ylabel('individuation','fontsize',20)

% set fonts and legends
set(findall(gcf,'-property','FontSize'),'FontSize',20)
subplot(121)
if P.task==1
    legend({'injured limb','uninjured limb','stroke'},...
        'FontSize',12,'Location','Southwest')
elseif P.task==2
    legend({'index','middle'},...
        'FontSize',12,'Location','Southwest')
end
subplot(122)
legend({'before stroke','after stroke'},'FontSize',12)

%% plot force, individuation, force/individuation
set(figure,'Position',[600 540 1400 400])    

subplot(131)
plot(day,f1*100,day,f2*100)
xlim([0 P.nDays])
xlabel('run'); ylabel('force (% of max)')        
hold on

yyaxis right
plot(day,P.dosage,'linewidth',0.5)
ylabel('attempts/run')
ax = gca;
ax.YTick = ([0 round(max(P.dosage),-1)]);
ylim([0 max(P.dosage)*1.1])

subplot(132)
plot(day,indiv)
grid on
xlabel('run'); ylabel('individuation index')
absymax = min(max(abs(indiv))*1.1,1);
axis([0 P.nDays -absymax absymax])

subplot(133)
plot(f1*100,indiv,'o')
xlabel('Force (% of max possible)');
ylabel('Individuation Index');

set(findall(gcf,'-property','FontSize'),'FontSize',20)
if P.task==1
    subplot(131); legend({'impaired arm','unimpaired arm'},...
        'FontSize',12,'Location','Southeast')
elseif P.task==2
    subplot(131); legend({'index','middle'},...
        'FontSize',12,'Location','Southeast')
end

if mdl.Rsquared.Ordinary > 0.85
    subplot(133); 
    plot(f1*100,indiv,'o',f1*100,mdl.Fitted,'-r')
    legend({'model data',...
        ['fitted (r^2=' num2str(mdl.Rsquared.Ordinary) ')']},...
        'FontSize',10,'Location','Best')
end
