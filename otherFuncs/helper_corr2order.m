function [betterdm betterlbls] = helper_corr2order(dm,lbls,T)   
    betterdm = []; betterlbls = [];
    uniqueLbl = unique(T);
    for ic = 1:length(uniqueLbl)
        lbl = uniqueLbl(ic);
        clusterInd = find(T==lbl);
        
        tdm = dm(clusterInd,:);
        corrcoef2 = corr(corr(tdm'));
        %figure();imagesc(corrcoef2);
        subcorr = sum(corrcoef2);%figure();plot(subcorr);
        thrs = prctile(subcorr,50)
        ind = subcorr>thrs;
        sub_tdm = tdm(ind,:);
        if ~isempty(lbls)
            words = lbls(find(T==lbl));
            sub_lbls = words(ind);
            try
                betterlbls = [betterlbls;sub_lbls];
            catch
                betterlbls = [betterlbls,sub_lbls];
            end
        else
            betterlbls=[];
        end
        betterdm = [betterdm;sub_tdm];
    end
end