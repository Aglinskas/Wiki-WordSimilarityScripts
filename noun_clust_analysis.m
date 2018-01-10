clear;disp('loading data')
tic;load('/Users/aidasaglinskas/Desktop/wiki.mat');toc
disp('loaded')
%%
Z = linkage(1-get_triu(wiki.dmCorr_avg),'ward');
    cthresh = 1; %max(Z(:,3)) * .7 %percentage of max
[h x perm] = dendrogram(Z,0,'ColorThreshold',cthresh);
nclust = length(unique(cellfun(@num2str,{h.Color},'UniformOutput',0)));
[h clust_ID x] = dendrogram(Z,nclust,'ColorThreshold',cthresh)
[h x perm] = dendrogram(Z,0,'ColorThreshold',cthresh,'labels',wiki.nouns);
wiki.noun_clust = clust_ID;
wiki.noun_ord = perm;
%% Words in a cluster
    targ = [];
targ.word = 'lipstick-n';
targ.ind = find(strcmp(wiki.nouns,targ.word));
if ~isempty(targ.ind)
targ.clust = wiki.noun_clust(targ.ind);
targ.clust_inds = find(wiki.noun_clust==targ.clust)
clc;disp(targ)
targ.clust_words = wiki.nouns(targ.clust_inds);
targ.clust_words
else;clc;disp('No such word');end
%% Definig Features
hold on
bar(mean(wiki.dm_avg))
bar(mean(wiki.dm_avg(targ.clust_inds,:)))
hold off
a = mean(wiki.dm_avg(targ.clust_inds,:)) - mean(wiki.dm_avg);
bar(a)
[Y I] = sort(a,'descend');
wiki.featwords(I(1:10))

