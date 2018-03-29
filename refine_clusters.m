function c = refine_clusters(c,wiki,keep_elements)
% function c = refine_clusters(c,keep_elements)
% Refines clusters 
%
%keep_elements = 8;
for c_ind = 1:length(c)
   inds = c(c_ind).clust_elements_inds;
   ninds = [c(find(~ismember(1:length(c),c_ind))).clust_elements_inds];
   
  
   base_freq = mean(wiki.dm_avg(inds,:),2);
   base_freq = base_freq ./ max(base_freq);
   base_freq_weight = .3;
   base_freq = base_freq * base_freq_weight;
   
   a = wiki.sim_noun(inds,inds);
   within =  mean(a,2) ./ std(a,[],2);
   
   b = wiki.sim_noun(inds,ninds);
   across =  mean(b,2) ./ std(b,[],2);
   
   ratio = within ./ across;
   ratio = ratio ./ max(ratio);
   ratio = ratio .* base_freq
   %ratio = across ./ within  ;
   [Y I] = sort(ratio,'descend');   
   
   take_inds = inds(I);
   take_inds = take_inds(1:keep_elements);
   
   c(c_ind).clust_elements_inds = take_inds;
   c(c_ind).clust_elements_str = wiki.nouns(take_inds)';
   c(c_ind).clust_elements_str = strrep(c(c_ind).clust_elements_str,'-n',['-' num2str(c(c_ind).clust_ind)])
   
%    c(c_ind).clust_elements_inds = c(c_ind).clust_elements_inds(1:keep_elements);
%    c(c_ind).clust_elements_str = c(c_ind).clust_elements_str(1:keep_elements);
   
end
%%
%mat = wiki.sim_noun(inds(I),[inds(I) ninds]);
% mat = wiki.sim_noun(inds,[inds ninds]);
% imagesc(mat)


