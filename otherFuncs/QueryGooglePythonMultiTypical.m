close all
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

load someDistancePyMulti
dimWords=dimWords(mean(someDistance)>.00000001);
clear someDistance
% if fromScratch
%         searchString=['https://books.google.com/ngrams/graph?content=' nouns{targ_i} '_NOUN%3D%3E' dimWords{dim_j} '_ADJ&year_start=1800&year_end=2000&corpus=15&smoothing=3'];

% load isDone isDone
tic
nouns=textread('wordlist_typi_en_sortedTyp.txt','%s');

nTarg=length(nouns);
nDims=length(dimWords)
% isDone=zeros(nTarg,nDims);  % to reset (then save it)
load isDonePyMultiTyp isDone
load someDistancePyMultiTyp someDistance
extenddIsDone=zeros(nTarg,nDims);
extenddIsDone(1:size(isDone,1),1:size(isDone,2))=isDone;
isDone=extenddIsDone;
sel_targWords=nouns(1:nTarg); % for compariabilty with Yuans script
sel_dimWords=dimWords(1:nDims);
% isDone=isDone*0
while 1
for targ_i=1:nTarg
    %         if 1
    loopIsDone=isDone(targ_i,:);
    loopDistance=zeros(1,nDims);
    
    
    startString=                'python ./google-ngrams-master/getngrams.py ';
    nPerTry=3;
    for dim_j=1:nPerTry:nDims%:30%length(dimWords)
        
        
        if dim_j+nPerTry-1>nDims
            nPerTry=nDims-dim_j+1;
            disp(['shortening nPerTry fpr target#:' num2str(targ_i)])
        end
        if (sum(isDone(targ_i,dim_j:dim_j+nPerTry-1)==1)==nPerTry)% if SECTION not done
            loopDistance(dim_j:dim_j+nPerTry-1)=someDistance(targ_i,dim_j:dim_j+nPerTry-1);
        else
            midSting=[];
            readLineFlag='%s';
            for withinJ=1:nPerTry;
                if dim_j+withinJ>nDims+1
                    
                    break
                end
                readLineFlag=[readLineFlag '%s'];
                %  if loopIsDone(dim_j)~=1  % if value is missing
                imageData=[];
                midSting =[midSting nouns{targ_i}  '_NOUN@' dimWords{dim_j-1+withinJ} '_ADJ,'];
                
                %   end
            end
            
            
            endString=  [   ' -startYear=1960 -smoothing=0 -nosave '];
            
            [status,result] = system([startString midSting endString]);
            
            
            
            %                 drink=>*_NOUN
            if length(result)>4
                if strcmp(result(1:4),'year')
                    ind=strfind(result,'1960');
                    result(1:ind-1)=[];%remove header row
                    a=textscan(result,readLineFlag,'Delimiter',',');
                    a(1)=[];% remove year;
                    if ~strcmp(a{end}{1},'')
                        disp('doing chunk')
                        for withinJ=1:nPerTry;
                            if dim_j+withinJ>nDims+1
                                
                                break
                            end
                            loopDistance(dim_j-1+withinJ)=mean(str2num(char(a{withinJ})));
                            
                            loopIsDone(dim_j-1+withinJ)=1;  % set to 'done'
                            
                        end
                        
                        
                        if isnan(loopDistance(dim_j)-1+withinJ)
                            loopDistance(dim_j-1+withinJ)=0;
                        end
                    elseif strcmp(a{1}{1},'')
                            disp('all missing')
                             for withinJ=1:nPerTry;
                                  loopDistance(dim_j-1+withinJ)=0;
                                  loopIsDone(dim_j-1+withinJ)=1;
                             end
                        else
                        disp('doing one by one')
                        for withinJ=1:nPerTry;
                            if dim_j+withinJ>nDims+1
                                
                                break
                            end
                            [status,result] = system(['python ./google-ngrams-master/getngrams.py ' nouns{targ_i}  '_NOUN@' dimWords{dim_j-1+withinJ} '_ADJ -startYear=1960 -smoothing=0 -nosave ']);
                            a=textscan(result,'%s%s');
                            a={a{1}{2:end-2}};
                            a=char(a);
                            a=str2num(a(:,6:end));
                            loopDistance(dim_j-1+withinJ)=mean(a);
                            if isnan(loopDistance(dim_j-1+withinJ))
                                loopDistance(dim_j-1+withinJ)=0;
                                
                                disp(['no value for:' nouns{targ_i}  '-->' dimWords{dim_j-1+withinJ} ])
                            else 
                                
                            disp(['done:' nouns{targ_i}  '-->' dimWords{dim_j-1+withinJ} ])
                            end
                            loopIsDone(dim_j-1+withinJ)=1;  % set to 'done'
                            
                            
                            
                        end
                    end
                    
                end
                
                
                
            else
                warning('retrieval failure!!!!!!!!!')
                %                 loopIsDone(dim_j)=3;  % set to '3' = 'try again later'
                result
                pause(4)
            end
            
            
            
            
            isDone(targ_i,1:dim_j-1+nPerTry)=loopIsDone(1:dim_j-1+nPerTry);
            someDistance(targ_i,1:dim_j-1+nPerTry)=loopDistance(1:dim_j-1+nPerTry);
            
            subplot(1,3,1),      imagesc(isDone) ,subplot(1,3,2),        imagesc(log(someDistance)) ,subplot(1,3,3),        imagesc(someDistance>0)
            title(num2str(dim_j))
            drawnow
            save isDonePyMultiTyp isDone
            
            save someDistancePyMultiTyp someDistance sel_targWords sel_dimWords
        end
    end
 end   
   if sum(sum(isDone(1:nTarg,:))) == nTarg*size(isDone,2)
       break
   end

end



%                 else
%                     disp(['already done:' nouns{targ_i}  '-->' dimWords{dim_j} ])
%             end
