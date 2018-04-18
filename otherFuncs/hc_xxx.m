function [subdm, subwords] = hc_xxx(dm,words,max_n_leaves,plotFlags)
    %plot flags: flagDen,flagPlotINC,flagPlotSM,flagPlotSil,flagPrint
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
    
    [maxIncon, maxId] = max(truncatedIncon);
    if maxId==1
        truncatedIncon(maxId)=nan;
        [maxIncon, maxId] = max(truncatedIncon); 
    end
    disThrs = Z(length(I)-maxId+1,3);
    fprintf('Highest inconsistent score found at %d-th link %f\nWith distance %f',...
    maxId,maxIncon,disThrs);

    T_trunc = cluster(Z,'cutoff',disThrs,'criterion','distance');
    if plotFlags.flagPlotSM==1
        hc_plotSortedSM(dm,words,T_trunc);
    end
    if plotFlags.flagPlotSil==1
        figure();silhouette(dm,T_trunc);
    end
    
    for ic = 1:max(T_trunc)
        subwords{ic} = words(find(T_trunc==ic));
        fprintf('\n%u Cluster with %u items\n',ic,length(subwords{ic}));
        if plotFlags.flagPrint==1
        for iw = 1:length(subwords{ic})
            fprintf([subwords{ic}{iw} ' ']);
        end
        end
        subdm{ic} = dm(find(T_trunc==ic),:);
    end
end
    