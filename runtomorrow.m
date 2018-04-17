clear;close all
cd /Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/
load('Jwiki.mat');wiki_orig = wiki;
%%
top_n = 800;
top_f = 1000;
[keep_nouns_inds keep_feats_inds] = func_get_reduced_indices(wiki_orig,top_n,top_f);
wiki = func_slice_wiki(wiki_orig,keep_nouns_inds,keep_feats_inds);
wiki = func_wiki_addSimMats(wiki);
%%

targ = 'river-n'
target = func_get_Noun_clusterElements(wiki,targ);
%%


keep_nouns = 800;
keep_feats = 150;
[keep_nouns_inds keep_feats_inds] = func_get_reduced_indices(wiki,keep_nouns,keep_feats)
newWiki = func_slice_wiki(wiki,keep_nouns_inds,keep_feats_inds);
newWiki = func_wiki_addSimMats(newWiki)

T = func_get_Noun_clusterElements(newWiki,'cat-n');
disp(T.neighbours_string)