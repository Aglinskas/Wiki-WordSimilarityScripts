function [red_dm,red_targLbls,futileKiller] = hc_truncateDenseMatrix...
    (dm,targLbls,showDeletedItems,maxclust,eliminateFunc,max_cluster_size,min_cluster_size)
% Calculate hier clustering using the dense matrix (dm,sample-by-feature) with maxclust
% Look for the 'best' clustering by removing samples, cluster sizes ar
% within the give range
% Specifically,
% Loop through each cluster
%    - Remove 'small' clusters (cluster_size < min_cluster_size)
%    - Reduce size of large clusters (cluster_size>max_cluster_size) by 
% removing the samples with the lowest silhouette scores, with specific
% subfunctions:
%  {'negSil'(default) | 'clustersize' | 'elementwise'}
% Return the resulting reduced dense matrix, the remainng target lables,
% and a futileKiller flag (==1 if killer is empty, i.e. no one get killed)
if nargin < 5
    eliminateFunc = 'negSil';
elseif nargin == 4
    max_cluster_size = 0;min_cluster_size = 0;
    eliminateFunc = 'negSil';
elseif nargin == 3
    max_cluster_size = 0;min_cluster_size = 0;
    eliminateFunc = 'negSil';
    maxclust = 20;
elseif nargin == 2
    max_cluster_size = 0;min_cluster_size = 0;
    eliminateFunc = 'negSil';
    maxclust = 20;
    showDeletedItems = 0; %not print the details by default
end
Y = pdist(dm,'correlation');
Z = linkage(Y,'ward');
T = cluster(Z,'maxclust',maxclust);
S = silhouette(dm,T,'correlation');
% [S H] = sihouette(dm,T,'correlation');
%dendrogram(Z);
futileKiller = 0;
if strcmp(eliminateFunc, 'elementwise')
    killer = elementwiseRemove(T,S,min_cluster_size,max_cluster_size,showDeletedItems);
elseif strcmp(eliminateFunc, 'clustersize')
    killer = clustersizeRemove(T,S,min_cluster_size,max_cluster_size,showDeletedItems);
elseif strcmp(eliminateFunc, 'negSil')
    killer = negativeSilhouetteRemove(T,S);
end %disp(killer);
if isempty(killer)
%     fprintf('No items removed\n');
    futileKiller = 1; %IT IS FUTILE 
end
red_dm = dm(setdiff(1:1:size(dm,1),killer),:);
red_targLbls = targLbls(setdiff(1:1:size(dm,1),killer));

end % END FUNC


function killer = elementwiseRemove(T,goodnessScore,min_cluster_size,max_cluster_size,showDeletedItems)
%% Remove the worst element based on the given goodness scores (len=n_samples)
killer = []; % THINGS INSIDE WILL BE KILLED
for iCluster = 1:max(T)
    % FOR EACH CLUSTER
    ind = find(T==iCluster); % find index for items from this cluster
    %Get the 'goodness' of the cluster (TODO cophnet of branches)
    score_current_cluster = goodnessScore(ind);
    %overallSilWidth = mean(sil_current_cluster);
    % Discard small clusters or truncate large clusters
    if length(ind) < min_cluster_size; %SMALL CLUSTERS
        killer = [killer; ind];
        if showDeletedItems==1
            fprintf('Remove the small(%d) cluster %d\n',iCluster,length(ind));
        end
    elseif length(ind) > max_cluster_size %LARGE CLUSTERS
        % Remove ONE item that has the lowest silhouette score
        % until size = max_cluster_size
        [junk indG] = sort(score_current_cluster); %sort items within cluster
        % NB find the orignial index in the original matrix (rather than the index in the current cluster)
        indOrig = ind(indG(1));
        killer = [killer;indOrig];% remove worst items from cluster
        if showDeletedItems==1
            fprintf('Remove the %d-th item in cluster %d\n',indOrig,iCluster);
        end
%       else
%         fprintf('Cluster %d has %d items\n',iCluster,length(ind));
    end
end % END ALL CLUSTERS
end

function killer = negativeSilhouetteRemove(T,sil_scores)
%% truncate the matrix by removing samplew with negative silhouette scores
% 1.Discard clusters with size < min_cluster_size
% 2.For other clusters, remove samples with neg silhouette, 
killer = [];
for iCluster = 1:max(T)
    ind = find(T==iCluster); %
    score_current_cluster = sil_scores(ind);
    fprintf('%d Cluster (size=%d) Sil score=%f\n',iCluster,length(ind),mean(score_current_cluster));
    if (mean(score_current_cluster)<0)
        fprintf('Remove this cluster\n');
        killer = [killer; ind];
    end
end % END ALL CLUSTERS
end

function killer = clustersizeRemove(T,goodnessScore,min_cluster_size,max_cluster_size,showDeletedItems)
%% truncate the matrix accoring to cluster size
% Discard clusters with size < min_cluster_size and eliminate 'bad' samples
% in clusters > max_cluster_size based on the worst elementS based on
% the given goodness scores (len=n_samples)

killer = []; % THINGS INSIDE WILL BE KILLED
for iCluster = 1:max(T)
    % FOR EACH CLUSTER
    ind = find(T==iCluster); % find index for items from this cluster
    %Get the 'goodness' of the cluster (TODO cophnet of branches)
    score_current_cluster = goodnessScore(ind);
    %overallSilWidth = mean(sil_current_cluster);
    % Discard small clusters or truncate large clusters
    if length(ind) < min_cluster_size; %SMALL CLUSTERS
        killer = [killer; ind];
        if showDeletedItems==1
            fprintf('Remove the small(%d) cluster %d\n',iCluster,length(ind));
        end
    elseif length(ind) > max_cluster_size %LARGE CLUSTERS
        % Remove x items that have the lowest silhouette scores
        % leaving max_cluster_size items
        [junk indG] = sort(score_current_cluster); %sort items within cluster
        x = length(indG) - max_cluster_size;
        
        % NB find the orignial index in the original matrix (rather than the index in the current cluster)
        indOrig = ind(indG(1:x));
        killer = [killer; indOrig];% remove worst items from cluster
        if showDeletedItems==1
            fprintf('Remove %d items in cluster %d\n',x,iCluster);
        end
    end
end % END ALL CLUSTERS
end
