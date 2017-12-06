
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to load wiki within sentence co-occurance counts
% impliment differnt preprocessing steps for compariosn
% output clustering
% this goal is to decide on nice stable paramaters to take to feature based
% dimension-specifc siliarity spaces (Josine) and smart, sensitive heiratchical
% clustering (Aidas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% boleans to impliment differnt pre-processing
enableFeaureSelect=false; % specify subset of features via 'keepWords'
corr32=true; % create 32 different DSMs then average t eh r values
% or averaged/sum all the data then caluclate the DSM
logEarly=true; % do a log trasnfrom for each subset prior to corr - only relevent if corr32 is true
logAtAll=true; %log the data matrix (if corr32 is false). pretty standard and sensible step
rescaleFeaturebyFrequecy=true; %scale e.g. 'the verb to be' so that is does not dominate the model. NB this is applied in a very weird way
% minThresh=25; has been hardcoded here. I prefer to soft code if we will
% be lokking at different feautres spaces etc (and in general). BUT, 25 for
% now

%% todo
% double check the feature labels are correct. I supsect some quick fixes we
% implimented that look bad but actually work -slf

%% loading words from text files - this cannot really change

topVerb=getVerb;
topNouns=gettopNouns;
topAdjs=gettopAdjs;


featWords=[];
for ii=1:length(topVerb)
    featWords{end+1}=[topVerb{ii} '-v'];
end
for ii=1:length(topAdjs)
    featWords{end+1}=[topAdjs{ii} '-a'];
end
for ii=1:length(topNouns)
    featWords{end+1}=[topNouns{ii} '-n'];
end
%

MRCnoun=getMRCNoun;

for ii=1:length(MRCnoun)
    MRCnoun{ii}=[MRCnoun{ii} '-n'];
end
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
%%




%% select features
if enableFeaureSelect
keepWords={'red-a','blue-a','green-a'}
%%
keepInd=[];
for i=1:length(keepWords)
    keepInd=[keepInd find(strcmp(featWords,keepWords{i}))];
end
end

%% load 32 wiki generate data matrices
%% generate both raw Data Martices and corr32  DSMs
for ii=1:32
    
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
%% load and preprocess co-occurance data
clear Y
label=getMRCNoun;
dendro=squeeze(mean(dmAll)); % get an data matrix average

% remove infrequent features
minThresh=25;
dendro(:,sum(dendro,1)<minThresh)=[];


if corr32
    dendro3=squeeze(nanmean(dmCorr));
    dendro3(sum(dendro,2)<minThresh,:)=[];
    dendro3(:,sum(dendro,2)<minThresh)=[];
    label(sum(dendro,2)<minThresh)=[];
    dendro=dendro3;
else
    % remove infrequent targets (nouns)
    label(sum(dendro,2)<minThresh)=[];
    dendro(sum(dendro,2)<minThresh,:)=[];
end

if logAtAll  &~corr32
    dendro=log(dendro+1);
end

if rescaleFeaturebyFrequecy &~corr32
    dendro2=dendro./(repmat(mean(dendro),size(dendro,1),1));
    dm_dendro=[(dendro)+(dendro2)]/2;
    dendro=[corr(dendro')+corr(dendro2')]/2;
end

%% should not be necessary
nanind=find(isnan(dendro(1,:)));
if length(nanind)>0
    warning('manually stripping nans')
    dendro(:,nanind)=[];
    dendro(nanind,:)=[];
    label(nanind)=[];
end

figure
cc=0;for ii=1:size(dendro,1);for jj=ii+1:size(dendro,2),cc=cc+1;Y(cc)=dendro(ii,jj);end;end
Z=linkage(1-Y, 'ward');%,{'correlation'} )
[H,T,OUTPERM] =dendrogram(Z,length(label),'Labels',label','Colorthresh',1.5);
pause(.1)
save('/Users/aidasaglinskas/Desktop/OUTPERM_SLF.mat','OUTPERM')