[win, screenRect]=Screen('OpenWindow',0,[224 224 224],[0 0 640 640])
oneRect=[200 200 401 401]
Screen(win,'FillRect',[0 30 50], oneRect);
Screen(win,'Flip')
myStart=GetSecs


% something
while true
    [mouseX,mouseY,buttons] = GetMouse(win);
    if mouseX < oneRect(3) & mouseY < oneRect(4) & mouseX > (oneRect(1)) & (mouseY) > oneRect(2)
    if buttons(1)
        break
    end
    end
end
sca
% something




