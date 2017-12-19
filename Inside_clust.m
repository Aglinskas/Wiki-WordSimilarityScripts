%wiki.nouns(wiki.noun_clust==18);
% normalize by cluster, J's idea
w_i = find(strcmp(wiki.nouns,'sex-n'))
c_i = wiki.noun_clust(w_i)
wiki.nouns(find(wiki.noun_clust==c_i))
i = c_i
inds = find(wiki.noun_clust==c_i);
clc;size(inds)
%%
w = wiki.dm_avg;
d = w(inds,:);
%d = zscore(d,[],1);
dv = mean(d,1)% -  mean(w,1);
%dv = (mean(d,1) - (mean(d,1) ./ std(d,[],1)))  - (mean(w,1) - (mean(w,1) ./ std(w,[],1)));
imagesc(d);
xticks(1:1:size(d,2));
yticks(1:1:size(d,1));
xticklabels(wiki.featwords);
yticklabels(wiki.nouns(inds));
xtickangle(45);
%plot(dv)
[Y I] = sort(dv,'descend');
j = wiki.featwords(I(1:10));
%%
ww = mean(w,1)';
dd = mean(d,1)';
plot(ww,dd,'r*');lsline;
hold on
plot(1:length(ww),[1:length(ww)]*GLM.p1+GLM.p2)
plot(ww,dd*GLM.p1+GLM.p2,'r*')
GLM = fit(ww,dd,'poly1');
plot(ww,dd*GLM.p1+GLM.p2,'r*'); lsline
preds = (ww-dd*GLM.p1+GLM.p2).^2;
[Y I] = sort(preds,'descend');
%wiki.featwords(I(end:-1:end-10))
wiki.featwords(I(1:10))
%%
Z = linkage(get_triu(1-corr(d)),'ward');
dendrogram(Z,size(d,2),'labels',wiki.featwords);
%%
dendrogram(linkage(1-get_triu(wiki.dmCorr_avg(inds,inds)),'ward'),0,'labels',wiki.nouns(inds),'orientation','left')