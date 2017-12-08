measure = [];
% first way 
wiki.dmCorr_avg = corr(squeeze(nanmean(wiki.dm,1))');
measure(1) = cost_function(wiki)
wiki.dmCorr_avg = [];
for i = 1:32
    disp(i)
   wiki.dmCorr_avg(:,:,i) = corr(squeeze(wiki.dm(i,:,:))');
end
wiki.dmCorr_avg = mean(wiki.dmCorr_avg,3);
measure(2) = cost_function(wiki)