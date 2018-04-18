%% Load back data
load('DataMatrices/reducedDM_selTargNoun_fromTopVerbs-18-Mar-2016.mat')

fname = 'DataMatrices/selTargNoun_fromTopVerbs-18-Mar-2016';
fid = fopen(fname,'r');
strings = textscan(fid,'%s');
fclose(fid);
sel_targWords = strings{1};

fname = 'DataMatrices/selTopVerbs400-18-Mar-2016';
fid = fopen(fname,'r');
strings = textscan(fid,'%s');
fclose(fid);
sel_dimWords = strings{1};

% Visualise
hc_plotDM(dm_red,sel_targWords);
 % Check cluster members
rs_clustering = {};
for ic = 1:n_clusters
    words = lower(plotlbls(find(T==ic)));
    rs_clustering{ic} = words;
    fprintf('\n%u Cluster with %u items\n',ic,length(words));
    for iw = 1:length(words)
        fprintf([words{iw} ' ']);
    end
end

%% 'Improve' clustering
for iter = 1:n_iteration
    [dm_red2, sel_targWords2] = hc_truncateDenseMatrix(dm_red,sel_targWords,n_clusters,'negSil');

[dm_red2, sel_targWords2] = hc_truncateDenseMatrix(dm_red,sel_targWords,n_clusters,'negSil');
hc_plotDM(dm_red2,sel_targWords2)

% Base on clustersize
[dm_red3, sel_targWords3] = hc_truncateDenseMatrix(dm_red2,n_clusters,...
    min_cluster_size,max_cluster_size,sel_targWords2,'clustersize');
hc_plotDM(dm_red3,sel_targWords3)

%
[dm_red4, sel_targWords4] = hc_truncateDenseMatrix...
    (dm_red3,sel_targWords3,30,'negSil');

%% checking
current_dm_red = dm_red4; %THE REDUCED MATRIX OF THE CURRENT RECURSION
currentlbls = sel_targWords4;

disp(size(current_dm_red));
Z = linkage(current_dm_red, 'ward','correlation');
T = cluster(Z,'cutoff',1.4,'criterion','distance');%'maxclust',n);
n_clusters = max(T)
S = silhouette(current_dm_red,T,'correlation');
% max_cluster_size = 15;
% min_cluster_size = 5;

for iCluster = 1:n_clusters
    ind = find(T==iCluster); %
    score_current_cluster = S(ind);
    fprintf('%d Cluster (%d) %f\n',iCluster,length(ind),mean(score_current_cluster));
end % END ALL CLUSTERS
% Check specific cluster
ic = 20;
ind = find(T==ic);
score_current_cluster = S(ind);
for i = 1:length(ind)
    fprintf('%s %f\n',currentlbls{ind(i)},score_current_cluster(i));
end
% Check cluster members
rs_clustering = {};
for ic = 1:n_clusters
    words = lower(currentlbls(find(T==ic)));
    rs_clustering{ic} = words;
    fprintf('\n%u Cluster with %u items\n',ic,length(words));
    for iw = 1:length(words)
        fprintf([words{iw} ' ']);
    end
end



