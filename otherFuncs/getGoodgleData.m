clear
% close all
% 1. Load data
matrixFolder = 'DataMatrices/';
creatingDate = '07-Apr-2016'
dmName = 'dm_EN-wform.w.5.cbow.neg10.400.subsmpl.txt.wordlist_mrc_CONC.mat';
% 'dm_EN-wform.w.2.ppmi.svd.500.txt.wordlist_mrc_CONC.mat';
% savedmName = [matrixFolder 'TESTreducedDM_' dmName '-' creatingDate '.mat'];

% dimWordType = 'AV-COMB';%'Adjs';'Verbs';%
% savedmName = [matrixFolder 'reducedDM_selTargNoun_fromTop' dimWordType '-' creatingDate '.mat'];
% data = load(savedmName);
data=load('someDistancePyMulti');
fieldname = fieldnames(data);
dm = data.(fieldname{1});
% dimWords = data.sel_dimWords;
targWords = data.sel_targWords;
dimWords = data.sel_dimWords;

% targWords=targWords(1:32+16);
% dimWords=dimWords(1:16);
% dm=dm(1:16,:);




% 2. Check the initial dengrogram, which can give a fair estimate of the
% natural clustering


 dm(83:end,:)=[];
 targWords(83:end,:)=[];
Y = pdist(dm,'correlation');
% figure();imagesc(squareform(Y));colorbar();
Z = linkage(Y, 'ward');
% clustering all 
% figure();

 
[H,T] = dendrogram(Z,size(dm,1),'Labels',targWords,...
    'Orientation','left','ColorThreshold',1.4 );

distanceStuffGoogle=dm;
%

load nounDistance
 load adjDistance
 
 dm(:,adjDistance==0)=[];
 dimWords(adjDistance==0)=[];
 adjDistance(adjDistance==0)=[];
 
 
 dimWords(find(mean(dm~=0)<.5))=[];
 adjDistance(find(mean(dm~=0)<.5))=[];
 dm(:,find(mean(dm~=0)<.5))=[];
 
 
%  nounDistance(find(mean(dm'~=0)<.5))=[];
 targWords(find(mean(dm'~=0)<.5))=[];
 dm(find(mean(dm'~=0)<.5),:)=[];
 
 disp('attention')
 for ii=1:length(nounDistance)
     for jj=1:length(adjDistance)
         normMat(ii,jj)=log(adjDistance(jj));%nounDistance(ii);%
%          normMat(ii,jj)=adjDistance(jj).*nounDistance(ii);%expect freq
     end
 end
 
 
%   dm=dm./normMat;
 
 figure
Y = pdist(dm,'correlation');
% figure();imagesc(squareform(Y));colorbar();
Z = linkage(Y, 'ward');
% clustering all 
% figure();
[H,T] = dendrogram(Z,size(dm,1),'Labels',targWords,...
    'Orientation','left','ColorThreshold',1.4 );


distanceStuffGoogle=dm;
