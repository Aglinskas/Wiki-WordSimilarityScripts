% Sort by feature
featlbls = b.feature_lbls;
nfeats = 1:length(featlbls);
featmat = b.rating_mat;
lbls = b.noun_labels;
T = {};
nwords = 300;
for i = nfeats
    %vec = featmat(:,i) ./ mean(featmat(:,find(~ismember([1:size(featmat,2)],i))),2);
    vec = featmat(:,i);
    [Y I] = sort(vec,'descend');
    T{1,i} = featlbls{i};
    [T{2:nwords+1,i}] = deal(lbls{I(1:nwords)}); 
end
%%
clearvars -except b d T
%%

input_list = T(2:end,4);
[cursT colleg] = query_MRCDB(input_list)


