function HBOS1=histogram(data,map)
    [XX,YY,band]=size(data);
    bin=XX*20;%总共可以分为bin份
    for i=1:band
        %%%%%%对每一个波段的二维图像求其直方图%%%%%%
        data_2d=data(:,:,i);
        data_1d=reshape(data_2d,XX*YY,1);
        [sort_data,index]=sort(data_1d);
        bin_num=floor(XX*YY/bin);
        for j=1:bin-1
            hist(j)=1/(sort_data(j*bin_num+1)-sort_data((j-1)*bin_num+1));
            averge(j)=0.5*((sort_data(j*bin_num)+sort_data((j-1)*bin_num+1))/max(data_1d));
        end
        j=j+1;
        hist(j)=1/(sort_data(j*bin_num)-sort_data((j-1)*bin_num+1));
        averge(j)=0.5*((sort_data(j*bin_num)+sort_data((j-1)*bin_num+1))/max(data_1d));
        for m=1:bin
            score(index((m-1)*bin_num+1:m*bin_num))=hist(m);
        end
        index=find(score==inf);
        score(index)=0;
        T_score(i,:)=score/max(score);
    end
    
    result=log(1./T_score);
    result(index)=0;
    %%%%%%%%%%去除无穷大的值
    index_nan=find(isnan(result));
    index_inf=find(isinf(result));
    gg=reshape(result,band*(XX*YY),1);
    gg(index_nan)=0;
    gg(index_inf)=0;

    Result=reshape(gg,band,XX*YY);
%     HBOS=sum(Result);
    HBOS1=reshape(Result,XX,YY)/max(Result); 
end
