%%  load data
matrixFolder = 'DataMatrices/';
dimWordType = 'Verbs';
creatingDate = '30-Mar-2016'
savedmName = [matrixFolder 'reducedDM_selTargNoun_fromTop' dimWordType '-' creatingDate '.mat'];
data = load(savedmName);
fieldname = fieldnames(data);
dm_orig = data.(fieldname{1});

dimWords = data.sel_dimWords;
targWords = data.sel_targWords;

% CHECK SIMILARITY MATRIX ETC.
corr1 = corr(dm_orig');
% 2nd order SM
corr2 = corr(corr1);
figure();imagesc(corr1);colorbar();
figure();imagesc(corr2);colorbar();


%% Section 2 Title
% Description of second code block
km = kmeans(dm_orig,2,'Distance','correlation');
[betterdm betterlbls] = hc_corr2order(dm_orig,targWords,km);
figure;imagesc(corrcoef(betterdm'));title('dm_orig-red');

dm = betterdm;
km = kmeans(dm,4,'Distance','correlation');

[sorted_dm sortedRowIds] = hc_plotSortedSM(dm,[],km);title('dm1');

[betterdm betterlbls] = hc_corr2order(dm,betterlbls,km);
figure;imagesc(corrcoef(betterdm'));;title('dm1-red');

set(gca,'YTick',1:size(betterdm,1));
set(gca,'YTickLabel',betterlbls);

for ic = 1:max(km)
    clusterInd = find(T==ic);
    cluster_size{ic} = length(clusterInd);
    words{ic} = targWords(clusterInd);
    tdm = dm_orig(clusterInd,:);
    corrcoef2 = corr(corr(tdm'));
    
    subcorr = sum(corrcoef2);%figure();plot(subcorr);
    thrs = mean(subcorr);%prctile(subcorr,percentage)
    ind = subcorr>thrs;
    sub_tdm = tdm(ind,:);
    sub_lbls = words(ind);
    betterdm = [betterdm;sub_tdm];
    betterlbls = [betterlbls,sub_lbls];
end
    
    
corr1 = corr(sorted_dm');
corr2 = corr(corr1);
figure();imagesc(corr2);colorbar();title('2ND ORDER SM');

%Select the one with the most within-cluster corr using corr2
% 2nd order correlation scores of samples in each cluster
corr2_c1 = corr2(1:cluster_size{1},1:cluster_size{1});
corr2_c2 = corr2(cluster_size{1}:end,cluster_size{1}:end);
figure();hist(corr2_c1,50);title('CLUSTER 1');
figure();hist(corr2_c2,50);title('CLUSTER 2');

prctile(helper_flattenSM(corr2_c1),75)
prctile(helper_flattenSM(corr2_c2),75)

ind = corr2_c1 > prctile(corr2_c1,75);
subplotdm = plotdm(ind,:);
figure();imagesc(corr(sub_plotdm'));
figure();imagesc(corr(corr(sub_plotdm')));
plotleaves(ind)
% [s h] = silhouette(plotdm,clusterLbl);
betterdm{idleaf} = sub_plotdm;