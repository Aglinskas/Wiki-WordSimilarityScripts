cd /Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/
wiki_proper = wiki;
wiki = func_wiki_addSimMats(wiki_proper,[1.5 2])
%%
clc;disp(wiki)
%imagesc = @add_numbers_to_mat;
clear imagesc
%clear imagesc
l = wiki.noun_clust(wiki.noun_ord);
n_groups = 5;
keep_elements = 8;

%(n_groups*n_items_perGroup)^2
% Ignore clusters with not enough elements;
tab = tabulate(l);
tab = tab(unique(l,'stable'),:);
small_clust = tab(:,2) < keep_elements;
l(ismember(l,tab(small_clust,1))) = [];

clust_idx = linspace(1,length(l),n_groups);
clust_idx = round(clust_idx);
target_clusters = l(clust_idx);

%
    check_full = 0;
    if check_full
    % draw full simmat 
    full_simMat = wiki.sim_noun(wiki.noun_ord,wiki.noun_ord);
    xticks(1:length(full_simMat))
    yticks(1:length(full_simMat))
    xticklabels(wiki.nouns(wiki.noun_ord))
    yticklabels(wiki.nouns(wiki.noun_ord))
    title('Full Similarity Matrix','fontsize',24);end

w = ismember(wiki.noun_clust,target_clusters);
c = struct;
for ii = 1:length(target_clusters);
i = target_clusters(ii);
c(ii).clust_ind = i;
c(ii).clust_elements_inds = find(wiki.noun_clust==i)';
c(ii).clust_elements_str = wiki.nouns(c(ii).clust_elements_inds)';
c(ii).clust_elements_str = strrep(c(ii).clust_elements_str,'-n',['-' num2str(i)])
end

c_raw = c;
c = refine_clusters(c_raw,wiki,keep_elements);


mat = wiki.sim_noun([c.clust_elements_inds],[c.clust_elements_inds]);

% Draw The matrix
    f = figure(1);
    imagesc(mat);
        f.CurrentAxes.CLim = [min(get_triu(mat)) max(get_triu(mat))];
        f.CurrentAxes.XTick = 1:length(mat);
        f.CurrentAxes.YTick = 1:length(mat);
        f.CurrentAxes.XTickLabel = [c.clust_elements_str];
        f.CurrentAxes.YTickLabel = [c.clust_elements_str];
        f.CurrentAxes.XTickLabelRotation = 45
%%
check_clust = 10;
mat = wiki.sim_noun(wiki.noun_clust==check_clust,wiki.noun_clust==check_clust)
lbls = wiki.nouns(wiki.noun_clust==check_clust)
figure(2);
add_numbers_to_mat(mat,lbls)