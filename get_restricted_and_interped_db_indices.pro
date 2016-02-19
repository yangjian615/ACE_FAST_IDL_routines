;2015/12/31 Added RESTRICT_WITH_THESE_I keyword so that I can do non-storm 
;2016/01/07 Added DO_DESPUNDB keyword
;2016/02/10 Added DO_NOT_CONSIDER_IMF keyword
FUNCTION GET_RESTRICTED_AND_INTERPED_DB_INDICES,dbStruct,satellite,delay,LUN=lun, $
   DBTIMES=dbTimes,dbfile=dbfile, $
   DO_CHASTDB=do_chastdb, $
   DO_DESPUNDB=do_despunDB, $
   HEMI=hemi, $
   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange,POYNTRANGE=poyntRange, $
   MINMLT=minM,MAXMLT=maxM, $
   BINM=binM, $
   SHIFTM=shiftM, $
   MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   SMOOTHWINDOW=smoothWindow, $
   BYMIN=byMin, $
   BZMIN=bzMin, $
   BYMAX=byMax, $
   BZMAX=bzMax, $
   DO_ABS_BYMIN=abs_byMin, $
   DO_ABS_BYMAX=abs_byMax, $
   DO_ABS_BZMIN=abs_bzMin, $
   DO_ABS_BZMAX=abs_bzMax, $
   CLOCKSTR=clockStr, $
   DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
   BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
   STABLEIMF=stableIMF, $
   OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
   HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData, $
   GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
   RESTRICT_WITH_THESE_I=restrict_with_these_i
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout


     final_i = get_chaston_ind(dbStruct,satellite,lun, $
                               DBTIMES=dbTimes,dbfile=dbfile, $
                               CHASTDB=do_chastdb, HEMI=hemi, $
                               DESPUNDB=do_despunDB, $
                               ORBRANGE=orbRange, $
                               ALTITUDERANGE=altitudeRange, $
                               CHARERANGE=charERange, $
                               POYNTRANGE=poyntRange, $
                               MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                               MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                               DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                               HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,$
                               NO_BURSTDATA=no_burstData, $
                               GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i)

  IF KEYWORD_SET(restrict_with_these_I) THEN BEGIN
     PRINTF,lun,'GET_RESTRICTED_AND_INTERPED_DB_INDICES: Restricting with user-provided inds instead of those generated by get_chaston_ind ...'
     n_final = N_ELEMENTS(final_i)
     final_i = CGSETINTERSECTION(restrict_with_these_i,final_i)
     n_after = N_ELEMENTS(final_i)
     PRINTF,lun,'Lost ' + STRCOMPRESS(n_final-n_after,/REMOVE_ALL) + ' events due to use-provided, restricted indices'
  ENDIF

  ;;Now handle the rest
  IF KEYWORD_SET(do_not_consider_IMF) THEN BEGIN
     PRINTF,lun,"Not considering IMF anything!"
     restricted_and_interped_i              = final_i
  ENDIF ELSE BEGIN
     ;; phiChast = interp_mag_data(final_i,satellite,delay,lun, $
     ;;                            DBTIMES=dbTimes, $
     ;;                            FASTDBINTERP_I=FASTDBInterp_i, $
     ;;                            FASTDBSATPROPPEDINTERPED_I=cdbSatProppedInterped_i, $
     ;;                            MAG_UTC=mag_utc,PHICLOCK=phiClock, $
     ;;                            DATADIR=dataDir, $
     ;;                            SMOOTHWINDOW=smoothWindow, $
     ;;                            BYMIN=byMin, $
     ;;                            BZMIN=bzMin, $
     ;;                            BYMAX=byMax, $
     ;;                            BZMAX=bzMax, $
     ;;                            DO_ABS_BYMIN=abs_byMin, $
     ;;                            DO_ABS_BYMAX=abs_byMax, $
     ;;                            DO_ABS_BZMIN=abs_bzMin, $
     ;;                            DO_ABS_BZMAX=abs_bzMax, $
     ;;                         OMNI_COORDS=omni_Coords)
     
     ;; phiImf_ii = check_imf_stability(clockStr,angleLim1,angleLim2, $
     ;;                                 phiChast,cdbSatProppedInterped_i,stableIMF, $
     ;;                                 mag_utc,phiClock,$
     ;;                                 LUN=lun, $
     ;;                                 BX_OVER_BYBZ=Bx_over_ByBz_Lim)
     
     ;; restricted_and_interped_i=FASTDBInterp_i[phiImf_ii]

     restricted_AND_interped_i = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS(dbTimes,final_i,delay, $
                                                                                      CLOCKSTR=clockStr, $
                                                                                      ANGLELIM1=angleLim1, $
                                                                                      ANGLELIM2=angleLim2, $
                                                                                      STABLEIMF=stableIMF, $
                                                                                      /RESTRICT_TO_ALFVENDB_TIMES, $
                                                                                      BYMIN=byMin, $
                                                                                      BZMIN=bzMin, $
                                                                                      BYMAX=byMax, $
                                                                                      BZMAX=bzMax, $
                                                                                      DO_ABS_BYMIN=abs_byMin, $
                                                                                      DO_ABS_BYMAX=abs_byMax, $
                                                                                      DO_ABS_BZMIN=abs_bzMin, $
                                                                                      DO_ABS_BZMAX=abs_bzMax, $
                                                                                      OMNI_COORDS=OMNI_coords, $
                                                                                      LUN=lun)     
     
  ENDELSE

  RETURN,restricted_and_interped_i
     
END