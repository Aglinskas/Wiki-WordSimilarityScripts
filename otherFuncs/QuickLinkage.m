clear
figure
load('/Users/scott/Library/Containers/com.apple.mail/Data/Library/Mail Downloads/F184D76D-4B30-4915-B87E-7556261B336A/denseMatrix_MRC_top1000Verbs.mat')
A=textread('wordlist_mrc_CONC_sel','%s');
cc=0;
word=[];
for ii=1:2:length(A)
    cc=cc+1;
    word{cc}=A{ii};
end

kill=find(sum(dm_verb==0,2)==size(dm_verb,2)); % get rid verb-relates
word(kill)=[];
dm_verb(kill,:)=[];

% kill=find(sum(dm_verb~=0,2)<50); % remove nounes with less than 10 verb-relates
% word(kill)=[];
% dm_verb(kill,:)=[];
X=corr(dm_verb');
% X=dm_verb;
X=1-X;
nItems=size(X,1);
Nanify=ones(nItems)    ;
for i=nItems:-1:1
    for j=i:-1:1
        Nanify(i,j)=nan;
    end
end

Y=X(:);
Y=Y(~isnan(Nanify(:)))';
% Y=pdist(X,'correlation');
 Y=pdist(dm_verb,'correlation');
Z=linkage(Y, 'ward');%,{'correlation'} );
%Z2=linkage((X), 'ward',{'correlation'} ); is equivalent to: linkage(pdist(X,'correlation'), 'ward'
subplot(2,3,1)
[H,T] = dendrogram(Z,size(X,1),'Labels',word' ,'ColorThreshold' ,1.4 );
title('COMPLETE')
subplot(2,3,2)
 [H,T] =dendrogram(Z,28,'Labels',word');
title('TAKE 28')
 for ii=1:length(unique(T))
     grrr=find(T==ii);
     
     myCluster(ii,:)=grrr(1:5);
     for jj=1:length(grrr);
     disp(word{grrr(jj)})
     end
     disp(' ')
 end
 c = cophenet(Z,X);
  %%
  
  disp('now showing sub clusters - goal to pick 5 ''similar'' items')
 
 dm_verbRefined=dm_verb(myCluster(:),:);
 
 Y=pdist(dm_verbRefined,'correlation');
ZZ=linkage(Y, 'ward');%,{'correlation'} );
% [H,T] = dendrogram(Z,size(dm_verbRefined,1),'Labels',word' ,'ColorThreshold' ,1.4 );

subplot(2,3,3)
dendrogram(ZZ,28,'Labels',word(myCluster(:))');

title('TAKE ONLY 5 FROM EACH ''CLUSTER'' = DISTORTED')

 for ii=1:8%length(unique(T))
subplot(4,4,ii+8)
grrr=find(T==ii);
     tempVerb=dm_verb(grrr,:);
     
 Y=pdist(tempVerb,'correlation');
Z=linkage(Y, 'ward');
[H] = dendrogram(Z,length(grrr), 'Labels',{word{grrr}} ,'ColorThreshold' ,1.4 );
     
   %  myCluster(ii,:)=grrr(1:5);
     for jj=1:length(grrr);
     disp(word{grrr(jj)})
     end
     disp(' ')
     pause(.2)
 end
 
 
 
 %%