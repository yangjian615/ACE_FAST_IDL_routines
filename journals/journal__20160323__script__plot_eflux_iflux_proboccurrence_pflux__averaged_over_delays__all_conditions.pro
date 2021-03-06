PRO JOURNAL__20160323__SCRIPT__PLOT_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__AVERAGED_OVER_DELAYS__ALL_CONDITIONS

  nDelArr        = [31,61]
  hemiArr        = ['NORTH','SOUTH']
  clockStrArr    = ['dawnward','duskward']
  
  fileDir        = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/processed/'
  fileList       = LIST()

  combine_plots        = 1
  save_combined_window = 1
  combined_to_buffer   = 1

  FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
     FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN

        fileArr = !NULL
        FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN

           ;;First make the plots
           JOURNAL__20160323__PLOT_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__AVERAGED_OVER_DELAYS, $
              HEMI=hemiArr[iHemi], $
              CLOCKSTR=clockStrArr[iClock], $
              NDELAYS=nDelArr[iDel], $
              OUT_PLOTNAMEPREF=out_plotNamePref, $
              OUT_PLOTDIR=plotDir
           
           IF KEYWORD_SET(combine_plots) THEN fileArr = [fileArr,out_plotNamePref+'.dat']
        ENDFOR
        fileList.add,fileArr
     ENDFOR
  ENDFOR

  IF KEYWORD_SET(combine_plots) THEN BEGIN
     
     titles             = ['Dawnward','Duskward']
     FOR iDawnDuskSet=0,N_ELEMENTS(fileList)-1 DO BEGIN
        plotNamePrefArr           = [STRMID(fileList[iDawnDuskSet,0],0,STRLEN(fileList[iDawnDuskSet,0])-4), $
                                     STRMID(fileList[iDawnDuskSet,1],0,STRLEN(fileList[iDawnDuskSet,1])-4)]
        outTempFiles              = fileDir+[fileList[iDawnDuskSet,0],fileList[iDawnDuskSet,1]]
        COMBINE_ALFVEN_STATS_PLOTS,titles, $
                                   N_TO_COMBINE=n_to_combine, $
                                   TEMPFILES=outTempFiles, $
                                   ;; OUT_IMGS_ARR=out_imgs_arr, $
                                   ;; OUT_TITLEOBJS_ARR=out_titleObjs_arr, $
                                   COMBINED_TO_BUFFER=combined_to_buffer, $
                                   SAVE_COMBINED_WINDOW=save_combined_window, $
                                   SAVE_COMBINED_NAME=save_combined_name, $
                                   PLOTSUFFIX=plotSuffix, $
                                   PLOTDIR=plotDir, $
                                   PLOTNAMEPREFARR=plotNamePrefArr, $
                                   /DELETE_PLOTS_WHEN_FINISHED
     ENDFOR
  ENDIF

END
