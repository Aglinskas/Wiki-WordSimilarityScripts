function [subdm, subwords] = hc_yyy(dm,words,max_n_leaves,plotFlags)
    %plot flags: flagDen,flagPlotINC,flagPlotSM,flagPlotSil,flagPrint
    returnValue = struct('placeholder','Mary');
    Y = pdist(dm,'correlation');
    Z = linkage(Y,'ward');
    %fprintf('COP=%f\n',cophenet(Z,Y));
    I = inconsistent(Z);
    if plotFlags.flagDen==1
        figure();dendrogram(Z,max_n_leaves);
    end
    
    indLinks = length(I)-max_n_leaves+1:length(I);%index of the links in orig Z&I ecc
    truncatedIncon = wrev(I(indLinks,4));%Top-Down
    if plotFlags.flagPlotINC==1
        figure();plot(truncatedIncon,'r-*');title('INCONSISTENCY');xlabel('Links');
    end
     
    
    disThrs = Z(length(I),3)*.75;
    fprintf('Thrs distance %f',disThrs);
    
    T_trunc = 1:size(dm,1);
    
    while max(T_trunc) > max_n_leaves
        T_trunc = cluster(Z,'cutoff',disThrs,'criterion','distance');
        disThrs = disThrs*1.25;
    end
    
    if plotFlags.flagPlotSM==1
        hc_plotSortedSM(dm,words,T_trunc);
    end
    
    if plotFlags.flagPlotSil==1
        figure();[silScores,h] = silhouette(dm,T_trunc);
        %returnValue.silScores = silScores;
    end
    
    for ic = 1:max(T_trunc)
        if ~isempty(words)
            subwords{ic} = words(find(T_trunc==ic));
            fprintf('\n%u Cluster with %u items\n',ic,length(subwords{ic}));
        else
            subwords = [];
        end
        if plotFlags.flagPrint==1
        for iw = 1:length(subwords{ic})
            fprintf([subwords{ic}{iw} ' ']);
        end
        end
        subdm{ic} = dm(find(T_trunc==ic),:);
        fprintf('\nmean corr scores %f\n',mean(1-pdist(subdm{ic},'correlation')))
    end
end
    