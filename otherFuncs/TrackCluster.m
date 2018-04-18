targetPersonVerbs=lower({'TWIST','SCREW','GRAB'});
% find targets and assoicates - arbitrary cluster thresh could be imporved
[H,T] = dendrogram(Z,15);
for jj=1:size(myCluster,1)
    for ii=1:size(myCluster,2)
        if ~isempty(myCluster{jj,ii})
        locat=ismember(targetPersonVerbs,myCluster{jj,ii});
        
        if sum(locat)>length(targetPersonVerbs)*.8
            myCluster{jj,ii}
            break
        end
        end
    end
    
end
%     % now clear
%     word(targInd)=[];
%     dm_verb(targInd,:)=[]; % CLEAR VERBS TOO?
%    Freq(targInd)=[];
    
    % rerun