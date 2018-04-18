clear all
close all
%% 1. Load data
matrixFolder = 'DataMatrices/';
dimWordType = 'AV-COMB';
creatingDate = '29-Mar-2016'
savedmName = [matrixFolder 'reducedDM_selTargNoun_fromTop' dimWordType '-' creatingDate '.mat'];
data = load(savedmName);
fieldname = fieldnames(data);
dm_orig = data.(fieldname{1});

dimWords = data.sel_dimWords;
targWords = data.sel_targWords;

%% 
% Use a tree struct, code of each dm stands for level codeFather(end-1:end) codeSelf
% For binary tree, at each level, number of nodes = 2**level
% 
tree.dm_0 = dm_orig;
%LEVEL1
level = 1;
codeFather = '0';
[subdm{1} subdm{2}] = km_yyy(dm_orig,'dm_0');
for i = 1:2
    currentCode = ['dm_' num2str(level) codeFather num2str(i)]
    tree.(currentCode) = subdm{i};
end

%LEVEL2, code = (2,codeFathers,codeSelf)
level = 2;
codeFather = '101';
tree = km_addChildren(codeFather,tree,level)

codeFather = '102';
tree = km_addChildren(codeFather,tree,level)

%LEVEL3
level = 3;
codeFather = '2011';
tree = km_addChildren(codeFather,tree,level)

codeFather = '2012';
tree = km_addChildren(codeFather,tree,level)

codeFather = '2021';
tree = km_addChildren(codeFather,tree,level)

codeFather = '2022';
tree = km_addChildren(codeFather,tree,level)


%% REORDER ROWS according to the leaves
nodeNames = fieldnames(tree);
reorderedDM = tree.(nodeNames{8});
clusterLbl = zeros(size(reorderedDM,1),1)+8;
for i_node = 9:length(nodeNames)
    reorderedDM = vertcat(reorderedDM, tree.(nodeNames{i_node}));
    disp(size(reorderedDM));
    clusterLbl = [clusterLbl; zeros(size(tree.(nodeNames{i_node}),1),1)+i_node];
end
% 
sm = corr(reorderedDM');
figure();imagesc(sm);colorbar();
figure();silhouette(reorderedDM,clusterLbl);

[betterdm betterlbls] = helper_corr2order(reorderedDM,clusterLbl,clusterLbl);
sm2 = corr(betterdm');
figure();imagesc(sm2);colorbar();
figure();silhouette(betterdm,betterlbls);

