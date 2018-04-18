%% take the good words from their coccurance with nouns then determine the verb/adj semantic structure
warning('off','stats:linkage:NotEuclideanMatrix');
close all
clear all
%% 1. Read in data
matrixFolder = 'DataMatrices/';

% dimWordType = 'Verbs1000';
% targWordType = 'Adjs1000';
dimWordType = 'Adjs';
targWordType = 'Verbs';

flipDM=false;
if strcmp(targWordType , 'Adjs')
    flipDM=true;
end
% load([matrixFolder 'dm_topVerbs-EN-wform.w.2.ppmi.txt_topNouns'  '.mat']);

load([matrixFolder 'dm_topVerbs-EN-wform.w.2.ppmi.txt_top' dimWordType '.mat']);

if flipDM
    dm=dm';
end
[targWords, freq] = textread([matrixFolder 'top' targWordType],'%s%d');
disp('IS THIS RIGHT???')
disp('alpha sorting adjectives')
[targWords ind]=sort(targWords);
freq(ind)=freq;
targWords = targWords';

% dimWords_a = dimWords';
[n_targWords, n_dimWords] = size(dm);


[dimWords, freq] = textread([matrixFolder 'top' dimWordType],'%s%d');
% disp('IS THIS RIGHT???')
% disp('alpha sorting adjectives')
% [dimWords ind]=sort(dimWords);
% freq(ind)=freq;
dimWords_a = dimWords';
%

% % THUS
% [dimWords, ia] = unique(dimWords);
% dm = dm(:,ia);
[n_targWords n_dimWords] = size(dm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
auditInd=find(strcmp(targWords,'brake'));
%% 2. Reduce rows and columns
% 2.1. reduce set-size nouns (row)
% Calculate sum of each row and sort
% Keep the top N ones
%%%[junk ind] = sort(sum(dm,2),'descend');
%%%%N = 100;
% disp(prctile(junk,75));

[goodV goodA]=myNiceAdjectivesandVerbs;

if strcmp(targWordType , 'Verbs')
    goodTarg=goodV;goodDim=goodA;
else
    goodTarg=goodA;goodDim=goodV;
end


killTarg=[];
for ii=1:length(targWords)
    if any(strcmp(targWords{ii},goodTarg))
        disp(targWords{ii})
    else
        killTarg=[killTarg ii];
    end
end

killDim=[];
for ii=1:length(dimWords)
    if any(strcmp(dimWords{ii},goodDim))
    else
        killDim=[killDim ii];
    end
end

targWords(killTarg)=[];
dm(killTarg,:)=[];
dimWords_a(killDim)=[];
dm(:,killDim)=[];


auditInd2=find(strcmp(targWords,'brake'))

targWords_red = targWords; % The N selected target words
% AND THE REDUCED MATRIX
dm_red = dm;


% 2.2. reduce set-size verbs (column)
% Likewise, calculate sum of each column and sort
% Keep the top N_dim ones
%[junk ind] = sort((sum(dm_verb~=0,1))./log(Freq),'descend');
[junk ind] = sort(sum(dm,1),'descend');
N_dim = 600;
sel_dimWords = dimWords_a ;% The N selected target words

% % PRINT THE NEWLY SELECTED WORDS
% savefileName = [matrixFolder 'selTop' dimWordType num2str(N_dim) '-' date]
% fid = fopen(savefileName,'w');
% for i = 1:length(sel_dimWords)
%     fprintf(fid,[sel_dimWords{i} '\n']);
% end
% fclose(fid);


killEmpty=find(sum(dm_red,2)==0);
targWords_red(killEmpty)
dm_red(killEmpty,:)=[];
targWords_red(killEmpty)=[];
%% Visualise dengrogram
Y = pdist(dm_red,'correlation');
Z = linkage(Y, 'ward');%,{'correlation'} );
% clustering all
[H,T] = dendrogram(Z,size(dm_red,1),'Labels',targWords_red,...
    'Orientation','left','ColorThreshold',1.8);
% or
T = cluster(Z,'cutoff',1.4,'criterion','distance');
disp(max(T));
T = cluster(Z,'maxclust',60);
for ic = 1:max(T)
    words = lower(targWords_red(find(T==ic)));
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
excludeKeys{2,:} = {'HOUSE','PRISON','COURT'};
excludeKeys{3,:} = {'AISLE','POND','LAWN'};
excludeKeys{4,:} = {'ANKLE','ELBOW','THROAT','EYE'};
% find targets and assoicates - arbitrary cluster thresh could be imporved
killer = [];
for kk = 1:size(excludeKeys,1)
    remove_targets = excludeKeys{kk,:};
    Y = pdist(dm_red,'correlation');
    Z = linkage(Y, 'ward');%,{'correlation'} )
    % PROBABLY NEEDS ADJUST, SMALLER CLUSTERS SHOULD BE BETTER
    T = cluster(Z,'maxclust',60);
    %T = cluster(Z,'cutoff',1.6,'criterion','distance');
    for iCluster = 1:length(unique(T))
        % Find the cluster(s) which contain the excluded keys
        % Return 0 OR 1 of each target item
        locat = ismember(remove_targets,{targWords_red{find(T==iCluster)}});
        % REMOVE ITEMS IN THE CLUSTER FROM THE MATRIX
        % IF, 1) MORE THAN 50% OF THE TARGETS ARE FOUND IN THIS CLUSTER
        %     2) FOUND EVEN JUST ONE
        if sum(locat) > 0%length(remove_targets)*.5
            targInd = find(T==iCluster);
            fprintf('Cluster %d ',iCluster);
            fprintf('contains %s\n',remove_targets{locat});
            fprintf('Remove %d items\n',length(targInd));
            disp(targWords_red(find(T==iCluster)));
            killer = [killer; targInd];
        end
    end
end


%%

    Y = pdist(dm_red,'correlation');
    Z = linkage(Y, 'ward');%,{'correlation'} )
T = cluster(Z,'cutoff',2,'criterion','distance');
    [S H]=silhouette(dm_red, T,'correlation');
killer=find(S<0);
% now clear
targWords_red(killer) = [];disp(length(targWords_red));
dm_red(killer,:) = []; %CLEAR VERBS TOO?
disp(size(dm_red));
    
% % PRINT THE NEWLY SELECTED TARGET NOUNS
% savefileName = [matrixFolder 'selTargNoun_fromTop' dimWordType '-' date]
% fid = fopen(savefileName,'w');
% for i = 1:length(targWords_red)
%     fprintf(fid,[targWords_red{i} '\n']);
% end
% fclose(fid);



    Y = pdist(dm_red,'correlation');
    Z = linkage(Y, 'ward');%,{'correlation'} )
   [H,T] = dendrogram(Z,size(dm_red,1),'Labels',targWords_red,...
    'Orientation','left','ColorThreshold',1.8);




   [H,T] = dendrogram(Z,8,'Labels',targWords_red,...
    'Orientation','left','ColorThreshold',1.8);

savedmName = [matrixFolder 'reducedDM_selTargAdjVerb_fromTop' dimWordType '-' date '.mat']
% save(savedmName,'dm_red','targWords_red','sel_dimWords');
% 
% 
%    [H,T] = dendrogram(Z,5,'Labels',targWords_red,...
%     'Orientation','left','ColorThreshold',1.8);

%save words for next stage
for ii=1:max(T)
 labelsOut{ii}=targWords_red(find(T==ii));
end
%%
   [H,T] = dendrogram(Z,size(dm_red,1),'Labels',targWords_red,...
    'Orientation','left','ColorThreshold',2.25);
save (['labelsOut_' dimWordType],'labelsOut')
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [5 15]);
print(gcf, '-dpng', '-r500', [savedmName(1:end-3) 'png'])

