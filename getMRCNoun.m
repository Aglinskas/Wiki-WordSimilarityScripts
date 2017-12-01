function [MRCnoun] = getMRCNoun

fidOut=fopen('nonsense.txt','wt')
fid=fopen('./DataMatrices/wordlist_mrc_CONC');
TextLine='xxx'
MRCnoun=[];
while ischar(TextLine)
    TextLine = fgetl(fid);
    if -1==TextLine
        break
    end
    MRCnoun{end+1}=TextLine;
end
MRCnoun=lower(MRCnoun);
fclose(fid)
fclose(fidOut)