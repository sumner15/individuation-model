function graphNetwork(P)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: Sumner Norman
% purpose: create a visual representation of the network structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% create graph
s = [(P.N+1)*ones(1,P.N) (P.N+2)*ones(1,P.N)];  %node list (to MN pool)
t = [1:P.N 1:P.N];                              %node list (from neuron)
w = [P.w(1,:) P.w(2,:)];                        %weighting

s(w==0) = [];
t(w==0) = [];
w(w==0) = [];

names = cell(1,P.N+2);
for i = 1:P.N
    names{i} = num2str(i);
end
names{P.N+1} = 'MN-1';
names{P.N+2} = 'MN-2';

G = graph(s,t,abs(w),names);

%% preparing graph properties for plotting
LWidths = 10*G.Edges.Weight/max(G.Edges.Weight);

% prepare a path to recolor the inhibitory indices
inhibPath = []; 
for i = 1:length(w)
    if w(i)<0
        inhibPath = [inhibPath t(i) s(i) t(i)];
    end
end     

%% plot graph
h = plot(G);
h.LineWidth = LWidths;
h.EdgeAlpha = 0.6;
if P.strokeLat==1 %bilateral network
    h.XData = [1:P.N P.N/3 2*P.N/3];
    h.YData = [zeros(1,P.N)+50+2*randn(1,P.N) 0 0];
elseif P.strokeLat==2 
    h.XData = [1:P.N 1 P.N/8];
    h.YData = [zeros(1,P.N)+50+2*randn(1,P.N) 12 0];
end
h.NodeColor = 'k';
h.MarkerSize = 12;
highlight(h,1:P.N,'MarkerSize',3)

%highlighting inhibitory neurons
highlight(h,inhibPath,'EdgeColor','r')

%labeling MN pools
if P.task==1
    text(h.XData(end-1)+10,0,'MN Pool L','FontSize',16)
    text(h.XData(end)+10,0,'MN Pool R','FontSize',16)
elseif P.task==2
    text(h.XData(end-1)+10,-3,'index','FontSize',16)
    text(h.XData(end)+10,-3,'middle','FontSize',16)
end

%axes and labels
xlabel('neuron number')
axis([-1 401 -5 55])
ax = gca;
ax.YTick = ([]);
ax.XTick = ([1 100 200 300 400]);
set(gca,'XAxisLocation','top','FontSize',20)
legend('excit-blue, inhib-red','Location','Best')
end