%% Mar 18 2016 Yuan. Modified from improveSil.m
%% March 23 : scott made some comments
% /Users/yuantao/Google Drive/WP2.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithm
% Give a specified number of selected clusters, 
% and a specified number of minumal items
% n = number of iteration of truncating the dense matrix, i.e. discarding
% samples
% For iteration = 1:n_iterations
%   Calculate hier clustering and silhouette scores
%   Truncate the matrix
%        i.e. if cluster_size < min_cluster_size: discard the cluster
%             else: remove the worst item of the cluster
%   reduced_dm = hc_truncateDenseMatrix(dm)
%   dm = reduced_dm
%           
% For each iteration, keep track of the new dm, the remaining/discared
% sample ids, the hier clustering results and the silhoutte scores
%                
% Parameters
% range_n_clusters % Numbers of clusters to use to truncate the dengrogram
% min_cluster_size (=1 to exclude outliers)
% range_max_cluster_size %aka minItems / itemPerCat
% range_n_iteratons %aka ieterationsPerLevel
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mar 22 2016. + Extra of looping through range of number of iterations,
% i.e. pre-define a range of iteration times and store results in one
% structure
% Mar 23 2016 IDENTICAL TO improveSil.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('off','stats:linkage:NotEuclideanMatrix');
warning('off','stats:linkage:NotEuclideanMethod')

clear all
%% 
load workingNouns
targWords = word;
dimWords = dm_verb;

%% 1. Load data
% matrixFolder = 'DataMatrices/';
% dimWordType = 'Adjs';
% creatingDate = '23-Mar-2016'
% savedmName = [matrixFolder 'reducedDM_selTargNoun_fromTop' dimWordType '-' creatingDate '.mat'];
% data = load(savedmName);
% fieldname = fieldnames(data);
% dm = data.(fieldname{1});
% %%%%%target words for rows and columns
% targWordFile = [matrixFolder 'selTargNoun_fromTop' dimWordType '-' creatingDate];
% fid = fopen(targWordFile,'r');
% targWords = textscan(fid,'%s');
% fclose(fid);
% targWords = targWords{1};
% %%%%%%%
% targWordFile = [matrixFolder 'selTop' dimWordType '400-' creatingDate];
% fid = fopen(targWordFile,'r');
% dimWords = textscan(fid,'%s');
% fclose(fid);
% dimWords = dimWords{1};

%% 2. Check the initial dengrogram, which can give a fair estimate of the
% natural clustering
Y = pdist(dm_verb,'correlation');
figure();imagesc(squareform(Y));colorbar();
Z = linkage(Y, 'ward');
% clustering all 
figure();
[H,T] = dendrogram(Z,size(dm_verb,1),'Labels',targWords,...
    'Orientation','left','ColorThreshold',1.4 );
title('COMPLETE')
hc_plotFlatClusters(dm_verb,targWords,31,1.4)
% E.G. Use a threshold
% woringNouns: 1.6:22 1.5:14, 1.4:31, 1.2:51
disThrs = 1.6;
T = cluster(Z,'cutoff',disThrs,'criterion','distance');
n_clusters = max(T)
% Then check the cluster sizes
sizes = [];
for ic = 1:n_clusters
    sizes(ic) = length(find(T==ic));
    fprintf('Cluster %d has %d items\n',ic,sizes(ic));
end
mean(sizes)
median(sizes)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Main loop
% SPECIFY A RANGE
close all;
range_n_clusters = [4 8 15];
% MAY CHANGE ACCORDING TO n_clusters
min_cluster_size = 1; %
range_max_cluster_size = [60,20,10 ];% [80 25 10 5]; % AKA minItems
% SET TO 1000 FOR ALL IF TERMINATE IF NO MORE SAMPLES GET REMOVED
range_n_iterations = [20 20 50  ];%linspace(1000,1000,length(range_n_clusters));% % AKA iterationsPerLevel

showDeletedItems = 0; %IF PRINT THE DETAILS OR NOT
clear loopDMs loopRemainedTargWords copScores silScores
inloopDM = dm_verb; %The same dense matrix going through the recursion
inloopTargWords = word;
for i_clusters = 1:length(range_n_clusters)
    n_clusters = range_n_clusters(i_clusters);
    n_iterations = range_n_iterations(i_clusters);
    max_cluster_size = range_max_cluster_size(i_clusters);
    fprintf('%d: Use %d maxclust with %d of times iteration;',i_clusters,n_clusters,n_iterations);
    fprintf('\nremove the worst item if cluster size > %d\n',max_cluster_size);
    try
       [loopDMs{i_clusters}, loopRemainedTargWords{i_clusters},...
        copScores{i_clusters}, silScores{i_clusters}] = ...
            hc_eliminateSamples_recursion(inloopDM, inloopTargWords, n_iterations,...
            n_clusters,max_cluster_size, min_cluster_size, showDeletedItems, 0);
        inloopDM = loopDMs{i_clusters}{length(loopDMs{i_clusters})}; %Use the last dm in next loop
        inloopTargWords = loopRemainedTargWords{i_clusters}{length(loopDMs{i_clusters})};
        fprintf('Final dm size %d %d\n',size(inloopDM));
    catch ME
        if strcmp(ME.identifier,'stats:linkage:TooFewDistances');
            fprintf('Iteration stopped at %d level with %d iteration times\n',i_iteration,n_iterations)
        else
            disp(ME.identifier);
        end
     end
end

%DATA STRUCTURE
% loopDMs{i}{j};%: reduced dense matrix using i-th choice of iterations and of the j-th iteration
% THUS the last dense matrix of i-th choice of range_n_iterations is
% loopDMs{i}{range_n_iterations(i)}
%The same for the others
% HOWEVER IF THE ITERATION TERMINATED EARLY, THE LAST MATRIX IS length(loopDMs{x})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = numel(loopDMs);
j = length(loopDMs{x});
loopDM = loopDMs{x}{j};
% disp(size(loopDM));
loopLbls = loopRemainedTargWords{x}{j};
%hc_plotDM(loopDM,loopLbls);

target_n_clusters = range_n_clusters(x);
sorted_tw = hc_plotFlatClusters(loopDM,loopLbls,target_n_clusters);
% RETURN THE ORDERED LABLES AS IN THE DENDROGRAM, CAN CHECK IT ROUGHLY,
% E.G.
disp(sorted_tw(1:10));
disp(sorted_tw(10:20));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check what the items are
Z = linkage(loopDM, 'ward','correlation');
T = cluster(Z,'maxclust',target_n_clusters);
% OR PLOT DENDROGRAM
% [H T sortedRowIds] = dendrogram(Z,size(loopDM,1),'Labels',loopLbls,'Orientation','left','ColorThreshold',1.);
for ic = 1:target_n_clusters
    words = lower(loopLbls(find(T==ic)));
    fprintf('\n%u Cluster with %u items\n',ic,length(words));
    for iw = 1:length(words)
       fprintf([words{iw} ' ']);
    end
end

% OR PRINT THE ORDERED LABLES AS IN THE DENDROGRAM
sorted_tw = wrev(sorted_tw);
for i = 1:length(sorted_tw)
    disp(sorted_tw{i});
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check silhouette
figure();
[S SH] = silhouette(loopDM,T,'correlation');

silCluster = {}; %The sil scores of items in each cluster
grandavgSil = [];
grandvarSil = [];
for iCluster = 1:range_n_clusters(x)
    silCluster{iCluster} = S(find(T==iCluster));
    grandavgSil(iCluster) = mean(silCluster{iCluster});
    grandvarSil(iCluster) = var(silCluster{iCluster});
    fprintf('Cluster %d has mean sil %f, var = %f \n',...
        iCluster,mean(silCluster{iCluster}),var(silCluster{iCluster}));
end
fprintf('Overall silhouette width = %f +/- %f\n',...
    mean(grandavgSil),std(grandavgSil));


