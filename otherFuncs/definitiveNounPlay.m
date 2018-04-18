% compare to random luctering to see size effect
%remove selected items from cluster to increase seperation - high values of importance (outside of cluster)
clear
nClust=32;
figure
% load('dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topVerbs.mat')
load('/Users/scott/Data/WP2.2/DataMatrices/dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topAdjs.mat')
dm_adj=dm;
load('/Users/scott/Data/WP2.2/DataMatrices/dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topVerbs.mat') 
dm_verb=dm;
A=textread('./DataMatrices/wordlist_mrc_CONC','%s');
cc=0;
word=[];
for ii=1:length(A)
    cc=cc+1;
    word{cc}=A{ii};
end

clear Freq aFreq
B=textread('./DataMatrices/topVerbs','%s');
cc=0;
verbs=[];
for ii=1:2:length(B)
    cc=cc+1;
    verb{cc}=B{ii};
    
    Freq(cc)=str2num(B{ii+1});
end


B=textread('./DataMatrices/topAdjs','%s');
cc=0;
verbs=[];
for ii=1:2:length(B)
    cc=cc+1;
    adj{cc}=B{ii};
    
    aFreq(cc)=str2num(B{ii+1});
end

%%
% reduce set-size nouns
[junk ind]=sort(sum(dm_verb==0,2));
kill=ind(801:end);
word(kill)=[];
dm_verb(kill,:)=[];
dm_adj(kill,:)=[];


% reduce set-size verbs
[junk ind]=sort((sum(dm_verb~=0,1))./log(Freq),'descend');
% [junk ind]=sort(sum(dm_verb==0,1));
kill=ind(401:end);%find(sum(dm_verb==0,1)>size(dm_verb,1)*.8);
verb(kill)=[];
dm_verb(:,kill)=[];

% reduce set-size verbs
[junk ind]=sort((sum(dm_adj~=0,1))./log(aFreq),'descend');
% [junk ind]=sort(sum(dm_verb==0,1));
kill=ind(401:end);%find(sum(dm_verb==0,1)>size(dm_verb,1)*.8);
adj(kill)=[];
dm_adj(:,kill)=[];

% linkage
Y=pdist(dm_verb,'correlation');
YYo=pdist(dm_verb,'correlation');
Z=linkage(Y, 'ward');%,{'correlation'} );


dm_verb=[dm_verb dm_adj];
% clustering all 
[H,T] = dendrogram(Z,size(dm_verb,1),'Labels',word' ,'ColorThreshold' ,1.4 );
title('COMPLETE')

%% REMOVE NOUNS BASED ON TARGET VECTOR
specificExlude={'RED'};
excludeKeys{1,:}={'FATHER','MOTHER','INDIAN','JUDGE','SLAVE','MEN','WOMAN'};
excludeKeys{2,:}={'HOUSE','PRISON','COTTAGE','CAMP','TENT'};
% find targets and assoicates - arbitrary cluster thresh could be imporved
for kk=1:size(excludeKeys,1)
    targetPersonVerbs=excludeKeys{kk,:};
    
Y=pdist(dm_verb,'correlation');
Z=linkage(Y, 'ward');%,{'correlation'} )
[H,T] = dendrogram(Z,30);

    for ii=1:length(unique(T))
        locat=ismember(targetPersonVerbs,{word{find(T==ii)}});
         sum(locat)
        if sum(locat)>1;%length(targetPersonVerbs)*.1
           
    targInd=find(T==ii);
    T(targInd)=[];
    {word{targInd}}
    % now clear
    word(targInd)=[];
    dm_verb(targInd,:)=[]; % CLEAR VERBS TOO?
   Freq(targInd)=[];
    
            
        end
    end
    
    % rerun
end
Y=pdist(dm_verb,'correlation');
Z=linkage(Y, 'ward');%,{'correlation'} );

% clustering all 
% arrange by similiarity 
for thisT=2:length(Z)
[H,T] = dendrogram(Z,thisT,'Labels',word' ,'ColorThreshold' ,Z(end-thisT+1,3) );
sortT(:,thisT)=T;
end
% [H30,T30] = dendrogram(Z,30,'Labels',word' ,'ColorThreshold' ,Z(end-30+1,3) );
[H,T] = dendrogram(Z,size(dm_verb,1),'Labels',word' ,'ColorThreshold' ,Z(end-nClust+1,3) );
title('COMPLETE')

H1=figure;
cc=0;
 [H,T] =dendrogram(Z,nClust);
 drawnow
 close(H1)
    title(['TAKE ' num2str(nClust)])
    for ii=1:length(unique(T))
        grrr=find(T==ii);
        
             myCluster{ii}={word{grrr}};
             for jj=1:length(grrr);
             disp(word{grrr(jj)})
             end
             disp(' ')
    end
    %%
    
%     [junk ind]=sortrows([T10 T30 T]);
    
    [junk ind]=sortrows(sortT);
    wordSort=word(ind);
    X=corr(dm_verb');
    X=X(ind,ind);
    figure,
    imagesc(flipud(X))
    
    
    figure,
    
[H,T] = dendrogram(Z,size(dm_verb,1),'Labels',word' ,'ColorThreshold' ,Z(end-nClust+1,3) ,'reorder',ind, 'Orientation' ,'left');