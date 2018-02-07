function target_word = func_get_Noun_clusterElements(wiki,target)
target_word = struct;
target_word.word = target;
target_word.ind = find(strcmp(wiki.nouns,target_word.word));
target_word.clust = wiki.noun_clust(target_word.ind);
target_word.neighbours_ind = find(wiki.noun_clust==target_word.clust);
target_word.neighbours_ind = wiki.noun_ord(ismember(wiki.noun_ord,target_word.neighbours_ind));
target_word.neighbours_string = wiki.nouns(target_word.neighbours_ind);
clc;disp(target_word.neighbours_string)
