clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to load wiki within sentence co-occurance counts
% impliment differnt preprocessing steps for compariosn
% output clustering
% this goal is to decide on nice stable paramaters to take to feature based
% dimension-specifc siliarity spaces (Josine) and smart, sensitive heiratchical
% clustering (Aidas)
%%%%%%%%%%%%%%%%%a%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% boleans to impliment differnt pre-processing
enableFeaureSelect=false; % specify subset of features via 'keepWords'
corr32=true; % create 32 different DSMs then average t eh r values
% or averaged/sum all the data then caluclate the DSM
logEarly=true; % do a log trasnfrom for each subset prior to corr - only relevent if corr32 is true
logAtAll=true; % log the data matrix (if corr32 is false). pretty standard and sensible step
rescaleFeaturebyFrequecy=true; %scale e.g. 'the verb to be' so that is does not dominate the model. NB this is applied in a very weird way
% minThresh=25; has been hardcoded here. I prefer to soft code if we will
% be lokking at different feautres spaces etc (and in general). BUT, 25 for
% now
%% todo
% double check the feature labels are correct. I supsect some quick fixes we
% implimented that look bad but actually work -slf
%% loading words from text files - this cannot really change
cd '/Users/aidasaglinskas/Desktop/Wiki-wordSimilarityScripts/'
topVerb=getVerb;
topNouns=gettopNouns;
topAdjs=gettopAdjs;


topVerb = cellfun(@(x) [x '-v'],topVerb,'UniformOutput',0);
topNouns = cellfun(@(x) [x '-n'],topNouns,'UniformOutput',0);
topAdjs = cellfun(@(x) [x '-a'],topAdjs,'UniformOutput',0);

featWords = [topVerb topNouns topAdjs];

% featWords=[];
% for ii=1:length(topVerb)
%     featWords{end+1}=[topVerb{ii} '-v'];
% end
% for ii=1:length(topAdjs)
%     featWords{end+1}=[topAdjs{ii} '-a'];
% end
% for ii=1:length(topNouns)
%     featWords{end+1}=[topNouns{ii} '-n'];
% end
%

% cellfun(@length,{topVerb topAdjs topNouns}) % number of V A N
MRCnoun=getMRCNoun;
MRCnoun = cellfun(@(x) [x '-n'],MRCnoun,'UniformOutput',0);
% for ii=1:length(MRCnoun)
%     MRCnoun{ii}=[MRCnoun{ii} '-n'];
% end
for ii=1:length(MRCnoun)  % remove target nouns from feature noun list
    featWords(find(strcmp(MRCnoun(ii),featWords)))=[];  % WHY IS THIS NOT DONE IN THE DATA TOO ?????
end
%% remove low frequency features from independent source
% DON"T TOUCH
load absFreq8435features
freqThresh=500;
for ii=length(featWords):-1:1  
    if absScore(find(strcmp(featWords{ii},absWord)))<freqThresh
        featWords(ii)=[];
    end
end
%% spotRepeats, index with featKill, then remove from list now and data later
featKill=[];
for ii=1:length(featWords)
    foo=find(strcmp(featWords{ii},featWords));
    if length(foo)>1
        featKill=[featKill foo(2:end)];
    end
end
featWords(featKill)=[];
%% Restrict features
if enableFeaureSelect
keepWords={'red-a','blue-a','green-a'}
keepInd=[];
for i=1:length(keepWords)
    keepInd=[keepInd find(strcmp(featWords,keepWords{i}))];
end
end
%% load 32 wiki generate data matrices
% generate both raw Data Martices and corr32  DSMs
for ii=1:32
    clc;disp(ii);
    load(['./clusterOut/doneSoFarRandSamp_' num2str(ii) '.mat'])
       dm(:,featKill)=[];  % this removed repeats
  if enableFeaureSelect
    dm=dm(:,keepInd);
  end
    dmAll(ii,:,:)=dm;
    if logEarly
        dmCorr(ii,:,:)=corr(dm'+1);
    else
        dmCorr(ii,:,:)=corr(dm');
    end
end
imagesc(log(squeeze(mean(dmAll))));
colorbar
disp('done')

wiki.dm = dmAll;
wiki.featwords = featWords';
wiki.nouns = MRCnoun';
wiki.dmCorr = dmCorr;

if length(wiki.featwords) ~= size(wiki.dm,3) | length(wiki.nouns) ~= size(wiki.dm,2)
    error('Dim Mismatch in res struct');
end
%% load and preprocess co-occurance data
clear Y
label=getMRCNoun;
%dendro=squeeze(mean(dmAll)); % get an data matrix average
wiki.dm_avg = squeeze(mean(wiki.dm));
% remove infrequent features
minThresh=25;
low_freq_inds = find(sum(wiki.dm_avg,1)<minThresh);
    wiki.dm_avg(:,low_freq_inds)=[];
    wiki.featwords(low_freq_inds) = [];
    wiki.dm(:,:,low_freq_inds) = [];
    
if corr32
   wiki.dmCorr_avg=squeeze(nanmean(wiki.dmCorr));
   drop_nouns = find(sum(wiki.dm_avg,2)<minThresh);
   wiki.dmCorr_avg(drop_nouns,:)=[];
   wiki.dmCorr_avg(:,drop_nouns)=[];
   wiki.dm(:,drop_nouns,:) = [];
   wiki.nouns(drop_nouns) = [];
   wiki.dmCorr(:,drop_nouns,:) = [];
   wiki.dmCorr(:,:,drop_nouns) = [];
   wiki.dm_avg(drop_nouns,:) = [];
else
    label(sum(wiki.dm_avg,2)<minThresh)=[];
    wiki.dm_avg(sum(wiki.dm_avg,2)<minThresh,:)=[];
end

if logAtAll  &~corr32
    wiki.dm_avg=log(wiki.dm_avg+1);
end

if rescaleFeaturebyFrequecy &~corr32
    wiki.dm_avg2=wiki.dm_avg./(repmat(mean(wiki.dm_avg),size(wiki.dm_avg,1),1));
    dm_wiki.dm_avg=[(wiki.dm_avg)+(wiki.dm_avg2)]/2;
    wiki.dm_avg=[corr(wiki.dm_avg')+corr(wiki.dm_avg2')]/2;
end
%% should not be necessary
nanind=find(isnan(wiki.dm_avg(1,:)));
if length(nanind)>0
    warning('manually stripping nans')
    wiki.dm_avg(:,nanind)=[];
    wiki.dm_avg(nanind,:)=[];
    label(nanind)=[];
end
%% Plot the figure
figure(1)
Y = get_triu(wiki.dmCorr_avg);
Z=linkage(1-Y, 'ward');%,{'correlation'} )
[H,clust,OUTPERM] =dendrogram(Z,60,'Labels',wiki.nouns','Colorthresh',1.5);
wiki.noun_clust = clust;
[H,T,OUTPERM] =dendrogram(Z,length(wiki.nouns),'Labels',wiki.nouns','Colorthresh',1.5);
nclust = length(unique(arrayfun(@(x) num2str(H(x).Color),1:length(H),'UniformOutput',0))');
wiki.noun_ord = OUTPERM(end:-1:1);
xtickangle(45)
pause(.1)

clear Y absScore absWord dm dmAll dmCorr featWords label MRCnoun 