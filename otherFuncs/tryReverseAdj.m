%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%          choose the words via the file at line 7 (e.g. typNouns)
%%          use the graph to interpret
%%          save 'uWord' and 'score' if you like the results 
%%          you can interupt and start again - it wil fill in the blamks
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

% load typNouns  % this is the input file
% List_itemsXcategory_26ago16;
A=uWord(ind(1:sum(score>3)));
word=[];
if 1%~exist('done')
done=zeros(1,length(A));
end
fwd=false;
while true
    for targ_i=1:length(A)
        if ~done(targ_i)
            if fwd
           [status,result] = system(['python ./google-ngrams-master/getngrams.py ' lower(A{targ_i})  '@*_ADJ -startYear=1960 -smoothing=0 -nosave ']);
            else
                [status,result] = system(['python ./google-ngrams-master/getngrams.py *_NOUN@ ' lower(A{targ_i}) ' -startYear=1960 -smoothing=0 -nosave ']);
            end
            if length(result)>4
                a=textscan(result,'%s%s');
                
                header=a{1}{1};
                if fwd
                stStr=strfind(header,';')+1;
                endStr=strfind(header,'_NOUN')-1;
                else
                stStr=strfind(header,',')+1;
                endStr=strfind(header,'_NOUN')-1;
                end
                
                for ii=1:length(stStr)
                    word{end+1}=header(stStr(ii):endStr(ii))
                end
                done(targ_i)=1;
            else
                disp('waiting')
                pause(1)
            end
            
            %
            %
            %                             a={a{1}{2:end-2}};
            %                             a=char(a);
            %                             a=str2num(a(:,6:end));
            
        end
    end
    if min(done)>0
        break
    end
end
%%

figure
uWord=unique(word);
for ii=1:length(uWord)
    score(ii)=sum(strcmp(uWord{ii},word));
end
[junk ind]=sort(score,'descend');

srtWord=uWord;%(ind);
srtScore=score;%(ind);

srtWord=srtWord(srtScore>1);
srtScore=srtScore(srtScore>1);

plot(srtScore,'x')
dy=0;
dx=.1;
text(1:length(srtScore)+dx, srtScore+dy, upper(srtWord))
uWord(ind(1:sum(score>3)))
% %%
% 