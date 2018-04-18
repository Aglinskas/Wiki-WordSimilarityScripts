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
% dm_EN-wform.w.5.sm.wordlist_mrc_CONC_top
dm_a = dm;
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
for noun_i=1:16
    for verb_j=1:30%length(dimWords)
        imageData=[];
        if 1%~isDone(noun_i,verb_j)
            %         nouns{noun_i}='apple';
            %         dimWords{verb_j}='green'
            % _apple_NOUN=>yellow_ADJ
            %  %  web('https://books.google.com/ngrams/graph?content=apple%3D%3Egreen&year_start=1800&year_end=2000&corpus=15&smoothing=3')
            searchString=['https://books.google.com/ngrams/graph?content=' nouns{noun_i} '_NOUN%3D%3E' dimWords{verb_j} '_ADJ&year_start=1800&year_end=2000&corpus=15&smoothing=3'];
            web(searchString);%'https://books.google.com/ngrams/graph?content=apple%3D%3Eyellow&year_start=1800&year_end=2000&corpus=15&smoothing=3')
            disp('start')
            pause(1)
            disp('finish')
            imageData = screencapture(0, [26 201 1600 800]);
            imageDataOld=imageData;
            if mean(mean(mean(imageData(200:300,800:900,:)==255)))==1
                disp('too many requests')
                pause(30)
            end
            lineLength=0;
            ccc=0
            while 1
                ccc=ccc+1
                imageData = screencapture(0, [26 201 1600 800]);
                if std(double(imageData(:)))==std(double(imageDataOld(:)))
                    break
                else
                    
                    imageData = screencapture(0, [26 201 1600 800]);
                    imageDataOld=imageData;
                end
                pause(.2)
            end
            
            
            
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
            
            
            
            if length(lineInd)<200%all([247 234 173]==squeeze(imageData(200,800,:))')
                distanceStuff(noun_i,verb_j)=0;
            else
                % imagesc(lineIm(:,lineInd,:))
                
                % imagesc(lineIm(:,ii)))
                disp('what')
                
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
%%                
                %         imagesc(imageData(min(axInd):max(axInd),lineInd,:));
               % imagesc(imageData(200:end,10:min(lineInd),:));%-23)
                ocrIm=imageData(gridTop-10:gridBottom+10,10:min(lineInd)-7,:);
                imagesc(ocrIm);
                %                 pause(.2)
                %         while 1
              results = ocr(rgb2gray(ocrIm),'CharacterSet','.01234567890%','TextLayout'  ,'Block')
              
              theseWords=results.Words
                theseConfidences=results.WordConfidences
                theseYs=results.WordBoundingBoxes(:,2)+results.WordBoundingBoxes(:,4)/2;
                
                
               % get rid of uncertain words
                 theseWords(theseConfidences<.7)=[];
                 theseYs(theseConfidences<.7)=[];
                 theseConfidences(theseConfidences<.7)=[];
                %%
                %             if length(results.Words)>4
                %                 break
                %             end
                %         end
                
                disp('HERE')
                clear test
                cc=0;
                
                for ii=length(theseWords):-1:1
                    cc=cc+1;
                    try
                        test(ii)=str2double(theseWords{ii}(1:end-1));
                        
                    catch
                        disp(['missed: ' theseWords{ii}(1:end-1)])
                    end
                    
                    test(test>=1)=[];
                end
                test(test>=1)=[];
                
                
                
                yUpper=test(find(test==max(test)));
                highest=theseYs(find(test==max(test)))+gridTop-10;
                
                
                
%                 highest=gridTop;
                lowest=gridBottom;%find(test==min(test));
                scale=yUpper/(lowest-highest);
                
                %         lowest=lowest(end);
                %  lowest=size(imageData,1)-results.WordBoundingBoxes(lowest,2);
                % highest=size(imageData,1)-results.WordBoundingBoxes(highest,2)
                plot(keep*scale)
                distanceStuff(noun_i,verb_j)=mean(keep*scale);
                mean(keep*scale)
                %%
                isDone(noun_i,verb_j)=1;
                save isDone isDone
            end
        end
    end
    toc
end

%lineInd=find(sum(lineIm()))