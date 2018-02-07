function target_word = func_get_Feat_clusterElements(wiki,target)
%%
target_word = struct;
%target = 'fast-a';
target_word.word = target;
target_word.ind = find(strcmp(wiki.featwords,target_word.word));
target_word.clust = wiki.feat_clust(target_word.ind);
target_word.neighbours_ind = find(wiki.feat_clust==target_word.clust);
target_word.neighbours_ind = wiki.feat_ord(ismember(wiki.feat_ord,target_word.neighbours_ind));
target_word.neighbours_string = wiki.featwords(target_word.neighbours_ind);
%clustElements = target_word.neighbours_string;
clc;disp(target_word.neighbours_string)

%find(ismember(wiki.feat_ord,target_word_neighbours_ind))

