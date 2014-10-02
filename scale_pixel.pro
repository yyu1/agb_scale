;Takes as input the AGB value (scalar for one pixel) of the coarse resolution pixel
;Also takes as input auxillary imagery of higher resolution.
;Vector size of auxillary imageries must be the same and in order.

;Can select different interpolation methods

;Currently designed to work with integer AGB values (takes in the 10x Int AGB value)

Function scale_pixel, in_val, in_aux, method

	if n_elements(in_val) ne 1 then begin
		print, 'ERROR: in_val for scale_pixel must be scalar'
		exit
	endif

	;Size of output array
	n_out = n_elements(in_aux)

	;out_array = intarr(n_out)
	out_array = intarr(n_out)

	if in_val le 0 then return, out_array


	;Do interpolation
	CASE method OF
		1: Begin
			threshold = 0.17
			index = where(in_aux gt threshold, count)
			if(count gt 0) then begin
				out_array[index] = fix(float(in_val) * float(n_out) / float(count))
			endif
		End  ; End of method 1

		2: Begin
			;Linear weight
			out_array[*] = fix(float(in_val) * (in_aux/mean(in_aux)))

		End  ; End of method 2

	ENDCASE

	return, out_array

End
