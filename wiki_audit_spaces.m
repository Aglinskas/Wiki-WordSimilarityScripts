clear;cd '/Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/'
wiki = func_wiki_addSimMats
%%
% film - 361
% movie - 637
% cat -178
% dog - 305
% car - 166
% girl 409
% boy 110
% bonobo 1376
target_word = func_get_Noun_clusterElements(wiki, 'ball-n');
target_word.neighbours_string
R = func_get_clustFeatures(wiki,target_word.neighbours_ind);
clc;disp(R.header) 
%% Feats
space_query = 'color-v';
target_word = func_get_Feat_clusterElements(wiki, 'run-v');
range = wiki.feat_clust(find(wiki.noun_ord==target_word.ind)-50:find(wiki.noun_ord==target_word.ind)+50);
wiki.featwords(range);
%%
rwiki = func_slice_wiki(wiki,1:size(wiki.dm_avg,1),range);
rwiki = func_wiki_addSimMats(rwiki);
%%
word_pair = {'piano-n' 'cat-n'}
word_pair_ind = [];
word_pair_ind = [find(strcmp(wiki.nouns,word_pair{1})) find(strcmp(wiki.nouns,word_pair{2}))]
f = figure(3)
sim = [wiki.sim_feat(word_pair_ind(1),word_pair_ind(2)) rwiki.sim_feat(word_pair_ind(1),word_pair_ind(2))];

bar(sim)
f.CurrentAxes.XTickLabel = {'full space' space_query};
f.CurrentAxes.FontSize = 14
title([word_pair{1} ' - ' word_pair{2}],'fontsize',20)