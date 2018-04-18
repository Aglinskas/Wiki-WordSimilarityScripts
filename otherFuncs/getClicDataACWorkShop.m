%% add bit to include only grid AND blue line (get rig of label
tic
clear dm

% 1. Read in data
matrixFolder = 'DataMatrices/';
dimWordType = 'Adjs1000';
verbsType = 'Verbs1000';

[verbWords, freq] = textread([matrixFolder 'dimWords_top' verbsType],'%s%d');
[verbWords ind]=sort(verbWords);
freq(ind)=freq;

[dimWords, freq] = textread([matrixFolder 'dimWords_top' dimWordType],'%s%d');
[dimWordsADJ ind]=sort(dimWords);
freq(ind)=freq;
%

[goodV goodA bestNouns]=myNiceAdjectivesandVerbs;


nouns = lower(bestNouns(1:128));

load([matrixFolder 'dm_topVerbs-EN-wform.w.2.ppmi.txt_topNouns'  '.mat']);
                   


if 1%strcmp(verbsType , 'Verbs1000')
     goodTarg=targWordso;goodDim=dimWordso;
elseif 0
    goodTarg=goodV;goodDim=goodA;
else
    goodTarg=goodA;goodDim=goodV;
end

killTarg=[];
for ii=1:length(verbWords)
    if any(strcmp(verbWords{ii},goodTarg))
        disp(verbWords{ii})
    else
        killTarg=[killTarg ii];
    end
end

killDim=[];
for ii=1:length(dimWordsADJ)
    if any(strcmp(dimWordsADJ{ii},goodDim))
         disp(dimWordsADJ{ii})
    else
        killDim=[killDim ii];
    end
end

verbWords(killTarg)=[];
dimWordsADJ(killDim)=[];

%

% if fromScratch

matrixFolder = 'DataMatrices/';
dimWordType = 'Adjs';
%load([matrixFolder 'dm_EN-wform.w.5.sm.wordlist_mrc_CONC_top' dimWordType '.mat']);
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
%dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topAdjs.mat
%  dm_EN-wform.w.5.sm.wordlist_mrc_CONC_topAdjs.mat
% dm_a = dm;
[dimWords, freq_a] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords_a = dimWords';
[grrr] = textread('./DataMatrices/wordlist_mrc_CONC','%s');%([matrixFolder 'top' dimWordType],'%s%d');
dimWords_nouns = lower(grrr);

for noun_i=1:length(targWords)
    for adj_j=1:length(dimWordsADJ)
         rowInd=find(strcmp(targWords{noun_i},dimWords_nouns));
          colInd=find(strcmp(dimWordsADJ{adj_j},dimWords_a));
        distanceStuffCLIC(noun_i,adj_j)=dm(rowInd,colInd);
    end
end
        
        
% % %         
% % %         disp('ATTENTION CORR-ING THE CORR!!!')
% % % Y = pdist(corr(distanceStuffCLIC'),'correlation');
% % % % figure();imagesc(squareform(Y));colorbar();
% % % Z = linkage(Y, 'ward');
% % %         
% % % [H,T] = dendrogram(Z,size(distanceStuffCLIC,1),'Labels',nouns(1:size(distanceStuffCLIC,1)),...
% % %     'Orientation','left','ColorThreshold',1.4 );
% % %         