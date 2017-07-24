function s3_reader(Data_Folder,In_Pass, lat_range, File_Suffix_name)

current_folder=pwd;

outfolder=[current_folder,'\extract'];
if exist(outfolder,'dir')~=7    
   mkdir(outfolder);
end

if length(In_Pass)==1
    In_Pass=['00',In_Pass];
elseif length(In_Pass)==2
    In_Pass=['0',In_Pass];
end


% For each cycle
bar=waitbar(0,'Extracting...');
count=0;

% % -----------------------------------------------------------------------
% % Sentinel-3 data were processed and distributed in three product types :
% %  1. Near Real-Time (NRT): available 3 hrs
% %  2. Slow-Time Critical (STC): available within 48 hrs
% %  3. Non-Time Critical (NTC): available 1 month
% %  after data acquisition.
% %
% % PLEASE BE AWARE : 
% %  Currently only "Non-Time Critical" product has 
% %  available GIM ionospheric correction data.
% %  (Neither "Near Real-Time" nor "Slow-Time Critical" has it)
% % -----------------------------------------------------------------------

secd2day=1/86400;      % seconds per day
mjd_of_time_org=51544; % MJD of 2000-01-01, 00:00:00 (YYYY-MM-DD, hh:mm:ss)

global time_01 time01_FillValue 
global time_20_ku time_20_ku_FillValue 
global lon_20_ku lon_20_ku_FillValue 
global lat_20_ku lat_20_ku_FillValue 
global pole_tide_01 pole_tide_01_FillValue 
global solid_earth_tide_01 solid_earth_tide_01_FillValue 
global iono_cor_alt_20_ku iono_cor_alt_20_ku_FillValue 
global iono_cor_gim_01_ku iono_cor_gim_01_ku_FillValue 
global mod_dry_tropo_cor_meas_altitude_01 mod_dry_tropo_cor_meas_altitude_01_FillValue 
global mod_dry_tropo_cor_zero_altitude_01 mod_dry_tropo_cor_zero_altitude_01_FillValue 
global mod_wet_tropo_cor_meas_altitude_01 mod_wet_tropo_cor_meas_altitude_01_FillValue 
global mod_wet_tropo_cor_zero_altitude_01 mod_wet_tropo_cor_zero_altitude_01_FillValue 
global alt_20_ku alt_20_ku_FillValue 
global range_ice_20_ku range_ice_20_ku_FillValue 
global range_ice_sheet_20_ku range_ice_sheet_20_ku_FillValue 
global range_ocean_20_ku range_ocean_20_ku_FillValue 
global range_ocog_20_ku range_ocog_20_ku_FillValue 
global range_sea_ice_20_ku range_sea_ice_20_ku_FillValue 
global sig0_ice_20_ku sig0_ice_20_ku_FillValue 
global sig0_ice_sheet_20_ku sig0_ice_sheet_20_ku_FillValue 
global sig0_ocean_20_ku sig0_ocean_20_ku_FillValue 
global sig0_ocog_20_ku sig0_ocog_20_ku_FillValue 
global sig0_sea_ice_sheet_20_ku sig0_sea_ice_sheet_20_ku_FillValue 
global surf_class_20_ku surf_class_20_ku_FillValue 
global surf_type_20_ku surf_type_20_ku_FillValue 
% global waveform_20_ku % Only "enhanced_measurement.nc" has it.


% % -------------- Give corresponding orbit number of VSs -----------------
% orbit={'338'};

% % ------ Give lat. boundary of correspounding VSs and orbits number -----
% % [lower boundary;
% %  upper boundary]

lat_boundary=lat_range;

% % -------------- Extract file needed for each VS station ----------------
% for sta=1:length(orbit)
    orbit_num=In_Pass;
    output_file_name=File_Suffix_name;
% % --------- Get all file directory based on giving orbit number ---------
	cd(Data_Folder);
    filedir=strcat('*_',num2str(orbit_num,'%.3i'),'______*');	
    all_path=dir(filedir);
    cd(current_folder);	
%     if length(all_path)==0
%        continue
%     end

% % ---------- Extract data of given orbit number from cycles -------------
    for fn=1:length(all_path)
% % ----------------- Get directory of one cycle file ---------------------
        path=all_path(fn).name;
        cycno=str2num(path(length(path)-29:length(path)-27));
		
        Fraction= floor((fn/length(all_path))*100);
        formatSpec = 'Extracting...%d%% complete';
        str=sprintf(formatSpec,Fraction);
        waitbar(Fraction/100,bar, str);		
		
        ncid=netcdf.open([Data_Folder,'\',path,'\standard_measurement.nc'],'NC_WRITE');   
%         ncid=netcdf.open([path,'\enhanced_measurement.nc'],'NC_WRITE');   
        

%% ---------------------- GET VARIABLES NEEDED ------------------------- %%
% ------------------------- Observation Time ------------------------------
        variable_extract(ncid,'time_01');
        variable_extract(ncid,'time_20_ku');
        variable_extract(ncid,'lon_20_ku');
        variable_extract(ncid,'lat_20_ku');

% % --------------------- Geophysical Corrections -------------------------
        variable_extract(ncid,'pole_tide_01');
        variable_extract(ncid,'solid_earth_tide_01');

% % ---------------------    Media Corrections    -------------------------
        variable_extract(ncid,'iono_cor_alt_20_ku');
        variable_extract(ncid,'iono_cor_gim_01_ku');
        variable_extract(ncid,'mod_dry_tropo_cor_meas_altitude_01');
        variable_extract(ncid,'mod_dry_tropo_cor_zero_altitude_01');
        variable_extract(ncid,'mod_wet_tropo_cor_meas_altitude_01');
        variable_extract(ncid,'mod_wet_tropo_cor_zero_altitude_01');

% % ----------------------  Satellte Altitude   ---------------------------
        variable_extract(ncid,'alt_20_ku');
        
% % ------------------ Retracked Range Measurements -----------------------
% % Ice retracking :
% % ice-2 retracker was implemented. Only applied to LRM mode ice waveforms
        variable_extract(ncid,'range_ice_20_ku');
        variable_extract(ncid,'sig0_ice_20_ku');

% % Ice sheet retracking : 
% % Different retrackers were implemented to LRM and SAR mode when operating over ice-sheets.
        variable_extract(ncid,'range_ice_sheet_20_ku');
        variable_extract(ncid,'sig0_ice_sheet_20_ku');

% % Ocean retracking :
% % Different retrackers were implemented to LRM and SAR mode
% % LRM : Ocean-3
% % SAR : Fully analytical retracker for SAR (over open ocean and coastal zone)
        variable_extract(ncid,'range_ocean_20_ku');
        variable_extract(ncid,'sig0_ocean_20_ku');

% % OCOG re-tracking (ice-1) :
% % ice-1 retracker was implemented to LRM mode for ice surfaces and SAR mode for sea-ice margins
        variable_extract(ncid,'range_ocog_20_ku');
        variable_extract(ncid,'sig0_ocog_20_ku');

% % Sea-ice retracking :
% % A single retracker implemented to SAR mode sea-ice waveforms
        variable_extract(ncid,'range_sea_ice_20_ku');
        variable_extract(ncid,'sig0_sea_ice_sheet_20_ku');

% % ----------------------- Surface Class/Type ----------------------------
% % Computed from a mask built with MODIS and GlobCover data
% % 0 1 2 3 4 5 6
% % open_ocean land continental_water aquatic_vegetation continental_ice_snow floating_ice salted_basin
        variable_extract(ncid,'surf_class_20_ku');

% % 0 1 2 3
% % ocean_or_semi_enclosed_sea enclosed_sea_or_lake continental_ice land
        variable_extract(ncid,'surf_type_20_ku');

% % ------------------------ Waveform Sample ------------------------------
% % Only "enhanced_measurement.nc" has it. Sample size is 128.
%       variable_extract(ncid,'waveform_20_ku');

% % -----------------------------------------------------------------------


% % --------------------- Data Flag Information ---------------------------
% % There are no variables of :
% % 1. Altimeter altitude state quality
% % 2. Retracking quality
% % 3. lat_20_ku _FillValue
% % in the .nc file.

% % -------------------------- Data Output --------------------------------
% % Flag condition output order : 
% % dyr_trop  wet_trop  iono_gim  solid_earth_tide  pole_tide  alt_20_ku  retracked_range  sig0 TotalFlags
% % Only data whose TotalFlags equals 0 are printed.
 
% % How to identify corresponding 20Hz data of each 1Hz correction term:
% % 1. Use time tag of 20Hz and 1Hz data (time_20_ku, time_01)
% % 2. +/-0.5 to time_01 and find the corresponding 20Hz data within the range of each time_01 time tag
% % 3. Add correction to the corresponding 20Hz range measurements.

        dim_01hz=size(time_01);

        mjd_20_ku=time_20_ku.*secd2day+mjd_of_time_org;

        time_intv=[time_01-0.5 time_01+0.5];
                
        for i=1:dim_01hz(1)
            if pole_tide_01(i)==pole_tide_01_FillValue
               pole_tide_01_Flag=1;
            else
               pole_tide_01_Flag=0;
            end
            
            if solid_earth_tide_01(i)==solid_earth_tide_01_FillValue
               solid_earth_tide_01_Flag=1;
            else
               solid_earth_tide_01_Flag=0;
            end
            
            if iono_cor_gim_01_ku(i)==iono_cor_gim_01_ku_FillValue
               iono_cor_gim_01_ku_Flag=1;
            else
               iono_cor_gim_01_ku_Flag=0;
            end            
            
            if mod_dry_tropo_cor_meas_altitude_01(i)==mod_dry_tropo_cor_meas_altitude_01_FillValue
               mod_dry_tropo_cor_meas_altitude_01_Flag=1;
            else
               mod_dry_tropo_cor_meas_altitude_01_Flag=0;
            end
            
            if mod_wet_tropo_cor_meas_altitude_01(i)==mod_wet_tropo_cor_meas_altitude_01_FillValue
               mod_wet_tropo_cor_meas_altitude_01_Flag=1;
            else
               mod_wet_tropo_cor_meas_altitude_01_Flag=0;
            end   
% 
%             if mod_dry_tropo_cor_zero_altitude_01(i)==mod_dry_tropo_cor_zero_altitude_01_FillValue
%                mod_dry_tropo_cor_zero_altitude_01_Flag=1;
%             else
%                mod_dry_tropo_cor_zero_altitude_01_Flag=0;
%             end
%             
%             if mod_wet_tropo_cor_zero_altitude_01(i)==mod_wet_tropo_cor_zero_altitude_01_FillValue
%                mod_wet_tropo_cor_zero_altitude_01_Flag=1;
%             else
%                mod_wet_tropo_cor_zero_altitude_01_Flag=0;
%             end 
            
            
                            
            correction=pole_tide_01(i)+solid_earth_tide_01(i)+iono_cor_gim_01_ku(i)+mod_dry_tropo_cor_meas_altitude_01(i)+mod_wet_tropo_cor_meas_altitude_01(i);            
% correction=pole_tide_01(i)+solid_earth_tide_01(i)+iono_cor_gim_01_ku(i)+mod_dry_tropo_cor_zero_altitude_01(i)+mod_wet_tropo_cor_zero_altitude_01(i);
            Flags=pole_tide_01_Flag+solid_earth_tide_01_Flag+iono_cor_gim_01_ku_Flag+mod_dry_tropo_cor_meas_altitude_01_Flag+mod_wet_tropo_cor_meas_altitude_01_Flag;    
% Flags=pole_tide_01_Flag+solid_earth_tide_01_Flag+iono_cor_gim_01_ku_Flag+mod_dry_tropo_cor_zero_altitude_01_Flag+mod_wet_tropo_cor_zero_altitude_01_Flag;    

            hgt_comp(cycno, orbit_num, output_file_name,lat_boundary,i,time_intv,'ocog',mjd_20_ku,time_20_ku,lon_20_ku,lat_20_ku,alt_20_ku,range_ocog_20_ku,sig0_ocog_20_ku,alt_20_ku_FillValue,range_ocog_20_ku_FillValue,sig0_ocog_20_ku_FillValue,correction,Flags);
            
        end
        
    end
    
close(bar);
msgbox('Extraction Completed!','Status');
	
end



