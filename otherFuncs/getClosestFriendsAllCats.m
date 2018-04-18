%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%          choose the words via the file at line 7 (e.g. typNouns)
%%          use the graph to interpret
%%          save 'uWord' and 'score' if you like the results
%%          you can interupt and start again - it wil fill in the blamks
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

%% load typNouns  % this is the input file
%clear
clear A
List_itemsXcategory_26ago16;
% C=who;
C={ 'amphibia'    'bathroomobj'    'birds'    'clothes'    'deskobj'    'fishes'    'fruit'    'homeobj' ...
    'insects'    'kitchenobj'    'mammals'    'molluscs'    'musicalins'    'reptiles'    'shellfish' ...
    'tools'    'vegetables'};
D=[];
for ii=1:length(C)
    eval(['D=[D ones(1,length(' C{ii} '))*ii];'])
    if ii>1
        eval(['A={A{1:end} ' C{ii} '{1:end}};'])
    else
        eval(['A={' C{ii} '{1:end}};'])
    end
end
killer=[];
for ii=1:length(A)
    if any(strfind(A{ii},' '))
        killer=[killer ii];
    end
end
A(killer)=[];
%%

A(find(strcmp('harp',A)))=[];
if ~exist('done')
word=[];
    done=zeros(1,length(A));
end
fwd=true;
while true
    for targ_i=1:length(A)
        if ~done(targ_i)
            targWord=[];
            if fwd
                [status,result] = system(['python ./google-ngrams-master/getngrams.py ' lower(A{targ_i})  '@*_VERB -startYear=1960 -smoothing=0 -nosave ']);
            else
                [status,result] = system(['python ./google-ngrams-master/getngrams.py *_VERB@ ' lower(A{targ_i}) ' -startYear=1960 -smoothing=0 -nosave ']);
            end
            if length(result)>4
                a=textscan(result,'%s%s');
                
                header=a{1}{1};
                if fwd
                    stStr=strfind(header,'gt;')+3;
                    endStr=strfind(header,'_VERB')-1;
                else
                    stStr=strfind(header,'gt;')+3;
                    endStr=strfind(header,'_VERB')-1;
                end
                
                for ii=1:length(stStr)
                    word{end+1}=header(stStr(ii):endStr(ii));
                    targWord{end+1}=header(stStr(ii):endStr(ii))
                end
                done(targ_i)=1;
                byWord{targ_i}=targWord;
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


uWord=unique(word);
for ii=1:length(uWord)
    score(ii)=sum(strcmp(uWord{ii},word));
end
[junk ind]=sort(score,'descend');

srtWord=uWord;%(ind);
srtScore=log(score);%(ind);
srtWord=srtWord(srtScore>1.1);
srtScore=srtScore(srtScore>1.1)
myPath=pwd;

if false
cd '/Users/scott/Documents/Studies/Composes'



 [absWord absScore]=GatherClusterRawCount;
 cd (myPath)
 
 % prune
 killer=(find(absScore<200))
 srtScore(killer)=[];
 absScore(killer)=[];
 srtWord(killer)=[];
 absWord(killer)=[];
  srtScore=log(exp(srtScore)./log(absScore));
end
% srtScore=log(srtScore);%(ind);

%srtScore=log(exp(srtScore)./exp(absScore));
plot(srtScore,'x')
dy=0;
dx=.1;
text(1:length(srtScore)+dx, srtScore+dy, upper(srtWord))
% %%
%
save freindsTemp