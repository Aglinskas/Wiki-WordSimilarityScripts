clear
load workingNouns

tempWord = word;
tempDm_verb = dm_verb;
close all

sScore = zeros(126,409);
Ts = zeros(126,409);
for thisT=[3:128]
    disp(thisT);
    %itemPerCat=(32+192)/thisT;
    Y = pdist(tempDm_verb,'correlation');
    Z = linkage(Y,'ward');
    %[H T] = dendrogram(Z,thisT,'Labels',tempWord' );%,'ColorThreshold');% ,Z(end-thisT+1,3) );
    T = cluster(Z,'maxclust',thisT,'criterion','distance');
    S = silhouette(tempDm_verb, T,'correlation');
    sScore(thisT-1,:) = S;%mean(S);
    Ts(thisT-2,:) = T;
%     tInd=unique(T);
%     for ii=1:length(tInd)
%         tempI(ii)= mean(S(T==tInd(ii)));
%     end
%     clustScore(thisT)=mean(tempI);
end
scoreItem = sScore(:,1);
plot(scoreItem)
scoreItem = sScore(:,2);
hold on; plot(scoreItem,'r');
close all

clusterWidth = mean(sScore,2);
figure();
plot(clusterWidth,'r-*');
%%
% plot([clustScore;   sScore]')
grandavgSil = [];
grandvarSil = [];
for i_clustering = 1:126
    sil = sScore(i_clustering,:);
    clbl = Ts(i_clustering,:);
    avgsilCluster = [];
    for iCluster = unique(clbl)
        avgsilCluster(iCluster) = mean(sil(clbl==iCluster));
    end
    grandavgSil(i_clustering) = mean(avgsilCluster);
    grandvarSil(i_clustering) = var(avgsilCluster);
end
figure();
plot(grandavgSil,'-*');
figure();
plot(grandvarSil,'r-*');
figure();plot(grandavgSil./linspace(3,128,126),'k-*');
errorbar(1:126,grandavgSil,sqrt(grandvarSil));

norm0 = grandavgSil./grandvarSil;
figure();plot(norm0,'b-*');%

norm = grandavgSil./sqrt(grandvarSil);
figure();plot(norm,'m-*');

