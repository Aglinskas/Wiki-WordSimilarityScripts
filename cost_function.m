function measure = cost_function(wiki)
words{1} = {'cat-n' 'dog-n'};
words{2} = {'truck-n' 'car-n'};

%t_word = words{4};
%find(strcmp(wiki.nouns,t_word))
words_ind{1} = arrayfun(@(x) find(strcmp(wiki.nouns,words{1}{x})),1:length(words{1}));
words_ind{2} = arrayfun(@(x) find(strcmp(wiki.nouns,words{2}{x})),1:length(words{2}));

red_mat = wiki.dmCorr_avg([words_ind{:}],[words_ind{:}]);
add_numbers_to_mat(red_mat,[words{:}]);
w1 = get_triu(wiki.dmCorr_avg(words_ind{1},words_ind{1}));
w2 = get_triu(wiki.dmCorr_avg(words_ind{2},words_ind{2}));
a = mean(mean(wiki.dmCorr_avg(words_ind{2},words_ind{1})));

measure = mean([w1 w2]) ./ a;