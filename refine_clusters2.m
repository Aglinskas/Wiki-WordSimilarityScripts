function c = refine_clusters2(wiki,target_clusters_start,keep_elements)


c = struct;
for ii = 1:length(target_clusters_start);
i = target_clusters_start{ii};
c(ii).clust_ind = i;
c(ii).clust_elements_inds = find(ismember(wiki.noun_clust,i))';
c(ii).clust_elements_str = wiki.nouns(c(ii).clust_elements_inds)';
%c(ii).clust_elements_str = strrep(c(ii).clust_elements_str,'-n',['-' num2str(i)]);
end
% c has clusters and elements selected 
c_raw = c;
c = refine_clusters(c_raw,wiki,keep_elements)