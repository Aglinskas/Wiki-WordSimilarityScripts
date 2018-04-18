%% Select the 'concrete' verbs using the model of all concrete nouns from MRC and 'all' verbs (1866)
% Two similar methods: results printed to dimWords_selTopVerbs(2)
modelName = 'dm_EN-wform.w.2.ppmi.wordlist_mrc_CONC_topVerbs.mat';
load(modelName);
[n_row,n_col] = size(dm_topVerbs)
% dimension words
fid = fopen('../topVerbs');
strings = textscan(fid,'%s%f');
fclose(fid);
dimWords = strings{1}
freqs = strings{2}

% target words
fid = fopen('wordlist_mrc_CONC');
strings = textscan(fid,'%s',...
    'Headerlines',2,'Delimiter','\n');
fclose(fid);
strings = strings{1}
targWords = cell(n_row,1);
for i = 1:length(strings)
    str = strsplit(strings{i});
    targWords{i} = str{1};
end
%skip 20th 'arm'
for i = 20:n_row
    targWords{i} = targWords{i+1};
end
targWords = targWords(1:n_row);
targWords{1}
targWords{length(targWords)}

%% method 1, turn the original ppmi scores into either 1 or 0
colsum = sum((dm_topVerbs>0),1)';
norm = colsum./log(freqs);
% Let's take the top 75%
thrs = prctile(norm,75)
plot(norm);
idConcreteVerbs = find(norm>=thrs);
conVerbs = dimWords(idConcreteVerbs)
% PRINT TO
fid = fopen('../dimWords_selTopVerbs')
selTopVerbs = textscan(fid,'%s','Delimiter','\n')
fclose(fid);

%% method 2
colsum = sum(dm_topVerbs,1)';
norm = colsum./log(freqs);
% Let's take the top 75%
thrs = prctile(norm,75)
%plot(norm);
idConcreteVerbs2 = find(norm>=thrs);
conVerbs2 = dimWords(idConcreteVerbs2);
% PRINT TO
fid = fopen('../dimWords_selTopVerbs2')
selTopVerbs2 = textscan(fid,'%s','Delimiter','\n')
fclose(fid);

% ==> 82 different verb difference
% ==> Method 2 looks better
