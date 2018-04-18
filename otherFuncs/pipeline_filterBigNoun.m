%% Mar 17 2016 SLF, minor modification by Yuan
% /Users/yuantao/Google Drive/WP2.2
% "big nouns": all concrete words from MRC database (1138) with the most frequent
% dimension words from bnc-wiki-wacky
% i.e. dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topVerbs.mat 1866 
%      dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topAdjs.mat 1988
%      dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topNouns.mat
% 
% Compare to random cluctering to see size effect
% Remove selected items based on the row sum and the column sum of the co-occurrence dense matrix
% And remove specified words/categories
% Mar 17 Sec 2.2, use [junk ind]=sort(sum(dm,2)) instead of turnining values into 1 or 0;
%        Same for the columns
% Mar 23 2016 + topAdjs and topNouns datasets
% Apr 1 2016 Created reduce matrices by Yuan:
% reducedDM_selTargNoun_fromTopAV-COMB-29-Mar-2016.mat
% reducedDM_selTargNoun_fromTopAVN-COMB-29-Mar-2016.mat
% reducedDM_selTargNoun_fromTopAdjs-28-Mar-2016.mat
% reducedDM_selTargNoun_fromTopVerbs-30-Mar-2016.mat

%% SLF mods, 21/3/16. 
% addeped wordlists to output i.e.:
%   save(savedmName,'dm_red','sel_targWords','sel_dimWords');
warning('off','stats:linkage:NotEuclideanMatrix');
warning('off','stats:linkage:NotEuclideanMethod')

clear all
%% 1. Read in data
matrixFolder = 'DataMatrices/';

% A. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dimWordType = 'Verbs';
% dense matrix (dm) and corresponding target words (nouns, row) 
% and dimension words (column)
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
targWords = textread('./DataMatrices/wordlist_mrc_CONC','%s');
targWords = targWords';

[dimWords, freq] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords = dimWords';
[n_targWords, n_dimWords] = size(dm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMBINED ADJ-VERB MODEL
matrixFolder = 'DataMatrices/';
dimWordType = 'Adjs';
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
dm_a = dm;
[dimWords, freq] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords_a = dimWords';

dimWordType = 'Verbs';
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
dm_v = dm;
[dimWords, freq] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords_v = dimWords';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMBINE NOUNS TOO
% 1100 OF THEM ARE ALSO ADJ OR NOUN
dimWordType = 'Nouns';
load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
dm_n = dm;
[dimWords, freq] = textread([matrixFolder 'top' dimWordType],'%s%d');
dimWords_n = dimWords';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dm = [dm_a,dm_v,dm_n];
targWords = textread('./DataMatrices/wordlist_mrc_CONC','%s');
targWords = targWords';
dimWords = [dimWords_a,dimWords_v,dimWords_n];

% THUS
[dimWords, ia] = unique(dimWords);
dm = dm(:,ia);
[n_targWords n_dimWords] = size(dm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B. ABSTRACT DIMENSION MATRIX %%%%
load([matrixFolder 'dm_EN-wform.w.5.cbow.neg10.400.subsmpl.txt.wordlist_mrc_CONC.mat']);
%     dm_EN-wform.w.2.ppmi.svd.500.txt.wordlist_mrc_CONC.mat']);
targWords = textread('./DataMatrices/wordlist_mrc_CONC','%s');
targWords_red = targWords';
dm_red = dm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Reduce rows and columns
% 2.1. reduce set-size nouns (row)
% NB Skip this from abstrace dimension matrices: dm_red = dm;targWords_red = targWords
% Calculate sum of each row and sort
% Keep the top N ones
[junk ind] = sort(sum(dm,2),'descend');
% CHECKING
targWords(ind(end-50:end))

N = 500;
% disp(prctile(junk,75));
targWords_red = targWords(ind(1:N)); % The N selected target words
% AND THE REDUCED MATRIX
dm_red = dm(ind(1:N),:);

% 2.2. reduce set-size verbs (column)
% Likewise, calculate sum of each column and sort
% Keep the top N_dim ones
%[junk ind] = sort((sum(dm_verb~=0,1))./log(Freq),'descend');
[junk ind] = sort(sum(dm,1),'descend');
N_dim = 400;
sel_dimWords = dimWords(ind(1:N_dim)); % The N selected target words
dm_red = dm_red(:,ind(1:N_dim));
disp(size(dm_red));
% % PRINT THE NEWLY SELECTED WORDS
% savefileName = [matrixFolder 'selTop' dimWordType num2str(N_dim) '-' date] 
% fid = fopen(savefileName,'w');
% for i = 1:length(sel_dimWords)
%     fprintf(fid,[sel_dimWords{i} '\n']);
% end
% fclose(fid);


%% Remove single nouns
blackList = {'AERIAL','SEMEN','YOLK'}%}; %might keep growing
killer = []; % THINGS INSIDE WILL BE KILLED
for iBL = 1:length(blackList)
    killer = [killer find(strcmp(blackList{iBL}, targWords_red))];
end
sel_targWords = targWords_red(setdiff(1:length(targWords_red),killer));
length(sel_targWords)

dm_red_sel = dm_red(setdiff(1:size(dm_red,1),killer),:);
disp(size(dm_red_sel));

%% Visualise dengrogram
Y = pdist(dm_red_sel,'correlation');
Z = linkage(Y, 'ward');%,{'correlation'} );
% clustering all 
[H,T] = dendrogram(Z,size(dm_red_sel,1),'Labels',sel_targWords,...
    'Orientation','left','ColorThreshold',1.8);
% or
T = cluster(Z,'cutoff',1.8,'criterion','distance');
disp(max(T));
T = cluster(Z,'maxclust',60);
for ic = 1:max(T)
    words = lower(sel_targWords(find(T==ic)));
    fprintf('\n%u Cluster with %u items\n',ic,length(words));
    for iw = 1:length(words)
       fprintf([words{iw} ' ']);
    end
end


%% REMOVE NOUNS BASED ON TARGET VECTOR
% *They are in fact poorly co-occur with VERBS*
% *observed bad choices: 'CHILDREN'-- will remove animals
excludeKeys{1,:} = {'FATHER','MOTHER','UNCLE','LAWYER','DOCTOR','STUDENT',...
    'BANKER','BOY','GIRL'};
excludeKeys{2,:} = {'HOUSE','PRISON','COURT','CITY','CHURCH'};
excludeKeys{3,:} = {'AISLE','POND','LAWN'};
excludeKeys{4,:} = {'ANKLE','ELBOW','THROAT','EYE'};
% find targets and assoicates - arbitrary cluster thresh could be imporved
killer = [];
for kk = 1:size(excludeKeys,1)
    remove_targets = excludeKeys{kk,:};
    Y = pdist(dm_red_sel,'correlation');
    Z = linkage(Y, 'ward');%,{'correlation'} )
    % PROBABLY NEEDS ADJUST, SMALLER CLUSTERS SHOULD BE BETTER
    T = cluster(Z,'maxclust',60);
    %T = cluster(Z,'cutoff',1.6,'criterion','distance');
    for iCluster = 1:length(unique(T))
        % Find the cluster(s) which contain the excluded keys
        % Return 0 OR 1 of each target item
        locat = ismember(remove_targets,{sel_targWords{find(T==iCluster)}});
        % REMOVE ITEMS IN THE CLUSTER FROM THE MATRIX
        % IF, 1) MORE THAN 50% OF THE TARGETS ARE FOUND IN THIS CLUSTER
        %     2) FOUND EVEN JUST ONE 
        if sum(locat) > 0%length(remove_targets)*.5
            targInd = find(T==iCluster);
            fprintf('Cluster %d ',iCluster);
            fprintf('contains %s\n',remove_targets{locat});
            fprintf('Remove %d items\n',length(targInd));
            disp(sel_targWords(find(T==iCluster)));
            killer = [killer; targInd];          
        end
    end
end

% now clear
sel_targWords(killer) = [];disp(length(sel_targWords));
dm_red_sel(killer,:) = []; %CLEAR VERBS TOO?
disp(size(dm_red_sel));

% % PRINT THE NEWLY SELECTED TARGET NOUNS
% savefileName = [matrixFolder 'selTargNoun_fromTop' dimWordType '-' date] 
% fid = fopen(savefileName,'w');
% for i = 1:length(sel_targWords)
%     fprintf(fid,[sel_targWords{i} '\n']);
% end
% fclose(fid);

% dimWordType = 'Verbs';
dmName = 'dm_EN-wform.w.5.cbow.neg10.400.subsmpl.txt.wordlist_mrc_CONC.mat'
% savedmName = [matrixFolder 'reducedDM_selTargNoun_fromTop' dimWordType '-' date '.mat']
savedmName = [matrixFolder 'reducedDM_' dmName '-' date '.mat']
save(savedmName,'dm_red_sel','sel_targWords');%,'sel_dimWords');


