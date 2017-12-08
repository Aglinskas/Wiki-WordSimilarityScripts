%wiki.nouns(wiki.noun_clust==18);
% normalize by cluster, J's idea
i = 11
inds = find(wiki.noun_clust==i);
length(inds)
%find(strcmp(wiki.nouns,'sock-n'))
%wiki.noun_clust(915)
%wiki.nouns(wiki.noun_clust==i)
%%
w = wiki.dm_avg;
d = w(inds,:);
%d = zscore(d,[],2);
dv = (mean(d,1) -  mean(w,1)) ./ std(d,[],1);
imagesc(dv);
%%
xticks(1:1:size(d,2))
yticks(1:1:size(d,1))
xticklabels(wiki.featwords)
yticklabels(wiki.nouns(inds))
xtickangle(45)
%plot(dv)
[Y I] = sort(dv,'descend');
wiki.featwords(I(1:10));
%%
Z = linkage(get_triu(1-corr(d)),'ward');
dendrogram(Z,size(d,2),'labels',wiki.featwords);