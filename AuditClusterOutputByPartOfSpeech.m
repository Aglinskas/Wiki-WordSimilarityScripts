old=[];
% while 1
%   try
clear

% system('scp scott.fairhall@lnif-cluster.unitn.it:~/matlab/Corpi/doneSoFarRandSamp*.mat ./clusterOut/')

topVerb=getVerb;
topNouns=gettopNouns;
topAdjs=gettopAdjs;
% 
% topAdjs=topAdjs(1:2:end);
% topNouns=topNouns(1:2:end);

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
for ii=1:length(MRCnoun)
    featWords(find(strcmp(MRCnoun(ii),featWords)))=[];
end

load absFreq8435features
freqThresh=500;
for ii=length(featWords):-1:1
   
    if absScore(find(strcmp(featWords{ii},absWord)))<freqThresh 
featWords(ii)=[];
    end
end


for ii=1:32

load(['./clusterOut/doneSoFarRandSamp_' num2str(ii) '.mat'])
% load(['./clusterOut/doneSoFar_' num2str(ii) '.mat'])
    %     load(['/Volumes/scott.fairhall-1/matlab/Corpi/doneSoFar_' num2str(ii) '.mat'])
    dmAll(ii,:,:)=dm;
   
% dm(:,sum(dm,1)<1)=[];
dmCorr(ii,:,:)=corr(dm');
end
%     imagesc(log(squeeze(mean(dmAll))));
%     colorbar
disp('done')
%%
figure
clear Y
label=getMRCNoun;
%label=label(1:size(dendro,1));
dendro=squeeze(mean(dmAll));
minThresh=25;


dendro(:,sum(dendro,1)<minThresh)=[];


dendro3=squeeze(nanmean(dmCorr));
dendro3(sum(dendro,2)<minThresh,:)=[];
dendro3(:,sum(dendro,2)<minThresh)=[];

label(sum(dendro,2)<minThresh)=[];
featWords(sum(dendro,2)<minThresh)=[];

dendro(sum(dendro,2)<minThresh,:)=[];
dendro2=dendro./(repmat(mean(dendro),size(dendro,1),1));

%
type=[];
for ii=1:length(featWords)
  type(ii)=featWords{ii}(end);
end
    vrbInd=strfind(type,'v');
    adjInd=strfind(type,'a');
    nounInd=strfind(type,'n');
    
    dendroV=[corr(dendro(:,vrbInd)')+corr(dendro2(:,vrbInd)')]/2;
    
    dendroA=[corr(dendro(:,adjInd)')+corr(dendro2(:,adjInd)')]/2;
    
    dendroN=[corr(dendro(:,nounInd)')+corr(dendro2(:,nounInd)')]/2;
    
    
    dendro=[corr(dendro')+corr(dendro2')]/2;
    %%
% dendro=dendro3;
dendro=[dendroV+dendroN+dendroA]/3;
nanind=find(isnan(dendro(1,:)));
if length(nanind)>0
    warning('manually stripping nans')
    dendro(:,nanind)=[];
    dendro(nanind,:)=[];
label(nanind)=[];
end
cc=0;for ii=1:size(dendro,1);for jj=ii+1:size(dendro,2),cc=cc+1;Y(cc)=dendro(ii,jj);end;end
Z=linkage(1-Y, 'ward');%,{'correlation'} )
  [H,T,OUTPERM] =dendrogram(Z,length(Z),'Labels',label','Colorthresh',1.5);
pause(.1)
% if isempty(old)
%     old=squeeze(mean(dmAll));
% else
%     max(max(abs(old-squeeze(mean(dmAll)))))
%     old=squeeze(mean(dmAll));
% end
% end