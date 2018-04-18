subplot(1,4,1),
    [H,T] = dendrogram(Z,8,'Labels',tempWord' ,'ColorThreshold' ,Z(end-thisT+2,3) );
ind=find(T==1);

    [H,T] = dendrogram(Z,length(Z),'Labels',tempWord' ,'ColorThreshold' ,Z(end-thisT+2,3) );
    smallWord={tempWord{ind}};
    smallDm_verb=tempDm_verb(ind,:);
YY=pdist(smallDm_verb,'correlation');
ZZ=linkage(YY, 'ward');
subplot(1,4,2),[HH,TT] = dendrogram(ZZ,length(ZZ),'Labels',smallWord' ,'ColorThreshold' ,Z(end-25,3) );


%
subplot(1,4,3),[HH,TT] = dendrogram(ZZ,4,'Labels',smallWord' ,'ColorThreshold' ,0.00001);
for ii=1:length(unique(TT))
{smallWord{find(TT==ii)}}


end


selectedWord={smallWord{find(TT~=1)}};
selectedDM_verb=smallDm_verb(find(TT~=1),:);
    subplot(1,4,4),
YY=pdist(selectedDM_verb,'correlation');
ZZ=linkage(YY, 'ward');
[HH,TT] = dendrogram(ZZ,length(ZZ),'Labels',selectedWord' ,'ColorThreshold' ,Z(end-14,3) );


