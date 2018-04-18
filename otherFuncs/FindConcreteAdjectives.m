A=textread('lowIMG.m','%s');
A=A(1:3:end);
word=[];
done=zeros(1,length(A));
while true
for targ_i=1:length(A)  
    if ~done(targ_i)
       [status,result] = system(['python ./google-ngrams-master/getngrams.py ' lower(A{targ_i})  '@*_ADJ -startYear=1960 -smoothing=0 -nosave ']);
       if length(result)>4
                            a=textscan(result,'%s%s');
                            
                                                         header=a{1}{1};
                                            stStr=strfind(header,';')+1;
                        endStr=strfind(header,'_ADJ')-1;
                        
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
uWord=unique(word);
for ii=1:length(uWord)
    score(ii)=sum(strcmp(uWord{ii},word));
end
[junk ind]=sort(score,'descend');

uWord(ind)
score(ind)

uWord(ind(1:sum(score>3)))
%%

A=textread('highIMG.m','%s');
A=A(1:3:end);
word=[];
for targ_i=1:length(A)  
       [status,result] = system(['python ./google-ngrams-master/getngrams.py ' lower(A{targ_i})  '@*_ADJ -startYear=1960 -smoothing=0 -nosave ']);
                            a=textscan(result,'%s%s');
                            
                                                         header=a{1}{1};
                                            stStr=strfind(header,';')+1;
                        endStr=strfind(header,'_ADJ')-1;
                        
                        for ii=1:length(stStr)
                            temp{targ_i}=header(stStr(ii):endStr(ii))
                        end
                        
                        
%                         
%                         
%                             a={a{1}{2:end-2}};
%                             a=char(a);
%                             a=str2num(a(:,6:end));
                        
                            
end

word=[];
for ii=1:length(temp)
    word=[word temp{ii}];
end

%%
uWord=unique(word);
for ii=1:length(uWord)
    score(ii)=sum(strcmp(uWord{ii},word));
end
[junk ind]=sort(score,'descend');

uWord(ind)
score(ind)