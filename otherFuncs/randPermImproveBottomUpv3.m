
clear
load workingNouns

tempWord=word;
tempDm_verb=dm_verb;
for thisT=32
    itemPerCat=128/thisT
for iter=1:20
    
    if iter==1 % first time through orhter use last
    end
    Y=pdist(tempDm_verb,'correlation');
    Z=linkage(Y, 'ward');%,{'correlation'} )
    
    
   
    [H,T] = dendrogram(Z,thisT,'Labels',tempWord' );%,'ColorThreshold');% ,Z(end-thisT+1,3) );
    [S H]=silhouette(tempDm_verb, T,'correlation');
    
    killer=S<0;
    
    tempWord(killer)=[];
    tempDm_verb(killer,:)=[];
     Y=pdist(tempDm_verb,'correlation');
    Z=linkage(Y, 'ward');%,{'correlation'} )
   
    [H,T] = dendrogram(Z,thisT,'Labels',tempWord' );%,'ColorThreshold');% ,Z(end-thisT+1,3) );
    [S H]=silhouette(tempDm_verb, T,'correlation');
     allKill=[];
    for ii=1:thisT
        ind=find(T==ii);
        notInd=find(T~=ii);
        sScore(ii)=mean(S(ind));
        smallWord={tempWord{ind}};
        smallDm_verb=tempDm_verb(ind,:);
        goodness=(mean(corr(smallDm_verb')));
        X=corr(tempDm_verb');
        goodNess=mean(X(ind,ind))-mean(X(notInd,ind)); % with v across item level
        clear X
        [junk indG]=sort(goodness)
        killer=[];
%         if length(indG)-(7-iter)>0 %% this is backward
%             killer=indG(end-(7-iter):end);
%         end
        if length(indG)>itemPerCat
            killer=indG(1);
        end
        %     killer=randperm(length(ind),length(ind)-9);
        killer=ind(killer);
        allKill=[allKill; killer];
    end
    %%
    tempWord(allKill)=[];
    tempDm_verb(allKill,:)=[];
    Ttest=T;
    Ttest(allKill)=[];
    %%
    Y=pdist(tempDm_verb,'correlation');
    Z=linkage(Y, 'ward');%,{'correlation'} )
    
    H1=figure;
    % for thisT
    [H,T] = dendrogram(Z,thisT,'Labels',tempWord');% ,'ColorThreshold' ,Z(end-thisT+1,3) );
    pause(.1)
    sortT=T;
    % end
    close(H1)
    
    [junk ind]=sortrows(sortT);
    
    wordSort=tempWord(ind);
    
    X=corr(tempDm_verb');
    X=X(ind,ind);
    myDiag=imresize(eye(thisT),size(X,1)/thisT,'Method','box');
    myDiag2=zeros(size(myDiag));
    sortTtest=sort(Ttest);
    for ii=1:length(junk)
        
        for jj=1:length(sortTtest)
            if sortTtest(ii)==sortTtest(jj)
                myDiag2(ii,jj)=sortTtest(ii);
            end
        end
    end
    %
    %     for ii=1:thisT
    %         tempVec=myDiag2;
    %         score(ii)=mean(X(myDiag2(:)==ii));
    %     end
    keepWord{iter}=tempWord;
    keepInd{iter}=ind;
    keepX{iter}=corr(tempDm_verb');
    %         targMat=getTargetMat;
    %         Xf=.5.*log((1+X)./(1-X));
    %         howWellCorr(iter)=corr(targMat(targMat(:)~=1),Xf(targMat(:)~=1));
    %% alos try log of score)
    [h p ci stat]=ttest2(X(myDiag(:)==1),X(myDiag(:)~=1));
    howWellT(iter)=stat.tstat;
    howWellDiff(iter)=mean(X(myDiag(:)==1))-mean(X(myDiag(:)~=1));
    howWell(iter)=mean(myDiag(:).*X(:));
    keepZ{iter}=Z;
end
end
%%
[junk nInd]=sort(howWell);
cc=0;
H2=figure;
H1=figure;
for ii=[ length(nInd)/2 length(nInd)]
    Z=keepZ{nInd(ii)};
    nWord=keepWord{nInd(ii)};
    clear sortT
    
       figure(H1)
       
    pause(.01)
    [H,T] = dendrogram(Z,length(Z),'Labels',keepWord{nInd(ii)} ,'ColorThreshold' ,Z(end-thisT+2,3) , 'Orientation' ,'left');%'reorder',keepInd{ii},
    
    for allClust=2:length(Z)
        [H,T] = dendrogram(Z,allClust,'Labels',nWord' ,'ColorThreshold' ,Z(end-allClust+1,3) );
        sortT(:,allClust)=T;
        pause(.00000001)
    end
    [junk ind]=sortrows(sortT);
    
    wordSort=nWord(ind);
    cc=cc+1;
    figure(H2)
    subplot(2,2,1+(cc-1)*2)
    imagesc(flipud(squeeze(keepX{nInd(ii)}(ind,ind))))
    subplot(2,2,2+(cc-1)*2)
    
    
    [H,T] = dendrogram(Z,length(nWord),'Labels',nWord' ,'ColorThreshold' ,Z(end-thisT+2,3) ,'reorder',ind, 'Orientation' ,'left');
 
    
    
    pause(.01)
       figure(H1)
end

    close(H1)