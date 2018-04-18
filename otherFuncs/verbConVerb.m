figure
load('dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topVerbs.mat')
A=textread('wordlist_mrc_CONC','%s');
cc=0;
word=[];
for ii=1:length(A)
    cc=cc+1;
    word{cc}=A{ii};
end

clear Freq
B=textread('topVerbs','%s');
cc=0;
verbs=[];
for ii=1:2:length(B)
    cc=cc+1;
    verb{cc}=B{ii};
    
    Freq(cc)=str2num(B{ii+1});
end




load('/Users/scott/Data/WP2.2/dm_topVerbs-EN-wform.w.5.sm.txt_smFull.mat')

% reduce set-size verbs

dm_verb=dm_topVerbs;
[junk ind]=sort((sum(dm_verb~=0,1))./log(Freq),'descend');
% [junk ind]=sort(sum(dm_verb==0,1));
kill=ind(401:end);%find(sum(dm_verb==0,1)>size(dm_verb,1)*.8);
verb(kill)=[];
dm_verb(:,kill)=[];

dm(:,kill)=[];
dm(kill,:)=[];

Y=pdist(dm,'correlation');
Z=linkage(Y, 'ward');%,{'correlation'} );

% clustering all 
[H,T] = dendrogram(Z,size(dm,1),'Labels',verb' ,'ColorThreshold' ,1.4 );
title('COMPLETE')
