load firstRun

subplot(2,2,1)
imagesc(log(distanceStuff))

set(gca,'XTick',(1:30));
set(gca,'XTickLabel',dimWords(1:30));
set(gca,'YTick',(1:16));
set(gca,'YTickLabel',nouns(1:16));

subplot(2,2,2)

imagesc((distanceStuff~=0))

set(gca,'XTick',(1:30));
set(gca,'XTickLabel',dimWords(1:30));
set(gca,'YTick',(1:16));
set(gca,'YTickLabel',nouns(1:16));

sum(sum((distanceStuff~=0)))./prod(size(distanceStuff))
xx=(pdist(distanceStuff))
mask1=(distanceStuff~=0);
distanceStuffGB=distanceStuff;
%%
load compareToCLICv2
subplot(2,2,3)
imagesc(log(distanceStuff))

set(gca,'XTick',(1:30));
set(gca,'XTickLabel',dimWordsADJ(1:30));
set(gca,'YTick',(1:16));
set(gca,'YTickLabel',nouns(1:16));

subplot(2,2,4)

imagesc((distanceStuff~=0))

set(gca,'XTick',(1:30));
set(gca,'XTickLabel',dimWordsADJ(1:30));
set(gca,'YTick',(1:16));
set(gca,'YTickLabel',nouns(1:16));

sum(sum((distanceStuff~=0)))./prod(size(distanceStuff))
yy=(pdist(distanceStuff))
mask2=(distanceStuff~=0);

%%
figure
x=((mask1==mask2).*mask1);
x=x(:);
y=distanceStuffGB(:);
subplot(1,2,1),hist(y(find(x)),[0:.000001:.0005])
xlim([0,.00005])
title('Both')
%plot(sort((y(find(x)))))
hold on
x=((mask1~=mask2).*mask1);
x=x(:);
y=distanceStuffGB(:);
subplot(1,2,2),hist(y(find(x)),[0:.000001:.0005])
xlim([0,.00005])
title('GBooks only')
hold off