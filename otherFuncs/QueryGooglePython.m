
clear
%% 1. Read in data
matrixFolder = 'DataMatrices/';
dimWordType = 'Adjs1000';
verbsType = 'Verbs1000';

[verbWords, freq] = textread([matrixFolder 'dimWords_top' verbsType],'%s%d');
[verbWords ind]=sort(verbWords);
freq(ind)=freq;

[dimWords, freq] = textread([matrixFolder 'dimWords_top' dimWordType],'%s%d');
[dimWords ind]=sort(dimWords);
freq(ind)=freq;
%

[goodV goodA bestNouns]=myNiceAdjectivesandVerbs;

nouns = lower(bestNouns);




if 1%strcmp(verbsType , 'Verbs1000')
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
for ii=1:length(dimWords)
    if any(strcmp(dimWords{ii},goodDim))
    else
        killDim=[killDim ii];
    end
end

verbWords(killTarg)=[];
dimWords(killDim)=[];

%

% if fromScratch
%         searchString=['https://books.google.com/ngrams/graph?content=' nouns{targ_i} '_NOUN%3D%3E' dimWords{dim_j} '_ADJ&year_start=1800&year_end=2000&corpus=15&smoothing=3'];

% load isDone isDone
tic


nTarg=64+8
nDims=length(dimWords)
% isDone=zeros(nTarg,nDims);  % to reset (then save it)
load isDonePy isDone
load someDistancePy someDistance
extenddIsDone=zeros(nTarg,nDims);
extenddIsDone(1:size(isDone,1),1:size(isDone,2))=isDone;
isDone=extenddIsDone;
sel_targWords=nouns(1:nTarg); % for compariabilty with Yuans script
sel_dimWords=dimWords(1:nDims);
% isDone=isDone*0
while 1
    for targ_i=1:nTarg
        loopIsDone=isDone(targ_i,:);
        loopDistance=zeros(1,nDims);
        for dim_j=1:nDims%:30%length(dimWords)
            if loopIsDone(dim_j)~=1  % if value is missing
                imageData=[];
                [status,result] = system(['python ./google-ngrams-master/getngrams.py ' nouns{targ_i}  '_NOUN@' dimWords{dim_j} '_ADJ -startYear=1960 -smoothing=0 -nosave ']);
             
%                 drink=>*_NOUN
                if length(result)>4
                    if strcmp(result(1:4),'year')
                        
                        a=textscan(result,'%s%s');
                        a={a{1}{2:end-2}};
                        a=char(a);
                        a=str2num(a(:,6:end));
                        loopDistance(dim_j)=mean(a);
                        if isnan(loopDistance(dim_j))
                            loopDistance(dim_j)=0;
                        end
                        loopIsDone(dim_j)=1;  % set to 'done'
                        
                        disp(['done:' nouns{targ_i}  '-->' dimWords{dim_j} ])
                        
                        isDone(targ_i,1:dim_j)=loopIsDone(1:dim_j);
                        save isDonePy isDone
                        
                        someDistance(targ_i,dim_j)=loopDistance(dim_j);
                        save someDistancePy someDistance sel_targWords sel_dimWords
                        
                    else
                        warning('retrieval failure!!!!!!!!!')
                        loopIsDone(dim_j)=3;  % set to '3' = 'try again later'
                        result
                        pause(4)
                    end
                else
                    warning('retrieval failure!!!!!!!!!')
                    loopIsDone(dim_j)=3; % set to '3' = 'try again later'
                    result
                    pause(4)
                end
                subplot(1,2,1),      imagesc(isDone) ,subplot(1,2,2),        imagesc(someDistance)
                drawnow
            else
                disp(['already done:' nouns{targ_i}  '-->' dimWords{dim_j} ])
            end
        end
        
        toc
        
    end
    if sum(isDone(:)==3)==0
        break
    end
end
