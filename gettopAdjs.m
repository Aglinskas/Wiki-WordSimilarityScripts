function [topAdjs] = gettopAdjs

fid=fopen('./DataMatrices/topAdjs');
TextLine='xxx'
topAdjs=[];
while ischar(TextLine)
    TextLine = fgetl(fid);
    
    if -1==TextLine
        break
    end
    sent=textscan(TextLine,'%s');
    topAdjs{end+1}=sent{1}{1};
end
topAdjs=lower(topAdjs);
fclose(fid)