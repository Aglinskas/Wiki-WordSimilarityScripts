% CD to the folder
%% Run this first
cd /Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/
%wiki_proper = wiki;
%wiki = func_wiki_addSimMats(wiki_proper,[1.5 2])
wiki = func_wiki_addSimMats()
% ^ takes around 2 minutes to compute, returns wiki structure
clc;disp('Ready')
%% Then This
clc;disp(wiki);
n_groups = 16; % how many groups
keep_elements = 8; % how many elements per group

%%% self sufficient code below
% Ignore clusters with not enough elements;
l = wiki.noun_clust(wiki.noun_ord); % list of all clusters in order
tab = tabulate(l);
tab = tab(unique(l,'stable'),:);
small_clust = tab(:,2) < keep_elements; % find clusters that are too small, less than keep_elements
l(ismember(l,tab(small_clust,1))) = []; % drop em

%find n_groups number of clusters, evenly spread out in dissimilarity
clust_idx = linspace(1,length(l),n_groups);
clust_idx = round(clust_idx);
target_clusters = l(clust_idx);
% ^ target_clusters is clusters that will be used


    % if you want to show full 1400 noun dissimilarity matrix, set check_full = 1
    check_full = 0;
    if check_full
    % draw full simmat 
    full_simMat = wiki.sim_noun(wiki.noun_ord,wiki.noun_ord);
    imagesc(full_simMat)
    xticks(1:length(full_simMat));
    yticks(1:length(full_simMat));
    xticklabels(wiki.nouns(wiki.noun_ord));
    yticklabels(wiki.nouns(wiki.noun_ord));
    title('Full Similarity Matrix','fontsize',24);end

% Finds items belonging to target clusters
w = ismember(wiki.noun_clust,target_clusters);
 



% loops through clusters
c = struct;
for ii = 1:length(target_clusters);
i = target_clusters(ii);
c(ii).clust_ind = i;
c(ii).clust_elements_inds = find(wiki.noun_clust==i)';
c(ii).clust_elements_str = wiki.nouns(c(ii).clust_elements_inds)';
c(ii).clust_elements_str = strrep(c(ii).clust_elements_str,'-n',['-' num2str(i)]);
end
% c has clusters and elements selected 
c_raw = c;
c = refine_clusters(c_raw,wiki,keep_elements);
% refine_clusters selects only #keep_elements number of best behaving items
% from a cluster

% final matrix with n_groups and keep_elements per group
mat = wiki.sim_noun([c.clust_elements_inds],[c.clust_elements_inds]);

% figure out figure handle
if exist('f_pass') ~= 1
figs.list_of_figs = get(0,'children')
figs.fig_ind = min(find(~ismember(1:100,[figs.list_of_figs.Number]))); 
f_pass = 1
end
% ^ find smallest unused figure number

% Draw The matrix
    f = figure(figs.fig_ind);
    imagesc(mat);
        f.CurrentAxes.CLim = [min(get_triu(mat)) max(get_triu(mat))];
        f.CurrentAxes.XTick = 1:length(mat);
        f.CurrentAxes.YTick = 1:length(mat);
        f.CurrentAxes.XTickLabel = [c.clust_elements_str];
        f.CurrentAxes.YTickLabel = [c.clust_elements_str];
        f.CurrentAxes.XTickLabelRotation = 45
ttl = sprintf('%d categories\n%d items/cat',n_groups,keep_elements);
title(ttl,'fontsize',20)
%%
check_clust = 10;
mat = wiki.sim_noun(wiki.noun_clust==check_clust,wiki.noun_clust==check_clust)
lbls = wiki.nouns(wiki.noun_clust==check_clust)
figure(2);
add_numbers_to_mat(mat,lbls)