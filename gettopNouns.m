function [topNouns] = gettopNouns

fid=fopen('./DataMatrices/topNouns');
TextLine='xxx'
topNouns=[];
while ischar(TextLine)
    TextLine = fgetl(fid);
   
    if -1==TextLine
        break
    end
    
    sent=textscan(TextLine,'%s');
    niggle=sent{1}{1};
    topNouns{end+1}=niggle;
end
topNouns=lower(topNouns);
fclose(fid)