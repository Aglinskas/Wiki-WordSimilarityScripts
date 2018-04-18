% desaturate a series of clusters and hopeully optimise the groupings
% specify the number of wanted clusters e.g. thisT=16 (or heirarchically:
%thisT=[3 6 12] for three different hierarchical levels with 3,6 and 12 braches 
% (tital cluster here is 12).

% input is a word list and a dense matrix
% minItems is the minium number of items per cluster (at each heirachical
% level)
% iterationsPerLevel sets the by iterations independently for each
% cluster-heirarchy

% @Yuan: it is worth trying differen clustering approaches. For instance
% set minItems=8, intererationsPerLevel=50, thisT=16. This less contrained
% (and artificual) approach seems to give use generally what we want

clear
load workingNouns
tempWord=word;
tempDm_verb=dm_verb;
% tempDm_verb=rand(size(dm_verb));
%% Set up params
% minimal number(s) of items in a cluster
minItems=[
    120
    50
    10];
% 
iterationsPerLevel=[
    20 
    20
    50];
% Numbers of clusters to use
n_clusters = [3 6 12];

cc=0;
ccc=0;
%%
% dm = dm_verb;
for ii = 1:1%length(n_clusters)
    thisT = n_clusters(ii)
    cc=cc+1;
    itemPerCat = minItems(cc);%400/thisT^1.33
    fprintf('Get %d clusters with itemPerCat=%d\n',thisT,itemPerCat);
%     Y = pdist(dm,'correlation');
%     Z = linkage(Y, 'ward');
%     %[H,T] = dendrogram(Z,thisT,'Labels',tempWord' );%,'ColorThreshold');% ,Z(end-thisT+1,3) );
%     T = cluster(Z,'maxclust',thisT);
%     [S H]=silhouette(dm,T,'correlation');
    
%     % remove really bad items
%     killer = S<-.01;
%     Word(killer)=[];
%     tempDm_verb(killer,:)=[];
    %
    for iter=1:iterationsPerLevel(ii)
        ccc=ccc+1;
        fprintf('Iteration %d\n',ccc);
        if iter==1
        Y=pdist(tempDm_verb,'correlation');
        Z=linkage(Y, 'ward');%,{'correlation'} )
        [H,T] = dendrogram(Z,thisT,'Labels',tempWord');%,'ColorThreshold');% ,Z(end-thisT+1,3) );
        end
        [S H]=silhouette(tempDm_verb, T,'correlation');
        
        allKill=[];
        for ii=1:thisT % FOR EACH CLUSTER
            ind=find(T==ii); % find index for items from this cluster
            if 0%length(ind)<5% i'm leaving this in to remind us to remove small cluster or bad clusters (via mean silhouette)
                killer=ind;
            else
                
                sScore(ii)=mean(S(ind)); %silhouete score overall (not useful - use cophneye);
                goodness=S(ind); %silhouete score for cluster
                
                [junk indG]=sort(goodness); %sort items within cluster
                killer=[];
                
                if length(indG)>itemPerCat % if cluster is still big enough
                    killer=indG(1);% remove worst item from cluster
                    fprintf('FOUND KILLER %d\n',ind(killer))
                end
                killer=ind(killer);
                allKill=[allKill; killer];
                
            end
        end
        fprintf('Kill %d items  ',length(allKill)); 
        
        %%
        tempWord(allKill)=[];
        tempDm_verb(allKill,:)=[];
        
        %%
        Y=pdist(tempDm_verb,'correlation');
        Z=linkage(Y, 'ward');%,{'correlation'} )
        
        H1=figure;
        [H,T] = dendrogram(Z,thisT,'Labels',tempWord');% ,'ColorThreshold' ,Z(end-thisT+1,3) );
        close(H1)
        
        % record iteration detalis
        % ITER SHOULD BE ccc???, otherwise only keep the last n_cluster
        % loop
        X=corr(tempDm_verb');
        keepWord{ccc}=tempWord;
        keepInd{ccc}=ind;
        keepX{ccc}=corr(tempDm_verb');
        
        keepZ{ccc}=Z;
%         keepDmVerb{iter}=tempDm_verb;
%         cophKeep(iter) = cophenet(Z,Y) ;
%         cophKeepAll(ccc) = cophenet(Z,Y) ;
%         Yy=inconsistent(Z);
%         inconKeep(iter,:)=mean((Yy(end-thisT:end,4)));
    end
end
thisT =

     3

Get 3 clusters with itemPerCat=120
Iteration 1
Kill 2 items     378
   265

Iteration 2
Kill 1 items     144

Iteration 3
Kill 1 items     121

Iteration 4
Kill 2 items     215
   258

Iteration 5
Kill 2 items     159
    46

Iteration 6
Kill 2 items     178
   139

Iteration 7
Kill 2 items     135
   339

Iteration 8
Kill 1 items     143

Iteration 9
Kill 1 items      55

Iteration 10
Kill 1 items      95



save('tempForCmp_improveSil.mat','keepWord','keepInd','keepX')

% 
% %% pick best (hopefully last) and plot sorted DSM and dendro
[junk nInd]=sort(cophKeep); %pick 'best'
cc=0;
H2=figure;
H1=figure;
for best_Iter=length(nInd)%[ ceil(length(nInd)/2) length(nInd)]
    Z=keepZ{nInd(best_Iter)};
    nWord=keepWord{nInd(best_Iter)};
    clear sortT
%     
%     figure(H1)
%     
%     pause(.01)
%     [H,T] = dendrogram(Z,length(Z),'Labels',keepWord{nInd(best_Iter)} ,'ColorThreshold' ,Z(end-thisT+2,3) , 'Orientation' ,'left');%'reorder',keepInd{ii},
%     
%     for allClust=2:length(Z)
%         [H,T] = dendrogram(Z,allClust,'Labels',nWord' ,'ColorThreshold' ,Z(end-allClust+1,3) );
%         sortT(:,allClust)=T;
%    
%     end
%     [junk ind]=sortrows(sortT);
%     
%     wordSort=nWord(ind);
%     cc=cc+1;
%     figure(H2)
%     subplot(2,2,1+(cc-1)*2)
%     imagesc(flipud(squeeze(keepX{nInd(best_Iter)}(ind,ind))))
%     subplot(2,2,2+(cc-1)*2)
%     
%     
%     [H,T] = dendrogram(Z,length(nWord),'Labels',nWord' ,'ColorThreshold' ,Z(end-thisT+2,3) ,'reorder',ind, 'Orientation' ,'left');
%     
%     
% end
% 
% figure(H1)
% [H,T] = dendrogram(Z,thisT,'Labels',nWord' ,'ColorThreshold' ,Z(end-thisT+2,3) ,'reorder',ind, 'Orientation' ,'left');
%    close(H1) 
% tt=T(ind)
% %% plot the silhouette and print the clusters in rank order
% 
% 
% Z=keepZ{nInd(best_Iter)};
% tempDm_verb= keepDmVerb{nInd(best_Iter)};
%  subplot(2,2,3)
% [H,T] = dendrogram(Z,thisT,'Labels',nWord' );%,'ColorThreshold' ,Z(end-thisT+2,3) ,'reorder',ind, 'Orientation' ,'left');
% 
% [S H]=silhouette(tempDm_verb, T,'correlation');
% [junk ind]=sort(sScore);
% 
% for ii=1:length(ind)
%     disp(['cluster order: ' num2str(ii)])
%     {nWord{T==ind(ii)}}
% end
% 
% subplot(2,2,4),plot(cophKeep)
% title('cluster quality across iterations')
% 
% 
% 
% %%
% Xin=keepX{nInd(best_Iter)};
% for kk=1:length(tt)
% for jj=1:length(tt)
% Xout(kk,jj)=mean(mean((Xin(find(tt==tt(kk)),find(tt==tt(jj))))));
% end
% end
% %
% figure,imagesc(flipud(Xout))
% title('WORK IN PROGRESS - THE ORDER MAY BE WRONG')