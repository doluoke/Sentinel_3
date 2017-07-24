%% This code was given to me by Dr Lee with the initial version as script,
%change_year.m

function in_Data=decyear2matdate(in_Data,Date_Column)
    %Date_Column is the column of the decdate in the in_Data

    [inD_row, inDFields]=size(in_Data);

    year = in_Data(:,Date_Column); % column of the decyear data
    mjd_ = (year-1990)*365.25 - 2108 + 50000;

    for i=1:length(mjd_)
        YYYY_MM_DD= mjd2gre([mjd_(i)*86400 0]);

        in_Data(i,inDFields+1)=datenum(YYYY_MM_DD(1), YYYY_MM_DD(2), YYYY_MM_DD(3),...
            YYYY_MM_DD(4), YYYY_MM_DD(5), YYYY_MM_DD(6)); % Matlabdate
        
        
    end
  

