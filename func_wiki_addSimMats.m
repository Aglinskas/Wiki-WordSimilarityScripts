function wiki = func_wiki_addSimMats(varargin)
%% Input validation
    if nargin == 0
        warning('on');warning('no input, loading cached wiki')
        load('/Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/Jwiki.mat')
        thresh = [1 1]
    elseif nargin == 1
        wiki = varargin{1};
        thresh = [1 1]
    elseif nargin == 2
        wiki = varargin{1};
        thresh = varargin{2};
    elseif nargin >2
        error('too many inputs, check yo shiet')
    end
do_plot = logical(1);
%% Run Similarity
wiki.sim_noun = corr(wiki.dm_avg);
wiki.sim_feat = corr(wiki.dm_avg');
%clc;disp(wiki)
%% Cluster
mats = {wiki.dm_avg wiki.dm_avg'};
lbls = {wiki.nouns wiki.featwords};
for w_mat = 1:2;
    figure(w_mat)
d = pdist(mats{w_mat},'correlation');
Z = linkage(d,'ward');
    [h x perm] = dendrogram(Z,0,'labels',lbls{w_mat},'colorthreshold',thresh(w_mat));
    xtickangle(45)
    drawnow
    
end