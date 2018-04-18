
%%
figure
numberofDims=4;
cc=0;
for ii=1:numberofDims
    for jj=ii+1:numberofDims
        cc=cc+1;
        dimCompMat(cc,:)=[ii jj];
    end
end
% close all
x = 2;
j = length(loopDMs{x});
loopDM = loopDMs{x}{j};
X=corr(loopDM');
loopLbls = loopRemainedTargWords{x}{j};
[Y,stress,disparities] = mdscale(1-corr(loopDM'),numberofDims);
Z = linkage(loopDM, 'ward','correlation');
[H T sortedRowIds] = dendrogram(Z,length(Z),'Labels',...
            loopLbls,'Orientation','left','ColorThreshold',1.4);
%         T2 = cluster(Z,'maxclust',15);
[H T2] = dendrogram(Z,15)
        sorted_T=T2(sortedRowIds)
    sortedRowIds = wrev(sortedRowIds);
    sorted_dm = loopDM(sortedRowIds,:);
    sorted_tw = loopLbls(sortedRowIds);
%     sorted_T=T(sortedRowIds);
    SM = corr(sorted_dm');
    figure();imagesc(SM);colorbar();
    set(gca,'YTick',1:length(sorted_tw));
    set(gca,'YTickLabel',sorted_tw); 
    
    
    
    loopDM=sorted_dm;
    loopLbls=sorted_tw;
    T=sorted_T;
index=(T);



for plotCount=1:numberofDims
    subplot(1,numberofDims,plotCount);
    hold off
    for ii=1:length(index)
        
        
        
        k=index(ii);
        hold on
        if mod(ii,3)==1
            plot(Y(T==k,dimCompMat(plotCount,1)),Y(T==k,dimCompMat(plotCount,2)),'o','Color',[1-k/max(index) 0 0+k/max(index)])
        elseif mod(ii,3)==2
            plot(Y(T==k,dimCompMat(plotCount,1)),Y(T==k,dimCompMat(plotCount,2)),'+','Color',[1-k/max(index) 0 0+k/max(index)])
        else
            
            plot(Y(T==k,dimCompMat(plotCount,1)),Y(T==k,dimCompMat(plotCount,2)),'x','Color',[1-k/max(index) 0 0+k/max(index)])
        end
        ind2=find(T==k);
        for jj=1:length(ind2)
            text( Y(ind2(jj),dimCompMat(plotCount,1)),Y(ind2(jj),dimCompMat(plotCount,2)),loopLbls{ind2(jj)});
        end
    end
    title([num2str(dimCompMat(plotCount,1)) ' versus ' num2str(dimCompMat(plotCount,2))])
end
%%



figure

clear meanAll
subplot(1,2,1)
X=SM;
imagesc(X)
for ii=1:size(X,1)  % just get rid of the slef self correlation    
X(ii,ii)=NaN;
end


    for ii=1:length(index)
        for jj=1:length(index)
        
%         subplot(1,2,1),imagesc(X)
        meanAll(ii,jj)=nanmean(nanmean(X(find(T==index(ii)),find(T==index(jj)))));
       
        end
    end
     subplot(1,2,2),imagesc(meanAll)
     pause(.001)
% %%
% figure
%  for ii=1%:length(index)
%         k=index(ii);
% %         hold on
%         if mod(ii,3)==1
%               plot3(Y(T==k,1),Y(T==k,2),Y(T==k,3),'o','Color',[1-k/max(index) 0 0+k/max(index)])
%         elseif mod(ii,3)==2
%     plot3(Y(T==k,1),Y(T==k,2),Y(T==k,3),'+','Color',[1-k/max(index) 0 0+k/max(index)])
%         else
%             
%             plot3(Y(T==k,1),Y(T==k,2),Y(T==k,3),'x','Color',[1-k/max(index) 0 0+k/max(index)])
%         end
%         
%  end