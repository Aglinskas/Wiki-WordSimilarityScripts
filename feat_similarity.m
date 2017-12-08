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
[h x perm] = dendrogram(Z,0,'labels',wiki.featwords,'ColorThreshold',2.1);




