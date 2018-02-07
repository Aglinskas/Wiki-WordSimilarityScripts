function R = func_get_clustFeatures(wiki,inds)
%target = func_get_Noun_clusterElements(wiki,'man-n');
%inds = target.neighbours_ind;
%inds = wiki.noun_ord(1091:end);
%inds = wiki.noun_ord(1:1091);
%%
c_vec = nanmean(wiki.dm_avg(inds,:),1);
other_vec = nanmean(wiki.dm_avg(:,:),1);
dif = c_vec - other_vec;
dif(dif<0) = 0;
dif = dif ./ nanstd(wiki.dm_avg(:,:));
figure(3);clf;plot(dif);
[Y I] = sort(dif,'descend');
T = table();
T.word = wiki.featwords(I);
T.stat = Y';

R.query = wiki.nouns(inds)
R.inds = inds;
R.header = T(1:10,:);
R.table = T;
clc;disp(T(1:10,:));