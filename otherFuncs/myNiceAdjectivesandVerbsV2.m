 function [dimWords_v dimWords_a bestNouns]=myNiceAdjectivesandVerbs

nToKeep=400;
% matrixFolder = 'DataMatrices/';
% dimWordType = 'Verbs';
% % dense matrix (dm) and corresponding target words (nouns, row) 
% % and dimension words (column)
% load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
% targWords = textread('./DataMatrices/wordlist_mrc_CONC','%s');
% targWords = targWords';
% 
% [dimWords, freq] = textread([matrixFolder 'top' dimWordType],'%s%d');
% dimWords = dimWords';
% [n_targWords, n_dimWords] = size(dm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMBINED ADJ-VERB MODEL
matrixFolder = 'DataMatrices/';
dimWordType = 'Adjs';
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
dm_a = dm;
[dimWords, freq_a] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords_a = dimWords';

dimWordType = 'Verbs';
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
dm_v = dm;
[dimWords, freq_v] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords_v = dimWords';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMBINE NOUNS TOO
% 1100 OF THEM ARE ALSO ADJ OR NOUN
dimWordType = 'Nouns';
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
dm_n = dm;
[targWords] = textread('./DataMatrices/wordlist_mrc_CONC','%s');%([matrixFolder 'top' dimWordType],'%s%d');
dimWords_n = dimWords';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dm = [dm_a,dm_v,dm_n];
% targWords = textread('./DataMatrices/wordlist_mrc_CONC','%s');
% targWords = targWords';
% dimWords = [dimWords_a,dimWords_v,dimWords_n];

% dm_verb=dm_topVerbs;
%%
% reduce set-size nouns
[junk ind]=sort(sum(dm_a==0,2));
kill=ind(601:end);

bestNouns=targWords(ind);
targWords(kill)=[];
dm_v(kill,:)=[];
dm_a(kill,:)=[];

% reduce set-size verbs
[junk ind]=sort((sum(dm_v~=0,1))./log(freq_v)','descend');
% [junk ind]=sort(sum(dm_verb==0,1));
kill=ind(nToKeep+1:end);%find(sum(dm_verb==0,1)>size(dm_verb,1)*.8);
dimWords_v(kill)=[];
dm_v(:,kill)=[];

% reduce set-size adj
[junk ind]=sort((sum(dm_a~=0,1))./log(freq_a)','descend');
% [junk ind]=sort(sum(dm_verb==0,1));
kill=ind(nToKeep+1:end);%find(sum(dm_verb==0,1)>size(dm_verb,1)*.8);
dimWords_a(kill)=[];
dm_a(:,kill)=[];
% |



