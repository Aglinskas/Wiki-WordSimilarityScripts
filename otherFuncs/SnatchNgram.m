%% add bit to include only grid AND blue line (get rig of label
tic


%% 1. Read in data
matrixFolder = 'DataMatrices/';
dimWordType = 'Adjs1000';
verbsType = 'Verbs1000';

[verbWords, freq] = textread([matrixFolder 'dimWords_top' verbsType],'%s%d');
[verbWords ind]=sort(verbWords);
freq(ind)=freq;

[dimWords, freq] = textread([matrixFolder 'dimWords_top' dimWordType],'%s%d');
[dimWords ind]=sort(dimWords);
freq(ind)=freq;
%

[goodV goodA bestNouns]=myNiceAdjectivesandVerbs;


% nouns = textread('./DataMatrices/wordlist_mrc_CONC','%s');

% dimWordType = 'Adjs';
% verbsType = 'Verbs';
% load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' dimWordType '.mat']);
% dm_a = dm;
% load([matrixFolder 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_top' verbsType '.mat']);
% dm_v = dm;
%
%
% % THUS
% dm=[dm_v dm_a];
%

% % THUS
% [dimWords, ia] = unique(dimWords);
% dm = dm(:,ia);
% [n_targWords n_dimWords] = size(dm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2. Reduce rows and columns
% 2.1. reduce set-size nouns (row)
% Calculate sum of each row and sort
% Keep the top N ones
% [junk ind] = sort(sum(dm,2),'descend');
% N = 20;
% disp(['I don''t think this is working. Noun/Label appears bad'])
% % disp(prctile(junk,75));
% nouns = lower(nouns(ind(1:N))); % The N selected target words
% % AND THE REDUCED MATRIX

nouns = lower(bestNouns(1:20));




if 1%strcmp(verbsType , 'Verbs1000')
    goodTarg=goodV;goodDim=goodA;
else
    goodTarg=goodA;goodDim=goodV;
end

killTarg=[];
for ii=1:length(verbWords)
    if any(strcmp(verbWords{ii},goodTarg))
        disp(verbWords{ii})
    else
        killTarg=[killTarg ii];
    end
end

killDim=[];
for ii=1:length(dimWords)
    if any(strcmp(dimWords{ii},goodDim))
    else
        killDim=[killDim ii];
    end
end

verbWords(killTarg)=[];
dimWords(killDim)=[];

%%

% if fromScratch


load isDone isDone
for noun_i=1:20
    for verb_j=1:length(dimWords)
         imageData=[];
        if ~isDone(noun_i,verb_j)
            %         nouns{noun_i}='apple';
            %         dimWords{verb_j}='green'
            % _apple_NOUN=>yellow_ADJ
            %  %  web('https://books.google.com/ngrams/graph?content=apple%3D%3Egreen&year_start=1800&year_end=2000&corpus=15&smoothing=3')
            searchString=['https://books.google.com/ngrams/graph?content=' nouns{noun_i} '_NOUN%3D%3E' dimWords{verb_j} '_ADJ&year_start=1800&year_end=2000&corpus=15&smoothing=3'];
            web(searchString);%'https://books.google.com/ngrams/graph?content=apple%3D%3Eyellow&year_start=1800&year_end=2000&corpus=15&smoothing=3')
            pause(.4)
              imageData = screencapture(0, [26 201 1600 800]);
              imageDataOld=imageData;
            lineLength=0;
            ccc=0
            while 1
                ccc=ccc+1
                imageData = screencapture(0, [26 201 1600 800]);
                
                pause(.2)
                %% get grid
                targCol=[52 52 52];%[199 199 199];
                axIm=(imageData(:,:,1)<targCol(1)+3)&(imageData(:,:,1)>targCol(1)-3)&...
                    (imageData(:,:,2)<targCol(2)+3)&(imageData(:,:,2)>targCol(2)-3)&...
                    (imageData(:,:,3)<targCol(3)+3)&(imageData(:,:,3)>targCol(3)-3);
                axInd=find((sum(axIm,1))>5);
                if length(axInd)>40  % dela with missing values
                    axInd=find((sum(axIm,1))>5);
                    gridRight=axInd(end);%find(sum(squeeze(mean(axIm,3)))==max(sum(squeeze(mean(axIm,3)))));
                    axInd=find((sum(axIm,1))>50);
                    gridLeft=axInd(1);%find(sum(squeeze(mean(axIm,3)))==max(sum(squeeze(mean(axIm,3)))));
                    axInd=find((((axIm(:,gridLeft,:)))>0));
                    gridTop=min(axInd);
                    gridBottom=max(axInd);
                else
                    gridRight=50;
                    
                end
                %%
                
                % cut rightward to avoid label
                imageData(:,gridRight:end,:)=[];
                targCol=[ 52   91  222];
                
                lineIm=(imageData(:,:,1)==targCol(1))&...
                    (imageData(:,:,2)==targCol(2))&...
                    (imageData(:,:,3)==targCol(3));
                
                lineInd=find(sum(lineIm()));
                
                if length(lineInd)==lineLength&length(lineInd)>200
                    break
                else
                    lineLength=length(lineInd);
                end
                if ccc==15
                    break
                end
                
            end
            if ccc==15
                distanceStuff(noun_i,verb_j)=0;
            else
                % imagesc(lineIm(:,lineInd,:))
                
                % imagesc(lineIm(:,ii)))
                
                
                % lineInd(gridRight:end)=[];
                myInd=lineInd(round(length(lineInd)*.8):end);
                %  myInd=lineInd(1:end);
                %% limit to within plot grid
                clear keep
                for ii=1:length(myInd)
                    xx=find(lineIm(:,myInd(ii))==1);;
                    keep(ii)=gridBottom-xx(1);
                end
                
                imagesc(axIm)
                
                %         imagesc(imageData(min(axInd):max(axInd),lineInd,:));
                imagesc(imageData(200:end,10:min(lineInd)-23,:))
%                 pause(.2)
                %         while 1
                results = ocr(imageData(200:end,10:min(lineInd)-23,:),'CharacterSet','.01234567890')
                %             if length(results.Words)>4
                %                 break
                %             end
                %         end
                
                disp('HERE')
                clear test
                cc=0;
                for ii=length(results.Words):-1:1
                    cc=cc+1;
                    try
                        test(ii)=str2double(results.Words{ii}(1:end-1));
                        
                    catch
                        disp(['missed: ' results.Words{ii}(1:end-1)])
                    end
                    
                    test(test>=1)=[];
                end
                test(test>=1)=[];
                
                yUpper=test(find(test==max(test)));
                highest=gridTop;
                lowest=gridBottom;%find(test==min(test));
                scale=yUpper/(lowest-highest);
                
                %         lowest=lowest(end);
                %  lowest=size(imageData,1)-results.WordBoundingBoxes(lowest,2);
                % highest=size(imageData,1)-results.WordBoundingBoxes(highest,2)
                plot(keep*scale)
                distanceStuff(noun_i,verb_j)=mean(keep*scale)
                1
                
            end
        end
    end
    toc
end

%lineInd=find(sum(lineIm()))