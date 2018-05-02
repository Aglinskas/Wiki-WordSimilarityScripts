function wiki = func_wiki_addSimMats(varargin)
%% Input validation
tic
    if nargin == 0
        warning('on');warning('no input, loading cached wiki')
        load('Jwiki.mat')
        pause(1)
        thresh = [1 1];
    elseif nargin == 1
        wiki = varargin{1};
        thresh = [1 1];
    elseif nargin == 2
        wiki = varargin{1};
        thresh = varargin{2};
    elseif nargin >2
        error('too many inputs, check yo shiet')
    end
do_plot = logical(1);
warning('off','stats:linkage:NotEuclideanMatrix');
%wiki.nouns(I(1:50));wiki.nouns(I(end:-1:end-10))
%[Y I] = sort(mean(wiki.dm_avg,1),'descend')
%wiki.featwords(I(1:50));wiki.featwords(I(end:-1:end-10))
%wiki.dm_avg = wiki.dm_avg + .0001;
%wiki.dm_avg = log(wiki.dm_avg);
%% Run Similarity
wiki.sim_feat = corr(wiki.dm_avg);
wiki.sim_noun = corr(wiki.dm_avg');
%clc;disp(wiki)
%% Cluster
%mats = {wiki.dm_avg wiki.dm_avg'};
mats = {wiki.sim_noun wiki.sim_feat};
lbls = {wiki.nouns wiki.featwords};
ttls = {'Noun Clustering' 'Feature Clustering'};
for w_mat = 1:2;
disp(sprintf('%d/2',w_mat));
    figure(w_mat);
%d = pdist(mats{w_mat},'correlation');
%Z = linkage(d,'ward');
Z = linkage(1-get_triu(mats{w_mat}),'ward');
    figure(w_mat);
    [h{w_mat} x{w_mat} perm{w_mat}] = dendrogram(Z,0,'labels',lbls{w_mat},'colorthreshold',thresh(w_mat));
    xtickangle(45)
    drawnow
n_clust = length(unique(cellfun(@num2str,{h{w_mat}.Color},'UniformOutput',0)));
    temp = figure(66);
    temp.Visible = 'off';
    drawnow;
    [h{w_mat} clust{w_mat} lol{w_mat}] = dendrogram(Z,n_clust);    
    if w_mat==1 
        wiki.noun_clust = clust{w_mat};
        wiki.noun_ord = perm{w_mat}';
    elseif w_mat==2
        wiki.feat_clust = clust{w_mat};
        wiki.feat_ord = perm{w_mat}';
    end
figure(w_mat);
title({ttls{w_mat} ['n-clust ' num2str(n_clust) ', n-items ' num2str(length(mats{w_mat})) ', thresh ' num2str(thresh(w_mat))]},'fontsize',20)
end
toc