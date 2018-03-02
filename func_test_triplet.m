function func_test_triplet(triplet,wiki,newwiki)
%function func_test_triplet(triplet,wiki,newwiki)
pairs = nchoosek(1:3,2);
spaces = {wiki newwiki};
spaces_leg = {'Wiki-Space' 'NewWiki-Space'};
lbls = {};
for space_ind = 1:2
w = spaces{space_ind};
for i = 1:3
    res(space_ind,i) = w.sim_feat(find(strcmp(wiki.nouns,triplet{pairs(i,1)})),find(strcmp(wiki.nouns,triplet{pairs(i,2)})));
end
end

for i = 1:3
   lbls{end+1} = [triplet{pairs(i,:)}]; 
end
f = figure(1);
bar(res');
legend(spaces_leg);
f.CurrentAxes.XTickLabel = lbls;
f.CurrentAxes.FontSize = 14;