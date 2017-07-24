%   This is for the Jason 2 Analysis script
%   It may be necessary to do modification for Envisat 
%   This was written on 11/04/2015: Date format on computer
%   Last modified on 11/04/2015
%clc,clear all;

%%

WaterInfo = inputdlg({'Plot Title ','Minimum Latitude ',...
    'Maximum Latitude' }, 'Inland Water Body Info', [1 40;1 40;1 40]); 

lat_range=[str2num(WaterInfo{2}),str2num(WaterInfo{3})];

[FileName, PathName, ext] =uigetfile({'*.txt';'*.mat'},'Select Extracted Altimetry Data');
[pathstr,name,ext]=fileparts(FileName);
FilePath = strcat(PathName,FileName);
Binari = strcmp(ext,'.txt');
if Binari == 1;
    Alldata_info=load(FilePath);
    
else
    load(FilePath);
end
load('geoidegm2008grid.mat'); % loads the EMG2008 Grid file

Uniq_cyc_info= unique(Alldata_info(:,10)); % Check unique cycles
Index =find(Alldata_info(:,9)==0);
Alldata=Alldata_info(Index,10:end);
%%


indx=find(Alldata(:,4)>lat_range(1) & Alldata(:,4)<lat_range(2)); % Limit by latitude range
Data_Seg=Alldata(indx,:); % Data for Virtual Station along track
cyc_Seg=unique(Data_Seg(:,1));
%%
[Lower_All,Upper_All] =iqrange(Data_Seg);
indx_limit_All = find(Data_Seg(:,5)>Lower_All & Data_Seg(:,5)<Upper_All);
Data_Seg_IQR= Data_Seg(indx_limit_All,:);
%%

timeseries_report=altimetryoutlier( Data_Seg_IQR );
%%
[Lower,Upper] =iqrange(timeseries_report);
indx_limit = find(timeseries_report(:,5)>Lower & timeseries_report(:,5)<Upper);
FinalSeries= timeseries_report(indx_limit,:);

N=interp2(lonbp,latbp,grid,FinalSeries(:,3),FinalSeries(:,4));%Geoidal undulation;
Hgt_Datum=FinalSeries(:,5)-N; % Reduced to WG84 
FinalSeries(:,5)=Hgt_Datum;
%%
FinalSeries=decyear2matdate(FinalSeries,2); 
DATEstr= datestr(FinalSeries(:,10),'yyyy/mm/dd/HH/MM/SS');
%dlmwrite(strcat(FileName(1:end-4),'.csv'),FinalSeries(:,1:7),'precision',20)
%%
BB=FinalSeries(:,[1,5,6,2]);  % output customized for Training in Vietnam
BBstr= num2str(BB);
Out= strcat(BBstr,{' '},DATEstr);

outfolder='./time_series';
if exist(outfolder,'dir')~=7   
   mkdir(outfolder);
end

dlmwrite(strcat(outfolder,'/',FileName(1:end-4),'_out','.txt'),Out,'delimiter','');
%%
%%
h1 = figure(1); clf
set(gca,'DefaultTextFontSize',24,'FontName','Times New Roman');
plot(FinalSeries(:,2),FinalSeries(:,5),'b.-','linewidth',2,'markersize',15);  grid on; hold on;
errorbar(FinalSeries(:,2),FinalSeries(:,5),FinalSeries(:,6))   ;
xlabel('Year');
ylabel('Water Elevation w.r.t EGM-2008 (m)');
set(gca,'fontweight','bold');
Plot_title= strcat(WaterInfo{1}, ', Sentinel-3 NTC Orbit-', FileName(9:11),'  Lon=%6.3f Lat=%6.3f');
str=sprintf(Plot_title,mean(FinalSeries(:,3)),mean(FinalSeries(:,4))');
%str=sprintf('Tonle Sap, Jason-2 Pass-001 Lon=%6.3f Lat=%6.3f',mean(FinalSeries(:,3)),mean(FinalSeries(:,4))');

title(str);
set(h1,'Units','inches','Position',[1 1 13.33 7.29]);
saveas(h1,strcat(outfolder,'/',name,'.jpg'))
%**************************************************************************
