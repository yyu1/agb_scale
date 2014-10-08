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
			hv_thresh = 0.03
			index = where(in_hv ge hv_thresh, count)
			if (count gt 0) then begin
				hv_mean = mean(in_hv)
				out_array[index] = in_val * in_hv[index] / hv_mean
			endif
		End  ; End of method 1

		2: Begin
			hv_thresh = 0.03
			index = where(in_hv ge hv_thresh, count)
			if (count gt 0) then begin
				hv_ln = alog10(in_hv * 100) ; since values are between 0 and 1, make them positive
				hv_mean = mean(hv_ln)
				out_array[index] = in_val * hv_ln[index]/hv_mean
			endif
		End ; End of method 2
				
		3: Begin
			hv_thresh = 0.03
			index = where(in_hv ge hv_thresh, count)
			if (count gt 0) then begin
				hv_ln = alog10(in_hv * 1000) ; since values are between 0 and 1, make them positive
				hv_mean = mean(hv_ln)
				out_array[index] = in_val * hv_ln[index]/hv_mean
			endif
		End ; End of method 3

		4: Begin
			hv_thresh = 0.03
			index = where(in_hv ge hv_thresh, count)
			if (count gt 0) then begin
				coef_hv = in_hv/mean(in_hv)
				coef_rfdi = 1.3 * in_rfdi/mean(in_rfdi)
				select = abs(coef_hv - 1) lt abs(coef_rfdi - 1)
				index = where((~select) or (in_hv gt hv_thresh)) ; only apply threshold if hv variance is relatively small compared to rfdi so we don't blank out shadow areas of topography
				out_array[index] = in_val * (coef_hv[index] * select[index] + coef_rfdi[index] * (~select[index]))
			endif
		End ; End of method 4

		5: Begin
			hv_thresh = 0.03
			index = where(in_hv ge hv_thresh, count)
			if (count gt 0) then begin
				coef_hv = in_hv/mean(in_hv)
				coef_rfdi = 1.3 * in_rfdi/mean(in_rfdi)
				select = abs(coef_hv - 1) lt abs(coef_rfdi - 1)
				index = where((~select) or (in_hv gt hv_thresh)) ; only apply threshold if hv variance is relatively small compared to rfdi so we don't blank out shadow areas of topography
				out_array[index] = in_val * (((coef_hv[index] * select[index] + coef_rfdi[index] * (~select[index]))-1)*0.5+1)
			endif

			abs_thresh = 0.003
			index = where(in_hv lt abs_thresh, count)
			if (count gt 0) then out_array[index] = 0
		End ; End of method 5


	ENDCASE

	return, out_array
End
