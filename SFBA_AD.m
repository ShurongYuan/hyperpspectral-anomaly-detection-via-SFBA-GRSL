clear all;
clc;
load('11.mat');
% data=X;
%%%%%%%%%选择的波段数目%%%%%
tic
[XX,YY,band]=size(data);
data_2D=reshape(data,XX*YY,band);
N_band=60;        %set the number of selected bands
% %%%%%%%%随机指定%%%%%%%
% figure
% zzz=data(:,:,20)/max(max(data(:,:,20)));
% rgb = label2rgb(gray2ind(zzz, 255), jet(255));
% imshow(rgb);
% selected_band=[10 20 30 40 50 60 70 80 90 100];
for i=1:band
    mean_each=mean(data_2D(i,:));
    temp=data_2D(i,:)-mean_each;
    var(i)=sum(temp.^2)/(XX*YY);
end
[var_sort,index]=sort(var);
numzero=length(find(var_sort==0));
selected_band=index(numzero+1:numzero+N_band);

%%%%将选择的波段分为n组%%%%
n=15;
for i=1:n
    data1=data_2D(:,[selected_band((i-1)*N_band/n+1:i*N_band/n)]);
    RXresult=RX(data1);
    norm_RX=RXresult/max(max(RXresult));
    socerRX(:,:,i)=norm_RX;
    
%      figure
%      imshow(norm_RX);
%     rgb1 = label2rgb(gray2ind(RXresult/max(max(RXresult)), 255), jet(255));
%     % imshow(rgb1);

    RXhist=histogram(RXresult); 
    norm_RXhist=RXhist/max(max(RXhist));
    socerhist(:,:,i)=norm_RXhist;
    r=max(svd(norm_RX));
    h=max(svd(norm_RXhist));
%     figure
%     imshow(norm_RXhist);


    total_score=(r/(r+h))*norm_RX+(h/(r+h))*norm_RXhist;
%     figure
%     imshow(total_score);
%     rgb = label2rgb(gray2ind(RXhist, 255), jet(255));
    Binary=zeros(XX,YY);
    Binary(total_score>0.4)=1;
    Binary_total(:,:,i)=Binary;
    score_total(:,:,i)=total_score;
%     figure
%     imshow(Binary);

end
% Bin_sum=sum(score_total,3);
Bin_sum=sum(Binary_total,3);
finalS=Bin_sum/(max(max(Bin_sum)));
toc
figure
imshow(finalS);
% newAD=zeros(XX,YY);
% % newAD(finalS>0.8)=1;
% figure
% imshow(map);
% % [x1,x2]=meshgrid([1:XX],[1:YY]);
% % mesh(x1,x2,Bin_sum);
new_11=finalS;
save('new_11.mat','new_11');
 toc 
% time1=toc;