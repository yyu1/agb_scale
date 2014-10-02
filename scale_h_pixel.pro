;Similar to scale pixel, but this one uses more auxilary information
;and is designed for use with lorey's height in floating point data



Function scale_h_pixel, in_val, in_hv, in_rfdi, method

	if n_elements(in_val) ne 1 then begin
    print, 'ERROR: in_val for scale_pixel must be scalar'
    exit
  endif

  ;Size of output array
  n_out = n_elements(in_hv)

  ;out_array = intarr(n_out)
  out_array = fltarr(n_out)

  if in_val le 0 then return, out_array

	;Do interpolation

	CASE method OF
		1: Begin
			hv_thresh = 0.051
			index = where(in_hv ge hv_thresh, count)
			if (count gt 0) then begin
				hv_mean = mean(in_hv)
				out_array[index] = in_val * in_hv / hv_mean
			endif
		End  ; End of method 1


	ENDCASE

	return, out_array
End
