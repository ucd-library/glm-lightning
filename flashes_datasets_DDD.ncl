;----------------------------------------------------------------------
; flashes_DDD.ncl


begin
;---NetCDF file to read in.
  filename = "GLM.nc"
  fin      = addfile(filename,"r")

;-- Add to the dataset table

product_time=fin->product_time
product_time_bounds=fin->product_time_bounds

;print(product_time_bounds)

write_table("csv/YYYY/DDD/datasets.csv","a",\
[/fin@id,fin@platform_ID,fin@dataset_name,fin@date_created,\
  fin@time_coverage_start,fin@time_coverage_end\
;  product_time,product_time_bounds(0),product_time_bounds(1) \
  /],\
  "%s,%s,%s,%s,%s,%s")


 flash_id=fin->flash_id
 time_offset_of_first_event=fin->flash_time_offset_of_first_event
 time_offset_of_last_event=fin->flash_time_offset_of_last_event
; frame_time_offset_of_first_event=fin->flash_frame_time_offset_of_first_event
; frame_time_offset_of_last_event=fin->flash_frame_time_offset_of_last_event
 lat=fin->flash_lat
 lon=fin->flash_lon
 area=fin->flash_area
 energy=fin->flash_energy
 quality_flag=fin->flash_quality_flag

dataset_id=conform(flash_id,fin@id,0)

flash_filename = "csv/YYYY/DDD/flashes.csv"

;---Write data to file
  alist  = [/ flash_id \
  ,dataset_id \
  ,time_offset_of_first_event \
  ,time_offset_of_last_event \
  ,lat \
  ,lon \
  ,area \
  ,energy \
  ,quality_flag \
/]
  format = "%hu,%s,%hu,%hu,%g,%g,%hu,%hu,%hhu"
  write_table(flash_filename, "a", alist, format)
end
