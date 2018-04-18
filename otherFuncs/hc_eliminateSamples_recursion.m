function [denseMatrices, remainedTargWords, copScores, silScores] = hc_eliminateSamples_recursion(dm, targWords, n_iterations,...
    n_clusters,eliminateFunc,max_cluster_size, min_cluster_size, showDeletedItems,plotSil)
% Recursively eliminate the worst sample of the given dense matrix using
% hc_truncateDenseMatrix
% Return:
% For each iteration
%   the reduced dense matrix and the remaining sample labels, as well
%   as the cophenet scores and silhouette scores
if nargin < 7
    showDeletedItems = 0;
end
if nargin < 8
    plotSil = 0;
end
for iter = 1:n_iterations
    if showDeletedItems == 1
        fprintf('Iter %d\n',iter);
    end
    Yiter = pdist(dm,'correlation');
    Ziter = linkage(Yiter,'ward');
    copScores(iter) = cophenet(Ziter,Yiter); %A SINGLE SCORE OF EVERY DENDROGRAM
    Titer = cluster(Ziter,'maxclust',n_clusters);
    if plotSil==0
        Siter = silhouette(dm,Titer,'correlation');
    else% or plot the sil figure
        figure();title(iter);[Siter SHiter] = silhouette(dm,Titer,'correlation');
    end
    silScores{iter} = Siter;
    [dm, targWords, futileKiller] = hc_truncateDenseMatrix...
        (dm, targWords, showDeletedItems, n_clusters, eliminateFunc, max_cluster_size, min_cluster_size);
    %disp('end truncate');disp(futileKiller);
    if futileKiller == 1
        % A FLAG THAT INDICATES IF ANYONE GET KILLED, ==1 MEANS IT IS EMPTY
        % Thus break the loop
        fprintf('ITERATION TERMINATE AT ITER %d\n',iter);
        denseMatrices{iter} = dm;
        remainedTargWords{iter} = targWords;
        return
    end
    denseMatrices{iter} = dm;
    remainedTargWords{iter} = targWords;
end % END ITER
end