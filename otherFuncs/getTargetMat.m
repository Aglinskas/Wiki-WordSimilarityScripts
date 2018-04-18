function cb4=getTargetMat
for ii=1:160
    word{ii}=num2str(ii);
end

cb1=double(checkerboard(5,10)==0);
subplot(2,2,1),imagesc(cb1)


cb2=double(checkerboard(10,5)==0);
subplot(2,2,2),imagesc(cb2)

cb3=double(checkerboard(20,3)==0);
cb3=cb3(1:100,1:100);
% cb2=cb2(1:size(cb1,1),1:size(cb1,2))
subplot(2,2,3),imagesc(cb3)

%
myDiag3=imresize(eye(5),size(cb3,1)/5,'Method','box');
myDiag2=imresize(eye(10),size(cb3,1)/10,'Method','box');
myDiag1=imresize(eye(20),size(cb3,1)/20,'Method','box');


% subplot(2,2,1),imagesc(myDiag2)
subplot(2,2,4)
% cb4=(cb1.*myDiag1*.5+cb2.*myDiag2*.2+cb3.*myDiag3*.075);
cb4=(cb1.*myDiag1+cb2.*myDiag2+cb3.*myDiag3);
cb4=cb4./max(cb4(:));
imagesc(cb4)