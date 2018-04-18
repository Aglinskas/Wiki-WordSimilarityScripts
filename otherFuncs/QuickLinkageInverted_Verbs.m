clear
% figure
load('/Users/scott/Library/Containers/com.apple.mail/Data/Library/Mail Downloads/F184D76D-4B30-4915-B87E-7556261B336A/denseMatrix_MRC_top1000Verbs.mat')
A=textread('wordlist_mrc_CONC_sel','%s');
cc=0;
word=[];
for ii=1:2:length(A)
    cc=cc+1;
    word{cc}=A{ii};
end
B=textread('dimWords_topVerbs1000','%s');
cc=0;
verbs=[];
for ii=1:2:length(B)
    cc=cc+1;
    verb{cc}=B{ii};
end
% 
% kill=find(sum(dm_verb==0,2)==size(dm_verb,2)); % get rid verb-relates

% reduce set size for visability
kill=find(sum(dm_verb==0,1)>300);
verb(kill)=[];
dm_verb(:,kill)=[];

% kill=find(sum(dm_verb~=0,2)<50); % remove nounes with less than 10 verb-relates
% word(kill)=[];
% dm_verb(kill,:)=[];
X=corr(dm_verb);
% X=dm_verb;
X=1-X;
% nItems=size(X,1);
% Nanify=ones(nItems)    ;
% for i=nItems:-1:1
%     for j=i:-1:1
%         Nanify(i,j)=nan;
%     end
% end
% 
% Y=X(:);
% Y=Y(~isnan(Nanify(:)))';
% Y=pdist(X,'correlation');
%%
 Y=pdist(dm_verb','correlation');
Z=linkage(Y, 'ward');%,{'correlation'} );
%
%Z2=linkage((X), 'ward',{'correlation'} ); is equivalent to: linkage(pdist(X,'correlation'), 'ward'
subplot(1,3,1)
[H,T] = dendrogram(Z,size(X,1),'Labels',verb' ,'ColorThreshold' ,1.4 );
title('COMPLETE')
subplot(1,3,2)
figure(gcf)
%%
 [H,T] =dendrogram(Z,8,'Labels',verb');
title('TAKE 8')
%  for ii=1:length(unique(T))
%      grrr=find(T==ii);
%      
%      myCluster(ii,:)=grrr(1:5);
%      for jj=1:length(grrr);
%      disp(verb{grrr(jj)})
%      end
%      disp(' ')
%  end
 c = cophenet(Z,X);
  %%
  
  [junk ind]=sort(T);
  subplot(1,3,3)
imagesc(X(ind,ind))
  disp('now showing sub clusters - goal to pick 5 ''similar'' items')
  figure(gcf)
%  
%  dm_verbRefined=dm_verb(myCluster(:),:);
%  
%  Y=pdist(dm_verbRefined,'correlation');
% ZZ=linkage(Y, 'ward');%,{'correlation'} );
% % [H,T] = dendrogram(Z,size(dm_verbRefined,1),'Labels',verb' ,'ColorThreshold' ,1.4 );
% 
% subplot(2,3,3)
% dendrogram(ZZ,28,'Labels',verb(myCluster(:))');
% 
% title('TAKE ONLY 5 FROM EACH ''CLUSTER'' = DISTORTED')
% 
%  for ii=1:8%length(unique(T))
% subplot(4,4,ii+8)
% grrr=find(T==ii);
%      tempVerb=dm_verb(grrr,:);
%      
%  Y=pdist(tempVerb,'correlation');
% Z=linkage(Y, 'ward');
% [H] = dendrogram(Z,length(grrr), 'Labels',{verb{grrr}} ,'ColorThreshold' ,1.4 );
%      
%    %  myCluster(ii,:)=grrr(1:5);
%      for jj=1:length(grrr);
%      disp(verb{grrr(jj)})
%      end
%      disp(' ')
%      pause(.2)
%  end
%  
 
 
 %%