function [MRCverb] = getVerb

fid=fopen('./DataMatrices/dimWords_selTopVerbs');
TextLine='xxx';
MRCverb=[];
while ischar(TextLine)
    TextLine = fgetl(fid);
    
    if -1==TextLine
        break
    end
    
    sent=textscan(TextLine,'%s');
    niggle=sent{1,1};
    MRCverb{end+1}=niggle{1};
end
fclose(fid)


fid=fopen('./DataMatrices/dimWords_selTopVerbs2');
TextLine='xxx';
while ischar(TextLine)
    TextLine = fgetl(fid);
    
    if -1==TextLine
        break
    end
    sent=textscan(TextLine,'%s');
    niggle=sent{1,1};
    MRCverb{end+1}=niggle{1};
    
    
end
MRCverb=lower(MRCverb);
fclose(fid)