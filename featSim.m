tic;load('/Users/aidasaglinskas/Desktop/wiki.mat');toc
%%
%a_inds = find(~cellfun(@isempty,strfind(wiki.featwords,'-a')));
%wiki.dm = wiki.dm(:,:,a_inds)
%wiki.featwords = wiki.featwords(a_inds)
%%
for i = 1:size(wiki.dm,1)
    clc;disp(i)
  wiki.featSim(i,:,:) = corr(squeeze(wiki.dm(i,:,:)));
end
wiki.avgfeatSim = corr(squeeze(mean(wiki.dm,1)));
%%
d = pdist(squeeze(mean(wiki.dm,1))','correlation');
wiki.avgfeatSim = squareform(d);
size(wiki.avgfeatSim)
%%
tic;
Z = linkage(get_triu(wiki.avgfeatSim),'ward');
toc;
%%
tic;[h x perm] = dendrogram(Z,0,'labels',wiki.featwords,'ColorThreshold',1);toc;
nclust = length(unique(cellfun(@(x) num2str(x),{h.Color},'UniformOutput',0))');
tic;[h x clust] = dendrogram(Z,nclust,'labels',wiki.featwords,'ColorThreshold',2);toc;

wiki.feat_ord = perm;
wiki.feat_clust = x;
%%
targ_word = 'red-a';
targ_ind = find(strcmp(wiki.featwords,targ_word));
clust_targ_inds = find(wiki.feat_clust==wiki.feat_clust(targ_ind));
wiki.featwords(clust_targ_inds)
%%
redmat = wiki.avgfeatSim(clust_targ_inds,clust_targ_inds);
redmat = redmat ./ max(max(redmat))
redmat_lbls = wiki.featwords(clust_targ_inds);
clf;add_numbers_to_mat(redmat,redmat_lbls)

add_numbers_to_mat(mean(-redmat)',redmat_lbls)


