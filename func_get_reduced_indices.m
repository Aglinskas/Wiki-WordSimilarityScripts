function [keep_nouns_inds keep_feats_inds] = func_get_reduced_indices(wiki,keep_nouns,keep_feats)
% Reduced dm
%function [keep_nouns_inds keep_feats_inds] = func_get_reduced_indices(wiki,keep_nouns,keep_feats)
%keep_nouns = 100;
%keep_feats = 125;
[nY nI] = sort(mean(wiki.dm_avg,2),'descend');
[fY fI] = sort(mean(wiki.dm_avg,1),'descend');
keep_nouns_inds = nI(1:keep_nouns);
keep_feats_inds = fI(1:keep_feats);

%wiki.dm_avg = wiki.dm_avg(keep_nouns_inds,keep_feats_inds);
%wiki.nouns = wiki.nouns(keep_nouns_inds);
%wiki.featwords = wiki.featwords(keep_feats_inds);