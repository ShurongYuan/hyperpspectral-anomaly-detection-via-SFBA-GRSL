clc;
clear all;
load '11.mat';
load 'new_11.mat';
X=data;
Mask=map;
[XX,YY,band]=size(X);
M=XX*YY;
disp('Running ROC...');
mask = reshape(Mask, 1, M);
anomaly_map = logical(double(mask)>=1);
normal_map = logical(double(mask)==0);
finalS=new_11+0.00001;
r_max = max(finalS(:));%%%%%%%
taus = linspace(0, r_max, 5000);
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
ROC_grx8(1,1:length(taus))=FPR;
ROC_grx8(2,1:length(taus))=TPR;
% area0 =  sum((PF(1:end-1)-PF(2:end)).*(PD(2:end)+PD(1:end-1))/2);
figure,
plot(FPR, TPR, 'g-*', 'LineWidth', 2);  hold on
ROC_GLRT_10(1,:)=FPR;
ROC_GLRT_10(2,:)=TPR;
save('ROC_GLRT_10.mat','ROC_GLRT_10');
