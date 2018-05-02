load('jwiki')
wiki.dm_avg = log(wiki.dm_avg+.0001);
wiki.dm_avg = zscore(wiki.dm_avg,[],2);
wiki.dm_avg = zscore(wiki.dm_avg,[],1);
%% Run numbers
clc;
disp('calculating');tic;
d1 = pdist(wiki.dm_avg,'correlation');
Z = linkage(d1,'ward');
[Z_atlas distmat] = get_Z_atlas(Z);
[coph cophMatTriu] = cophenet(Z,d1);
noun_ord = optimalleaforder(Z,d1,'Criteria','group');
%%
%cophMat = squareform(cophMatTriu);
% T = cluster(Z,'Cutoff',C,'Criterion','inconsistent');
% T = cluster(Z,'MaxClust',N)
%%
wiki.sim_noun = squareform(d1);
wiki.dist_noun = distmat;
wiki.noun_ord =noun_ord;
wiki.nouns = strrep(wiki.nouns,'-n','');
%% Cluster
figure(4)
C = 1.46;
D = 4;
T = cluster(Z,'Cutoff',C,'Criterion','distance');
wiki.noun_clust = T;
%T = cluster(Z,'Cutoff',C);
c_str = arrayfun(@(x) {num2str(x)},T);
lbls = wiki.nouns;
lbls = arrayfun(@(x) [wiki.nouns{x} ': ' c_str{x}],1:length(wiki.nouns),'UniformOutput',0)';
%% Draw
% Full matrix
disp('plotting');tic
%plotmat = wiki.dist_noun;
plotmat = wiki.dist_noun;
figure(4); 
%ord = 1:length(plotmat);
%ord = noun_ord;
ord = wiki.noun_ord
add_numbers_to_mat(plotmat(ord,ord),lbls(ord),'nonum');
caxis([min(plotmat(:)) max(plotmat(:))])
%% Zoom Mat
figure(3);
t_ind = find(strcmp(wiki.nouns(ord),'spatula'));
sz1 = 30;
sz2 = 30;
add_numbers_to_mat(plotmat(ord(t_ind-sz1:t_ind+sz2),ord(t_ind-sz1:t_ind+sz2)),lbls(ord(t_ind-sz1:t_ind+sz2)),'nonum');
caxis([min(plotmat(:)) max(plotmat(:))])
clc;disp(wiki.nouns(ord(t_ind-sz1:t_ind+sz2)))
disp('all done')
%%