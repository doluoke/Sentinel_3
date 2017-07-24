function hgt_comp(cycno, orbit_num, output_file_name, lat_boundary, i, time_intv, retracker, mjd, time, lon, lat, alt, range, sig0, alt_FillValue, range_FillValue, sig0_FillValue, correction, Flags)    
    
    dim_20hz=size(time);         
    
    fout=fopen(['extract\s3_NTC_o',num2str(orbit_num,'%.3i'),'_',output_file_name,'_',num2str(lat_boundary(1),'%.6f'),'_',num2str(lat_boundary(2),'%.6f'),'_',retracker,'_info.txt'],'a');
    
    for j=1:dim_20hz(1)
        if lat(j)>=lat_boundary(1) && lat(j)<=lat_boundary(2)
           Flags1=Flags;
           
           if alt(j)==alt_FillValue
              alt_Flag=1;
           else
              alt_Flag=0;
           end
            
           if range(j)==range_FillValue
              range_Flag=1;
           else
              range_Flag=0;
           end
            
           if sig0(j)==sig0_FillValue
              sig0_Flag=1;
           else
              sig0_Flag=0;
           end                                  
           
           Flags1=Flags1+alt_Flag+range_Flag+sig0_Flag;
        
           if Flags1==0
              if time(j)>=time_intv(i,1) && time(j)<=time_intv(i,2)
              
                 hgt_20hz=alt(j)-(correction+range(j));
                            
                 mjd_20hz=mjd(j);
                 lon_20hz=lon(j);
                 lat_20hz=lat(j);
                 sig0_20hz=sig0(j);
              
                 fprintf(fout, '%4d %4d %4d %4d', 0, 0, 0, 0);
                 fprintf(fout, '%4d %4d %4d %4d %4d', 0, 0, 0, 0, 0);
                 fprintf(fout, '%4d %20.6f %20.6f %20.6f', cycno, mjd_20hz, lon_20hz, lat_20hz);
                 fprintf(fout, '%20.6f %10.3f\n',hgt_20hz,sig0_20hz);
              
              end           
           end
        end        
    end
    
    fclose(fout);
    
end