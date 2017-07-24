function [ lower_Lim, upper_Lim ] = iqrange( Data_4lim )
%IQRANGE Summary of this function goes here
%   Detailed explanation goes here
Q1=quantile(Data_4lim(:,5),0.25);
Q3=quantile(Data_4lim(:,5),0.75);
IQR=iqr(Data_4lim(:,5)); % Compute IQR
lower_Lim=Q1-(1.5*IQR); % Lower Limit
upper_Lim=Q3+(1.5*IQR); % Upper limit
% indx_limit_All = find(Data_Seg(:,5)>lower_Lim & Data_Seg(:,5)<Upper_All);
% Data_Seg_IQR= Data_Seg(indx_limit_All,:);

end

