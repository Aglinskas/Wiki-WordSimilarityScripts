Screen('Preference', 'SkipSyncTests', 1);
[win screenrect] = Screen('OpenWindow',0,[127 127 127])
%% Define some rects
rectSize = 100;
gridSize = 3;
    displaySize = gridSize*rectSize
    rectCount = 0;
    myRects = []
for x = 1:rectSize:rectSize*gridSize
for y = 1:rectSize:displaySize
    rectCount = rectCount+1
    myRects(rectCount,:) = [x y x+rectSize/2 y+rectSize/2]
end
end
% Center the grid 
myRects(:,[1 3]) = myRects(:,[1 3]) + screenrect(3) / 2  -displaySize/2
myRects(:,[2 4]) = myRects(:,[2 4]) + screenrect(4) / 2  - displaySize/2
%% Draw Grid
for rect_ind = 1:rectCount
Screen('FillRect',win,[255 0 0],myRects(rect_ind,:))
end
%Screen('FillRect',win,[0 255 0],myRects(rectCount,:))
Screen('Flip',win)
%% Mouse Check
keepChecking = 1;
while keepChecking
[x,y,buttons] = GetMouse(win);
for checkRect_ind = 1:rectCount
    isInside = x > myRects(checkRect_ind,RectLeft) & x < myRects(checkRect_ind,RectRight) & y > myRects(checkRect_ind,RectTop) & y< myRects(checkRect_ind,RectBottom);
    if isInside
        clc;disp(['Cursor is inside square ' num2str(checkRect_ind)]);
        
for rect_ind = 1:rectCount
Screen('FillRect',win,[255 0 0],myRects(rect_ind,:));
end
Screen('FillRect',win,[0 255 0],myRects(checkRect_ind,:));
Screen('Flip',win);
    end
end % ends checkrec 
end % ends while looop


