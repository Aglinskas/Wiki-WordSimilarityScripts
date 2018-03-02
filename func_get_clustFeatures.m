function R = func_get_clustFeatures(wiki,inds)
%target = func_get_Noun_clusterElements(wiki,'man-n');
%inds = target.neighbours_ind;
%inds = wiki.noun_ord(1091:end);
%inds = wiki.noun_ord(1:1091);
%%
norm = 0;
if norm 
dim = 1;
wiki.dm_avg = (wiki.dm_avg - min(wiki.dm_avg,[],dim)) ./ (max(wiki.dm_avg,[],dim) - min(wiki.dm_avg,[],dim));
end
c_vec = nanmean(wiki.dm_avg(inds,:),1);
other_vec = nanmean(wiki.dm_avg(:,:),1);
%c_vec = (c_vec - min(c_vec)) / (max(c_vec) - min(c_vec));
%c_vec = c_vec - mean(c_vec);
%other_vec = (other_vec - min(other_vec)) / ( max(other_vec) - min(other_vec));
%other_vec = other_vec - mean(other_vec);

%figure(4);clf;plot(c_vec);hold on;plot(other_vec)

dif = c_vec - other_vec;
dif(dif<0) = 0;
dif = dif ./ nanstd(wiki.dm_avg(:,:));
figure(3);clf;plot(dif);
title('Feature loadings','fontsize',20)
[Y I] = sort(dif,'descend');
T = table();
T.word = wiki.featwords(I);
T.stat = Y';

R.query = wiki.nouns(inds)
R.inds = inds;
R.header = T(1:10,:);
R.table = T;
clc;disp(T(1:10,:));