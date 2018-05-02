clear;
cd /Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/;
load('Jwiki.mat')

%num2str(sum(zscore(wiki.dm_avg,[],2),2),'%.4f')
wiki.dm_avg = wiki.dm_avg+.0001;
wiki.dm_avg = log(wiki.dm_avg);
%wiki.dm_avg = zscore(wiki.dm_avg,[],2);
wiki = func_wiki_addSimMats(wiki);

wiki.dm_avg

sim = corr(wiki.dm_avg');
%%
dist = pdist(wiki.dm_avg','correlation');
Z = linkage(dist,'ward');
T = cluster(Z,'Cutoff',.5);
%T = cluster(Z,'Cutoff',C,'Depth',D)
%T = cluster(Z,'Cutoff',C,'Criterion','distance')
T = cluster(Z,'Cutoff',1.4,'Criterion','distance')
disp('calculating leaf order')
tic;ord = optimalleaforder(Z,dist,'CRITERIA','adjacent');toc
%%
figure(1); disp('drawing mat')
cind = T(ord);
[Z_atlas dismat] = get_Z_atlas(Z);
ordmat = dismat(ord,ord);
imagesc(dismat(ord,ord));
xticks(1:length(dismat));
yticks(1:length(dismat));
lbls = wiki.featwords
xticklabels(lbls(ord));
yticklabels(lbls(ord));
disp('done')
%%
figure(2)
ind = find(strcmp(wiki.nouns,'spatula-n'));
redins = ord(find(ord==ind)-15:find(ord==ind)+15);
l = wiki.nouns(redins)
cc = T(redins);
m = distmat(redins,redins);
%ll = arrayfun(@(x) num2str(x,'%.2f'),mean(m,2),'UniformOutput',0);
%lb = arrayfun(@(x) [l{x} ':' ll{x}],1:length(l),'UniformOutput',0)';
add_numbers_to_mat(m,lb)
%%

t = func_get_Noun_clusterElements(wiki,'hand-n')
t.neighbours_string

corr(dist',d','type','spearman')

% king - 523
% queen - 782
% man 590
% woman 1111 
% cat 178
%%
figure(3)
dd = squareform(d);
imagesc(dd(ord,ord))
%%
n_vec = wiki.dm_avg(523,:) - wiki.dm_avg(590,:) + wiki.dm_avg(1111,:);
sim = [];
disp('running')
for i = 1:size(wiki.dm_avg,1)
    sim(i) = corr(n_vec',wiki.dm_avg(i,:)');
end
disp('done')

[Y I] = sort(sim,'descend')
wiki.nouns(I(1:10))