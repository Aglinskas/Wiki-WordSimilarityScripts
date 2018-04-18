function hc_plotDM(plotdm,plotlbls,n_clusters,dendroThrs,hcMetric,hcMethod)
    % Plot the dendrogram and sorted similarity matrix of the dense matrix
    % If dendroThrs is empty, skip plotting the dendrogram
    if nargin == 4
        hcMetric = 'correlation';hcMethod = 'ward';
    elseif nargin == 5
        hcMethod = 'ward';
    end
    Z = linkage(plotdm, hcMethod, hcMetric);
    %T = cluster(Z,'cutoff',dendroThrs,'criterion','distance');
    %n_clusters = max(T); % May use the hier clustering result
    T = cluster(Z,'maxclust',n_clusters);
    if ~isempty(dendroThrs)
        figure();dendrogram(Z,size(plotdm,1),'Labels',plotlbls,...
    'Orientation','left','ColorThreshold',dendroThrs);
    end

    % PLOT Sorted similarity matrix
    count = 1;sortedRowIds = [];
    for ic = 1:n_clusters
        row_id = find(T==ic);
        sortedRowIds = [sortedRowIds row_id'];
        count = count+length(row_id);
    end
    %
    sorted_dm = plotdm(sortedRowIds,:);
    sorted_tw = plotlbls(sortedRowIds);
    SM = corr(sorted_dm');
    figure();imagesc(SM);
    set(gca,'YTick',1:length(sorted_tw));
    set(gca,'YTickLabel',sorted_tw);
end
