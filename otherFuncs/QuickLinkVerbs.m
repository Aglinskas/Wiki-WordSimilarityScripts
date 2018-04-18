% compare to random luctering to see size effect
%remove selected items from cluster to increase seperation - high values of importance (outside of cluster)

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
%
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
clear myCluster
cc=0;
for clusS=12:32 % 10 or 18
    cc=cc+1;
    [H,T] =dendrogram(Z,clusS,'Labels',verb');
    title(['TAKE ' num2str(clusS)])
    for ii=1:length(unique(T))
        grrr=find(T==ii);
        
             myCluster{cc,ii}={verb{grrr}};
%              for jj=1:length(grrr);
%              disp(verb{grrr(jj)})
%              end
             disp(' ')
    end
    c = cophenet(Z,X);
    %%
    
    [junk ind]=sort(T);
    subplot(1,3,3)
    imagesc(X(ind,ind))
    disp('now showing sub clusters - goal to pick 5 ''similar'' items')
    figure(gcf)
    
    nItems=size(X,1);
    Nanify=ones(nItems)    ;
    for i=nItems:-1:1
        for j=i:-1:1
            Nanify(i,j)=nan;
        end
    end
    %
    Y=X(:);
    
    Y=Y(~isnan(Nanify(:)))';
    blob=zeros(size(X));
    for jj=1:length(T)
        for ii=1:length(T)
            if T(ii)==T(jj)
                blob(ii,jj)=1;
                %              blob(ind(ii),ind(jj))=1;
            end
        end
    end
    
    ZZ=blob(:);
    ZZ=ZZ(~isnan(Nanify(:)))';
    %%
    
    [H,P,CI,STATS] = ttest2((Y(ZZ==1)), (Y(ZZ==0)));
    
    cF(cc)=STATS.tstat;
    
    % Y=Y(~isnan(Nanify(:)))';
    uniT=unique(T);
    close all
    blob2=nan(max(T),max(T));
    for ii=1:length(uniT)
        for jj=ii:length(uniT)
            %if T(ii)==T(jj)
            figure(gcf)
            %                imagesc(X(T==ii,T==jj))
            %                pause(.5)
            blob2(ii,jj)=mean(mean(1-X(T==ii,T==jj)));
            blob3(ii,jj)=sum(T==ii);
            %              blob(ind(ii),ind(jj))=1;
            %end
        end
    end
    figure(gcf)
    subplot(1,2,1)
    imagesc(blob2)
    subplot(1,2,2)
    imagesc(blob3)
    pause(.5)
    ZZ=blob(:);
    ZZ=ZZ(~isnan(Nanify(:)))';
    %
    
    [H,P,CI,STATS] = ttest2((Y(ZZ==1)), (Y(ZZ==0)));
    
    cF(cc)=STATS.tstat;
    
    targetPersonVerbs=lower({'TWIST','SCREW','GRAB'});
% find targets and assoicates - arbitrary cluster thresh could be imporved
[H,T] = dendrogram(Z,15);

    for ii=1:length(unique(T))
        locat=ismember(targetPersonVerbs,{verb{find(T==ii)}});
        if sum(locat)>length(targetPersonVerbs)*.8
            break
        end
    end
    targInd=find(T==ii);
    {word{targInd}}
    % now clear
    manipList=verb(targInd);
    dm_manip=dm_verb(:,targInd); % CLEAR VERBS TOO?
 figure(gcf)
Ym=pdist(dm_manip','correlation');
Zm=linkage(Ym, 'ward');%,{'correlation'} );
%
%Z2=linkage((X), 'ward',{'correlation'} ); is equivalent to: linkage(pdist(X,'correlation'), 'ward'
subplot(1,2,1)
[H,T] = dendrogram(Zm,size(dm_manip,2),'Labels',manipList');% ,'ColorThreshold' ,1.4 );
    
   %%
   
  
 figure(gcf)
Ymdim=pdist(dm_manip,'correlation');
Zmdim=linkage(Ymdim, 'ward');%,{'correlation'} );
subplot(1,2,2)
%Z2=linkage((X), 'ward',{'correlation'} ); is equivalent to: linkage(pdist(X,'correlation'), 'ward'
subplot(1,1,1)
[H,T] = dendrogram(Zmdim,size(dm_manip,1),'Labels',word' ,'ColorThreshold' ,1.4 );
%%
   
end

% close all
% plot(cF)