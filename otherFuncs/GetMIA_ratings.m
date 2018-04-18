P=dir('dm_wordlist_typi_en_s*.mat')

for ii=1:length(P)
    load(P(ii).name);
    x=corr(dm');
    glog(ii,:,:)=x;
    subplot(2,2,ii),imagesc(x)
    title(P(ii).name);
    x=(triu(x,1));
    y=(triu(NaN(length(x)),1));
    x=x(:);
    x(~isnan(y(:)))=[];
    x(isnan(x))=0; % missing values
    keep(ii,:)=x;
end
subplot(2,2,4),imagesc(squeeze(mean(glog)))



 subInd={'05','06','07','08','09','10'}
for ii=1:length(subInd)
    
   P= dir(['/Users/scott/Data/WP 2.4.1  MEG Typicality RSA/MEGTypicalityRSA_new/similarityJudgementData_21102015/' subInd{ii} '_session1_trial*.mat']);
load(['/Users/scott/Data/WP 2.4.1  MEG Typicality RSA/MEGTypicalityRSA_new/similarityJudgementData_21102015/' P(end).name])  % load final
keepSubj(ii,:)=1-estimate_dissimMat_ltv;
end

    matSubj=squareform(mean(keepSubj));
    matSubj=matSubj+eye(size(matSubj));% just to scale
subplot(2,2,3),imagesc(matSubj)


%%
cc=0;
all=[];
allSubj=[];
nouns=textread('/Users/scott/Data/WP2.2/wordlist_typi_en_sortedTyp.txt','%s');


    matSubj=squareform(mean(keepSubj));
for ii=1:32:160
    
yy=matSubj(ii:ii+31,ii:ii+31);
xx=squeeze(mean(glog(:,ii:ii+31,ii:ii+31)));
all=[all; nanmean(xx)'];
allSubj=[allSubj; nanmean(yy)'];
end

Z=linkage(mean(1-keepSubj),'ward');
dendrogram(Z,length(nouns),'Labels',nouns');