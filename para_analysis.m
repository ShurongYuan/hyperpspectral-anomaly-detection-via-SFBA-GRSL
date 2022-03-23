clear all;
clc;
load('11.mat');

Mask=map;
%%%%%%%%%选择的波段数目%%%%%
[XX,YY,band]=size(data);
M=XX*YY;
data_2D=reshape(data,XX*YY,band);
%%%%%%波段选择
for i=1:band
    mean_each=mean(data_2D(i,:));
    temp=data_2D(i,:)-mean_each;
    var(i)=sum(temp.^2)/(XX*YY);
end
yyy=1;
n=8;

for N_band=10:10:100

[var_sort,index]=sort(var);
numzero=length(find(var_sort==0));
selected_band=index(numzero+1:numzero+N_band);

mask = reshape(Mask, 1, M);
anomaly_map = logical(double(mask)>=1);
normal_map = logical(double(mask)==0);


    for i=1:n
        data1=data_2D(:,[selected_band((i-1)*N_band/n+1:i*N_band/n)]);
        RXresult=RX(data1);
        norm_RX=RXresult/max(max(RXresult));
        socerRX(:,:,i)=norm_RX;
        RXhist=histogram(RXresult); 
        norm_RXhist=RXhist/max(max(RXhist));
        socerhist(:,:,i)=norm_RXhist;
        r=max(svd(norm_RX));
        h=max(svd(norm_RXhist));
        total_score=(r/(r+h))*norm_RX+(h/(r+h))*norm_RXhist;
        Binary=zeros(XX,YY);
        Binary(total_score>0.4)=1;
        Binary_total(:,:,i)=Binary;
        score_total(:,:,i)=total_score;
    end
    Bin_sum=sum(Binary_total,3);
    finalS=Bin_sum/(max(max(Bin_sum)));
    finalS=finalS+0.00001;
    r_max = max(finalS(:));
    taus = linspace(0, r_max, 500);
    for index2 = 1:length(taus)
        tau = taus(index2);
        anomaly_map_rx = logical(finalS> tau);%%%%%%%%%%%
        no_map=logical(finalS<=tau);%%%%%%%
        n_m=reshape(no_map,1,M);
        a_m_r=reshape(anomaly_map_rx,1,M);
        TP(index2)=sum(a_m_r & anomaly_map);
        FP(index2)=sum(a_m_r & normal_map);
        FN(index2)=sum(n_m & anomaly_map);
        TN(index2)=sum(n_m & normal_map);
        TPR(index2)=TP(index2)/(TP(index2)+FN(index2));
        FPR(index2)=FP(index2)/(FP(index2)+TN(index2));
    end
    area0(yyy)=sum((FPR(1:end-1)-FPR(2:end)).*(TPR(1:end-1)+TPR(2:end))/2);
%     xulei11(yyy)=bin;
    yyy=yyy+1;
end
n_11=area0;





