in_h_file = '/Volumes/Global_250m/output/biomass/test_3.2sec/sam_test_amazon_small_hlorey_latlon_9.6sec.flt'
in_hh_file = '/Volumes/Global_250m/output/biomass/test_3.2sec/sam_3.2sec_HH_small_piece.flt'
in_hv_file = '/Volumes/Global_250m/output/biomass/test_3.2sec/sam_3.2sec_HV_sqr_small_piece.flt'
in_rfdi_file = '/Volumes/Global_250m/output/biomass/test_3.2sec/sam_3.2sec_RFDI_small_piece.flt'

out_file = '/Volumes/Global_250m/output/biomass/test_3.2sec/sam_test_amazon_hlorey_3.2sec_method2.flt'

openr, 1, in_h_file
openr, 2, in_hh_file
openr, 3, in_hv_file
openr, 4, in_rfdi_file

openw, 10, out_file

in_h_line = fltarr(300)
in_hh_line = fltarr(900,3)
in_hv_line = fltarr(900,3)
in_rfdi_line = fltarr(900,3)

out_line = fltarr(900,3)

hh_window = fltarr(3,3)
hv_window = fltarr(3,3)
rfdi_window = fltarr(3,3)

for j=0ULL, 299ULL do begin
	out_line[*] = 0
	
	readu, 1, in_h_line
	readu, 2, in_hh_line
	readu, 3, in_hv_line
	readu, 4, in_rfdi_line

	for i=0ULL, 299ULL do begin
			hh_window = in_hh_line[i*3:i*3+2,*]
			hv_window = in_hv_line[i*3:i*3+2,*]
			rfdi_window = in_rfdi_line[i*3:i*3+2,*]
			out_line[i*3:i*3+2,*] = scale_h_pixel(in_h_line[i], hv_window, rfdi_window ,2)
	endfor

	writeu, 10, out_line

endfor

close, /all

end
