close all
% clear
%% 1. Read in data

figure
load stimuli

stim{1}=beach;
stim{2}=city;
stim{3}=mountain;
stim{4}=road;

for ii=2:4
    nouns=lower(stim{ii});
    
    
    nTarg=length(nouns);
    % isDone=isDone*0
    for targ_i=1:nTarg
        while 1
            canExit=false;
            %         if 1
            loopDistance=0;
            [status,result] = system([  'python ./google-ngrams-master/getngrams.py ' nouns{targ_i,1} '_ADJ ' nouns{targ_i,2}  '_NOUN,   -startYear=1980 -smoothing=0 -nosave '])
            
            %[status,result] = system([  'python ./google-ngrams-master/getngrams.py ' nouns{targ_i,2}  '_NOUN ' nouns{targ_i,1} '_ADJ,   -startYear=1960 -smoothing=0 -nosave ']);
            
            %                 drink=>*_NOUN
            if length(result)>4
                if strcmp(result(1:4),'year')
                    
                    a=textscan(result,'%s%s');
                    a={a{1}{2:end-2}};
                    a=char(a);
                    a=str2num(a(:,6:end));
                    loopDistance=mean(a);
                    if isnan(loopDistance)
                        loopDistance=0;
                    end
                    
                    canExit=true;
                    someDistance(ii,targ_i)=loopDistance(1);
                    
                else
                    warning('retrieval failure!!!!!!!!!')
                    %             pause(4)
                    
                end
            else
                warning('retrieval failure!!!!!!!!!')
                result
                %         pause(4)
            end
            
            
            
            
            disp([nouns{targ_i} ' ' num2str(loopDistance)])
            pause(5)
            
            
            someDistance(ii,targ_i)=loopDistance;
            errorbar(mean(someDistance'),std(someDistance')/8)
            drawnow
            if canExit
                break
            end
        end
    end
    % save isDonePyMultiTyp isDone
    
    % save someDistancePyMultiTyp someDistance sel_targWords sel_dimWords
end


%                 else
%                     disp(['already done:' nouns{targ_i}  '-->' dimWords{dim_j} ])
%             end
