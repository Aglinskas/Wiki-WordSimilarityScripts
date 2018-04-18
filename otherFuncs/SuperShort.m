load('/Users/scott/Library/Containers/com.apple.mail/Data/Library/Mail Downloads/F184D76D-4B30-4915-B87E-7556261B336A/denseMatrix_MRC_top1000Verbs.mat')
A=textread('wordlist_mrc_CONC_sel','%s');
cc=0;
word=[];
for ii=1:2:length(A)
    cc=cc+1;
    word{cc}=A{ii};
end
B=textread('dimWords_topVerbs1000','%s');
cc=0;
verbs=[];
for ii=1:2:length(B)
    cc=cc+1;
    verb{cc}=B{ii};
end
distanceTechniques={'euclidean', 'minkowski' 'chebychev' , 'mahalanobis','cosine' ,'correlation','spearman',...
    'hamming' ,'jaccard' };
distanceTechniques=distanceTechniques([ 5 6 ]);
linkTechniques={ 'ward' };%'single','complete' ,'average','weighted','centroid', 'median' ,} ;
cc=0;
figure
for ii= 1:length(distanceTechniques)
    for jj=1:length(linkTechniques)
        cc=cc+1;
       try
            Y=pdist(dm_verb,distanceTechniques{ii});
            Z=linkage(Y,linkTechniques{jj} );%,{'correlation'} );
            subplot(length(distanceTechniques),length(linkTechniques),cc)
            [H,T] = dendrogram(Z,size(dm_verb,1));%,'Labels',word' ,'ColorThreshold' ,1.4 );
        catch
            disp('failed')
        
        end
    end
end