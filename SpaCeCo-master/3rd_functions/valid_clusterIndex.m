function [indx,ssw,sw,sb]=valid_clusterIndex(data,labels,metric)
% clustering validation indices 
% Kaijun WANG, sunice9@yahoo.com, May 2005, Oct. 2006
[nr,nc]=size(data);
k=max(labels);
[st,sw,sb,S,Sinter] = valid_sumsqures(data,labels,k);
ssw=trace(sw);
ssb=trace(sb);
switch metric
    case 1      % mean Silhouette
        Sil = silhouette(data,labels);
        indx = mean(Sil);%/std(Sil);
%         eva = evalclusters(data,labels','silhouette'); % the same as the above
%         indx=eva.CriterionValues;
    case 2      % mean Davies-Bouldin
        eva = evalclusters(data,labels','DaviesBouldin');
        indx=eva.CriterionValues;
    case 3      % Calinski-Harabasz
        eva = evalclusters(data,labels','CalinskiHarabasz');
        indx=eva.CriterionValues;
    case 4      % Krzanowski and Lai
        indx=(k^(2/nc))*ssw; 
    case 5      %Dunn's index
        indx=dunns(2,squareform(pdist(data)),labels); 
    case 6      %Bhattacharyya distance
        indx=bhattacharyya(data(labels==1),data(labels==2));
    case 7      %DWT
        indx=dtw(data(labels==1),data(labels==2));
    case 8 %Clustering validity index  Halkidi et al. 2001
        sum=0;
        for i=1:max(labels)
            sum=sum+norm(var(data(labels==i,:)));
        end
        stdev=1/max(labels)*sqrt(sum);
        sum2=0;
        for i=1:max(labels)
            for j=1:max(labels)
                if i~=j
                    center_i=mean(data(labels==i,:));
                    center_j=mean(data(labels==j,:));
                    mid_point=(center_i(:)+center_j(:)).'/2;
                    temp=(density(data,mid_point,stdev)/max(density(data,center_i,stdev),density(data,center_j,stdev)));
                    sum2=sum2+max(temp,0);
                end
            end
        end
        indx=sum2+(sum/max(labels))/norm(var(data));       
end
indx(isinf(indx))=0;

function out=density(data,center,stdev)
temp=pdist2(data,center);
out=sum(temp<=stdev);
