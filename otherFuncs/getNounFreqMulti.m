clear



data=load('someDistancePyMulti');
targWords = data.sel_targWords;
dimWords = data.sel_dimWords;


[goodV goodA bestNouns]=myNiceAdjectivesandVerbs;
targWords=bestNouns;
% targWords=targWords(1:32);
nTarg=length(targWords);


nounDistance=ones(1,length(targWords))*999;


while 1
    %     for targ_i=1:nTarg
    
    
    startString=                'python ./google-ngrams-master/getngrams.py ';
    nPerTry=12;
    for targ_i=1:nPerTry:nTarg  %:30%length(dimWords)
        
        
        if nounDistance(targ_i)==999
            a=[];
            
            if targ_i+nPerTry-1>nTarg
                nPerTry=nTarg-targ_i+1;
                disp(['shortening nPerTry fpr target#:' num2str(targ_i)])
            end
            if  0% (sum(isDone(targ_i,targ_i:targ_i+nPerTry-1)==1)==nPerTry)% if SECTION not done
                %                     loopDistance(targ_i:targ_i+nPerTry-1)=someDistance(targ_i,targ_i:targ_i+nPerTry-1);
            else
                midSting=[];
                readLineFlag='%s';
                for withinJ=1:nPerTry;
                    if targ_i+withinJ>nTarg+1
                        
                        break
                    end
                    readLineFlag=[readLineFlag '%s'];
                    %  if loopIsDone(targ_i)~=1  % if value is missing
                    imageData=[];
                    midSting =[midSting lower(targWords{targ_i-1+withinJ})   '_NOUN,'];
                    
                    %   end
                end
                
                
                
            end
            
            
            endString=  [   ' -startYear=1960 -smoothing=0 -nosave  '];
            
            [status,result] = system([startString midSting endString]);
            
            
            
            %             [status,result] = system(['python ./google-ngrams-master/getngrams.py ' targWords{targ_i}  '_NOUN -startYear=1960 -smoothing=0 -nosave ']);
            if length(result)>4
                if strcmp(result(1:4),'year')
                    
                    
                    
                    ind=strfind(result,'1960');
                    result(1:ind-1)=[];%remove header row
                    a=textscan(result,readLineFlag,'Delimiter',',');
                    a(1)=[];% remove year;
                    
                    
                    if ~strcmp(a{end}{1},'')
                        %                         a={a{1}{2:end-2}};
                        %                         a=char(a);
                        %                         a=str2num(a(:,6:end));
                        
                        b=[];
                        for kk=1:size(a,2)
                            b(:,kk)=(str2num(char(a{kk})));
                        end
                        a=b;
                        
                        %                     header=a{1}{1};
                        %                     stStr=strfind(header,',')+1;
                        % endStr=strfind(header,'_NOUN')-1;
                        [junk ind]=sort(targWords(targ_i:targ_i-1+nPerTry)); % counter alpha sort
                        a(:,ind)=a;
                        
                        nounDistance(targ_i:targ_i-1+withinJ)=mean(a);
                        if isnan(nounDistance(targ_i))
                            fwefew
                            nounDistance(targ_i)=0;
                        end
                        disp('good')
                    else
                        disp('doing one by one')
                        for withinJ=1:nPerTry;
                            if targ_i+withinJ>nTarg+1
                                
                                break
                            end
                            [status,result] = system(['python ./google-ngrams-master/getngrams.py ' lower(targWords{targ_i-1+withinJ})  '_NOUN -startYear=1960 -smoothing=0 -nosave ']);
                            a=textscan(result,'%s%s');
                            a={a{1}{2:end-2}};
                            a=char(a);
                            a=str2num(a(:,6:end));
                            %                             loopDistance(dim_j-1+withinJ)=mean(a);
                            nounDistance(targ_i-1+withinJ)=mean(a);
                            if isnan( nounDistance(targ_i-1+withinJ))
                                nounDistance(targ_i-1+withinJ)=0;
                                
                                disp(['no value for:' targWords{targ_i-1+withinJ}   ])
                            else
                                
                                disp(['isGood:' targWords{targ_i-1+withinJ}   ])
                            end
                            %                             loopIsDone(dim_j-1+withinJ)=1;  % set to 'done'
                            
                            %                             disp(['done:' nouns{targ_i}  '-->' dimWords{dim_j-1+withinJ} ])
                            
                            
                        end
                    end
                else
                    warning('retrieval failure!!!!!!!!!')
                    %             loopIsDone(targ_i)=3;  % set to '3' = 'try again later'
                    result
                    nounDistance(targ_i:targ_i-1+withinJ)=999;
                    pause(4)
                end
            else
                nounDistance(targ_i:targ_i-1+withinJ)=999;
                warning('retrieval failure!!!!!!!!!')
                %         loopIsDone(targ_i)=3; % set to '3' = 'try again later'
                result
                pause(4)
            end
            %                     disp(['done:' targWords{targ_i} ])
        end
    end
    targ_i
    if ~any(nounDistance==999)
        break
    end
end
%         save nounDistance nounDistance;