function [sorted_dm sortedRowIds] = hc_plotSortedSM(plotdm,plotlbls,T)
    % Plot the sorted similarity matrix of dm according the clustering
    % (label from 1 to N)
    % Return the sorted dense matrix and the corresponding row ids of the 1-N clusters 
    count = 1;sortedRowIds = [];
    for ic = 1:max(T)
        row_id = find(T==ic);
        sortedRowIds = [sortedRowIds row_id'];
        count = count+length(row_id);
    end
    %
    sorted_dm = plotdm(sortedRowIds,:);
    
    SM = corr(sorted_dm');
    figure();imagesc(SM);colorbar();
    if ~isempty(plotlbls)
        sorted_tw = plotlbls(sortedRowIds);
        set(gca,'YTick',1:length(sorted_tw));
        set(gca,'YTickLabel',sorted_tw); 
    end
end