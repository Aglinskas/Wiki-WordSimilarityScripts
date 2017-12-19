tic;load('/Users/aidasaglinskas/Desktop/wiki.mat');toc
%%
m = [];
%% RFX
wiki.dmCorr_avg = squeeze(mean(wiki.dmCorr,1))
m(end+1) = cost_function(wiki);
%% FFX
wiki.dmCorr_avg = corr(squeeze(mean(wiki.dm,1))');
m(end+1) = cost_function(wiki);
%% T
a = squeeze(nanmean(wiki.dm,1)) ./ squeeze(nanstd(wiki.dm,[],1));
wiki.dmCorr_avg = corr(a','rows','pairwise');
m(end+1) = cost_function(wiki);
%% Diff Algs FFX
m = [];
algs = {'euclidean' 'squaredeuclidean' 'seuclidean' 'cityblock' 'minkowski' 'chebychev' 'cosine' 'correlation' 'spearman' 'hamming' 'jaccard' };
for i = 1:length(algs)
clc;disp(i)
D = pdist(wiki.dm_avg,algs{i});
wiki.dmCorr_avg = squareform(D);
m(end+1) = cost_function(wiki);
end

bar(m)
xticklabels(algs)
xtickangle(45)
title({'Distance Metrix Performance' 'FFX'},'fontsize',20)
%% Diff Algs FFX
clc;m = [];
%algs = {'euclidean' 'squaredeuclidean' 'seuclidean' 'cityblock' 'minkowski' 'chebychev' 'cosine' 'correlation' 'spearman' 'hamming' 'jaccard' };
 algs = {'euclidean' 'correlation'}
for i = 1%:length(algs)
for j = 1:size(wiki.dm,1)
disp(sprintf('alg: %d/%d : %d/%d',i,length(algs),j,size(wiki.dm,1)))
D = pdist(squeeze(wiki.dm(j,:,:)),algs{i});
wiki.dmCorr(j,:,:) = squareform(D);
end
wiki.dmCorr_avg = squeeze(mean(wiki.dmCorr,1));
m(end+1) = cost_function(wiki);
end

bar(m)
xticklabels(algs)
xtickangle(45)
title({'Distance Metrix Performance' 'RFX'},'fontsize',20)

%%
wiki.dmCorr_avg = squareform(pdist(squeeze(1-mean(wiki.dm,1)),'euclidean'));
%%
[h x perm] = dendrogram(linkage(1-wiki.dmCorr_avg,'ward'),0,'labels',wiki.nouns,'ColorThreshold',1.5);
disp('done')