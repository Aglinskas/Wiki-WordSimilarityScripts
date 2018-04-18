function [sortedRowIds sorted_tw] = hc_plotFlatClusters(plotdm,plotlbls,dendroThrs,...
    hcMetric,hcMethod)
    % Plot the dendrogram and the similarity matrix sorted as the flat clusters
    % BY DEFAULT hcMetric = 'correlation';hcMethod = 'ward';
    % Return lables as sorted by dendrogram and the corresponding sorted labels
    if nargin == 3
        hcMetric = 'correlation';hcMethod = 'ward';
    elseif nargin == 4
        hcMethod = 'ward';
    end
    
    Z = linkage(plotdm, hcMethod, hcMetric);
    figure();[H T sortedRowIds] = dendrogram(Z,size(plotdm,1),'Labels',...
            plotlbls,'Orientation','left','ColorThreshold',dendroThrs);
    sortedRowIds = wrev(sortedRowIds);
    sorted_dm = plotdm(sortedRowIds,:);
    sorted_tw = plotlbls(sortedRowIds);
    SM = corr(sorted_dm');
    SM(1:size(SM,1)+1:end) = 0;
    figure();imagesc(SM);colorbar();
    set(gca,'YTick',1:length(sorted_tw));
    set(gca,'YTickLabel',sorted_tw); 
    
end