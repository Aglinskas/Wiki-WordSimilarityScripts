clear all;close all;
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
% 
% corr_orig = 1-pdist(dm_orig);
% figure();hist(corr_orig,50)
% mean(corr_orig)
% std(corr_orig)
% mean(corr_orig)+3*std(corr_orig)
% mean(corr_orig)-3*std(corr_orig)

%% 2
max_n_leaves = 5;
max_cluster_size = 50;
% plotting flags (flagDen,flagPlotINC,flagPlotSM,flagPlotSil,flagPrint)
plotFlags = struct('flagDen',0,'flagPlotINC',0,'flagPlotSM',1,...
    'flagPlotSil',1,'flagPrint',0)
% Width-first tree searching
% Stopping function, n_item<50, deepest level = 3
dm = dm_orig;
words = targWords;
[branches,leaves] = hc_yyy(dm,words,max_n_leaves,plotFlags);
     
% level = 0;
% tree.dm_0.dm = dm_orig;

level = 1; 
codeFather = '0';
for ib = 1:numel(branches)
    code = ['dm_' num2str(level) codeFather num2str(ib)];
    tree{level}.(code).dm = branches{ib};%words = leaves1{ib};
    tree{level}.(code).level = level;
    tree{level}.(code).codeFather = codeFather;
    tree{level}.(code).isLeaf = 1;
end

%LEVEL2
level = 2;
nodeNames = fieldnames(tree{level-1});
for iNode = 1:length(nodeNames)
    codeFather = nodeNames{iNode};
    dmFather = tree{level-1}.(codeFather).dm;
    fprintf('Father dm: (%d %d)\n',size(dmFather));

    if size(dmFather,1) > max_cluster_size
        fprintf('Further branch %s\n',codeFather);
        tree{level-1}.(codeFather).isLeaf = 0;
        [branches,leaves] = hc_yyy(dmFather,words,max_n_leaves,plotFlags);
        
        for ib = 1:length(branches)
            code = ['dm_' num2str(level) codeFather(end-1:end) num2str(ib)];
            tree{level}.(code).dm = branches{ib};%words = leaves1{ib};
            tree{level}.(code).level = level;
            tree{level}.(code).codeFather = codeFather;
            tree{level}.(code).isLeaf = 1;
        end
    end
end

%LEVEL3
level = 3;
nodeNames = fieldnames(tree{level-1});
for iNode = 1:length(nodeNames)
    codeFather = nodeNames{iNode};
    dmFather = tree{level-1}.(codeFather).dm;
    fprintf('Father dm: (%d %d)\n',size(dmFather));

    if size(dmFather,1) > max_cluster_size
        fprintf('Further branch %s\n',codeFather);
        tree{level-1}.(codeFather).isLeaf = 0;
        [branches,leaves] = hc_yyy(dmFather,words,max_n_leaves,plotFlags);
        for ib = 1:length(branches)
            code = ['dm_' num2str(level) codeFather(end-1:end) num2str(ib)];
            tree{level}.(code).dm = branches{ib};%words = leaves1{ib};
            tree{level}.(code).level = level;
            tree{level}.(code).codeFather = codeFather;
            tree{level}.(code).isLeaf = 1;
        end
    end
end

% 
level = 4;
nodeNames = fieldnames(tree{level-1});
for iNode = 1:length(nodeNames)
    codeFather = nodeNames{iNode};
    dmFather = tree{level-1}.(codeFather).dm;
    fprintf('Father dm: (%d %d)\n',size(dmFather));

    if size(dmFather,1) > max_cluster_size
        fprintf('Further branch %s\n',codeFather);
        tree{level-1}.(codeFather).isLeaf = 0;
        [branches,leaves] = hc_yyy(dmFather,words,max_n_leaves,plotFlags);
        for ib = 1:length(branches)
            code = ['dm_' num2str(level) codeFather(end-1:end) num2str(ib)];
            tree{level}.(code).dm = branches{ib};%words = leaves1{ib};
            tree{level}.(code).level = level;
            tree{level}.(code).codeFather = codeFather;
            tree{level}.(code).isLeaf = 1;
        end
    end
end

% 
level = 5;
nodeNames = fieldnames(tree{level-1});
for iNode = 1:length(nodeNames)
    codeFather = nodeNames{iNode};
    dmFather = tree{level-1}.(codeFather).dm;
    fprintf('Father dm: (%d %d)\n',size(dmFather));

    if size(dmFather,1) > max_cluster_size
        fprintf('Further branch %s\n',codeFather);
        tree{level-1}.(codeFather).isLeaf = 0;
        [branches,leaves] = hc_yyy(dmFather,words,max_n_leaves,plotFlags);
        for ib = 1:length(branches)
            code = ['dm_' num2str(level) codeFather(end-1:end) num2str(ib)];
            tree{level}.(code).dm = branches{ib};%words = leaves1{ib};
            tree{level}.(code).level = level;
            tree{level}.(code).codeFather = codeFather;
            tree{level}.(code).isLeaf = 1;
        end
    end
end

%% loop through the tree
%  REORDER ROWS according to the leaves
clear reorderedDM clusterLbl
n_leaves = 0;
for i_level = 1:numel(tree)
    nodes = tree{i_level};
    nodenames = fieldnames(nodes);
    for i_node = 1:length(nodenames)
        if nodes.(nodenames{i_node}).isLeaf == 1
            n_leaves = n_leaves+1;
            fprintf('%d Leaf node at %d level, %s',n_leaves,i_level,nodenames{i_node});
            try
                reorderedDM = vertcat(reorderedDM, nodes.(nodenames{i_node}).dm);
                clusterLbl = [clusterLbl;zeros(size(nodes.(nodenames{i_node}).dm,1),1)+n_leaves];
                fprintf('(%d)\n',size(nodes.(nodenames{i_node}).dm,1));
            catch
                reorderedDM = nodes.(nodenames{i_node}).dm;
                clusterLbl = zeros(size(nodes.(nodenames{i_node}).dm,1),1)+1;
                
                fprintf('(%d)\n',size(reorderedDM,1));
            end
        end
    end
end
% 
sm = corr(reorderedDM');
figure();imagesc(sm);colorbar();

set(gca,'YTick',1:10:size(reorderedDM,1));
set(gca,'YTickLabel',clusterLbl(1:10:size(reorderedDM,1))); 
set(gca,'XTick',1:10:size(reorderedDM,1));
set(gca,'XTickLabel',clusterLbl(1:10:size(reorderedDM,1))); 


[betterdm betterlbls] = helper_corr2order(reorderedDM,clusterLbl,clusterLbl);
sm2 = corr(betterdm');
figure();imagesc(sm2);colorbar();

figure();silhouette(reorderedDM,clusterLbl);
figure();silhouette(betterdm,betterlbls);
