ScrSize = [400 400]
load('c.mat')

%%
[win,myScreen]=Screen('OpenWindow',0,[125 125 125],[0 0 ScrSize])
text = 'Press Any Key To Start'
DrawFormattedText(win, text,'center','center',[0 0 0]);Screen('flip',win)

KbWait

ncats = length(c);
catOrd = 1:ncats
nTrials = length(c(1).clust_elements_inds);
TrialOrd = 1:nTrials;
for cat_ind = catOrd
text = sprintf('How typical is this item for category:\n\n%s\n\nPress any key',c(cat_ind).name);
DrawFormattedText(win, text,'center','center',[0 0 0]);Screen('flip',win)
KbWait
DrawFormattedText(win, text,'center','center',[0 125 0]);Screen('flip',win);pause(1)
for trial = TrialOrd
 
    stim = c(cat_ind).clust_elements_str{trial};
    stim = strrep(stim,'-n','');
    
    text = stim;
DrawFormattedText(win, text,'center','center',[0 0 0]);Screen('flip',win);
t.presented = GetSecs;

keyIsDown = 0;
time_to_respond = 2;
while ~keyIsDown & GetSecs < t.presented + time_to_respond
    [keyIsDown, secs, keyCode] = KbCheck;
end


end
end