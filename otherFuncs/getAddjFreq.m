clear
data=load('someDistancePy');
targWords = data.sel_targWords;
dimWords = data.sel_dimWords;

targWords=targWords(1:32);
targWords=dimWords;
adjDistance=ones(1,length(targWords))*999
nTarg=length(targWords);
while 1
    for targ_i=1:nTarg
        if adjDistance(targ_i)==999
            [status,result] = system(['python ./google-ngrams-master/getngrams.py ' targWords{targ_i}  '_ADJ -startYear=1960 -smoothing=0 -nosave ']);
            if length(result)>4
                if strcmp(result(1:4),'year')
                    
                    a=textscan(result,'%s%s');
                    a={a{1}{2:end-2}};
                    a=char(a);
                    a=str2num(a(:,6:end));
                    adjDistance(targ_i)=mean(a);
                    if isnan(adjDistance(targ_i))
                        adjDistance(targ_i)=0;
                    end
                    
                else
                    warning('retrieval failure!!!!!!!!!')
                    %             loopIsDone(dim_j)=3;  % set to '3' = 'try again later'
                    result
                    adjDistance(targ_i)=999;
                    pause(4)
                end
            else
                adjDistance(targ_i)=999;
                warning('retrieval failure!!!!!!!!!')
                %         loopIsDone(dim_j)=3; % set to '3' = 'try again later'
                result
                pause(4)
            end
            disp(['done:' targWords{targ_i} ])
        end
    end
        if ~any(adjDistance==999)
            break
        end
end
    
save adjDistance adjDistance;