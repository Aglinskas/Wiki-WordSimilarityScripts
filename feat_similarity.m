wiki.dm_feat = [];
for i = 1:size(wiki.dm,1);
    disp(i)
wiki.dm_feat(i,:,:) = corr(squeeze(wiki.dm(i,:,:)));
end
disp('done')
%%
wiki.dm_feat_avg = squeeze(nanmean(wiki.dm_feat,1));
%%
upper_tri  = get_triu(wiki.dm_feat_avg);
Z = linkage(1-get_triu(wiki.dm_feat_avg),'ward');
[h featClust perm] = dendrogram(Z,82); %
wiki.feat_clust = featClust; featClust = [];
[h x perm] = dendrogram(Z,0,'labels',wiki.featwords,'ColorThreshold',2.1);
%%

ind = find(strcmp(wiki.nouns,'red-n'));
ind = find(strcmp(wiki.nouns,'green-a'))
wiki.noun_clust(ind)
clust_ind = wiki.feat_clust(ind);
%sort(wiki.featwords(find(wiki.feat_clust == clust_ind)))
[Y I] = sort(wiki.dm_feat_avg(ind,:),'descend');
temp = wiki.featwords(I);

temp(end:-1:end-10)






