function variable_extract(ncid,variable_needed)

   eval(['global ',variable_needed]);
   eval(['global ',variable_needed,'_FillValue']);
        
   eval([variable_needed,'=netcdf.getVar(ncid,netcdf.inqVarID(ncid,''',variable_needed,'''));'])   
   eval([variable_needed,'=double(',variable_needed,');']);
   
   try
      scale_factor=netcdf.getAtt(ncid,netcdf.inqVarID(ncid,variable_needed),'scale_factor');
   catch
      scale_factor=1;    
   end
   try
      add_offset=netcdf.getAtt(ncid,netcdf.inqVarID(ncid,variable_needed),'add_offset');
   catch
      add_offset=0;    
   end
   
   eval([variable_needed,'=',variable_needed,'.*scale_factor+add_offset;']);     
   
   try
      FillValue=netcdf.getAtt(ncid,netcdf.inqVarID(ncid,variable_needed),'_FillValue');
      eval([variable_needed,'_FillValue=double(FillValue)*scale_factor+add_offset;']);
   catch
      display(['No FillValue in ',variable_needed]); 
      eval(['clear ',variable_needed,'_FillValue']);      
   end  
   
end