
getGoodgleData


targWordso=targWords;dimWordso=dimWords;
% getClicData
getClicDataACWorkShop

x=((corr(distanceStuffCLIC')+corr(distanceStuffGoogle'))/2)
x=corr(distanceStuffCLIC');
% Y = pdist(x,'correlation');

% x=corr(distanceStuffGoogle);
%
cc=0;
YY=[];
for ii=1:length(x)
    for jj=ii+1:length(x)
        cc=cc+1;
        YY(cc)=1-x(ii,jj);
    end
end
% figure();imagesc(squareform(Y));colorbar();
Z = linkage(YY, 'ward');
        figure
[H,T] = dendrogram(Z,size(distanceStuffCLIC,1),'Labels',targWords(1:size(distanceStuffCLIC,1)),...
    'Orientation','left','ColorThreshold',1.4 );