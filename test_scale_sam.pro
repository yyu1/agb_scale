xdim = 13000ULL
ydim = 4000ULL

in_h_file = '/Volumes/Global_250m/output/sam/v3/maxent_sam_hlorey_using_newprior_9.6sec_slice_fuzzy.flt'
in_hh_file = '/Volumes/Global_250m/alos/3.2sec/sam/sam_3.2sec_HV_slice.flt'
in_hv_file = '/Volumes/Global_250m/alos/3.2sec/sam/sam_3.2sec_HV_slice.flt'
in_rfdi_file = '/Volumes/Global_250m/alos/3.2sec/sam/sam_3.2sec_RFDI_slice.flt'

out_file = '/Volumes/Global_250m/output/sam/v3/3.2sec/maxent_sam_hlorey_3.2sec_method5_fuzzy.flt'

openr, 1, in_h_file
;openr, 2, in_hh_file
openr, 3, in_hv_file
openr, 4, in_rfdi_file

openw, 10, out_file

in_h_line = fltarr(xdim)
in_hh_line = fltarr(xdim*3,3)
in_hv_line = fltarr(xdim*3,3)
in_rfdi_line = fltarr(xdim*3,3)

out_line = fltarr(xdim*3,3)

hh_window = fltarr(3,3)
hv_window = fltarr(3,3)
rfdi_window = fltarr(3,3)

for j=0ULL, ydim-1 do begin
	out_line[*] = 0
	
	readu, 1, in_h_line
	;readu, 2, in_hh_line
	readu, 3, in_hv_line
	readu, 4, in_rfdi_line

	for i=0ULL, xdim-1 do begin
			;hh_window = in_hh_line[i*3:i*3+2,*]
			hv_window = in_hv_line[i*3:i*3+2,*]
			rfdi_window = in_rfdi_line[i*3:i*3+2,*]
			out_line[i*3:i*3+2,*] = scale_h_pixel(in_h_line[i], hv_window, rfdi_window ,5)
	endfor

	writeu, 10, out_line

endfor

close, /all

end
