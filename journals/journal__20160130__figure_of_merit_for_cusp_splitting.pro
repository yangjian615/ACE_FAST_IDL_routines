;2016/01/30
;Let's take a look at this figure of merit stuff. I've got all the data, anyway.

;Each file contains the following data products:
;; 0 *Max L.C. e!U-!N Flux (mW/m!U2!N), at ionos.
;; 1 *Integ. L.C. e!U-!N Flux (mW/m), at ionos.
;; 2 *Max Poynting Flux (mW/m!U2!N), at ionos.
;; 3 *Log Max Upward Ion Flux (#/cm!U2!N-s), at ionos.
;; 4 *Log Probability of occurrence
;; 5 *Log Number of events
;; 6 *Histogram mask
PRO JOURNAL__20160130__FIGURE_OF_MERIT_FOR_CUSP_SPLITTING

  IF N_ELEMENTS(lun) EQ 0 THEN lun         = -1 ;stdout

  printemall                               = 0

  h2dFileDir                               = '/SPENCEdata/Research/Cusp/ACE_FAST/20160130--Alfven_cusp_figure_of_merit/data/'

  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  outFile                                  = h2dFileDir+'processed/'+hoyDia+'--Cusp_splitting--NORTH_figures_of_merit--delays_0-30min.sav'
  fileDay                                  = ['Jan_28_16']

  minI                                     = 55.0000
  maxI                                     = 85.0000
  binI                                     = 2.5

  minM                                     = 0.00000
  maxM                                     = 24.0000
  binM                                     = 1.0
  shiftM                                   = 0.5

  h2d_i                                    = 4            ; The one for probability of occurrence
  n_maxima                                 = 3            ; How many maxima are we getting?
  threshold_max                            = ALOG10(1.1)  ; Value shouldn't be more than 10% above 100% occurrence
  nFOM_to_print                            = 25

  ;;Boundaries for figure of merit
  dusk_minM                                = 12.5
  dusk_maxM                                = 15.5
  dusk_minI                                = 60
  dusk_maxI                                = 75

  dawn_minM                                = 8.5
  dawn_maxM                                = 11.5
  dawn_minI                                = 60
  dawn_maxI                                = 75

  ;;Get the ILAT and MLT bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               CENTERS1=centersMLT,CENTERS2=centersILAT, $
                               BINSIZE1=binM, BINSIZE2=binI, $
                               MAX1=maxM, MAX2=maxI, $
                               MIN1=minM, MIN2=minI, $
                               SHIFT1=shiftM, SHIFT2=shiftI

  ;;Determine where to get the figure of merit stuff
  dawn_MLT_i                               = WHERE(centersMLT GE dawn_minM AND centersMLT LE dawn_maxM)
  dawn_ILAT_i                              = WHERE(centersILAT GE dawn_minI AND centersILAT LE dawn_maxI)
  dawn_i                                   = cgsetintersection(dawn_MLT_i,dawn_ILAT_i)

  dusk_MLT_i                               = WHERE(centersMLT GE dusk_minM AND centersMLT LE dusk_maxM)
  dusk_ILAT_i                              = WHERE(centersILAT GE dusk_minI AND centersILAT LE dusk_maxI)
  dusk_i                                   = cgsetintersection(dusk_MLT_i,dusk_ILAT_i)

  ;;parameters for files to be looped over
  hemi                                     = 'NORTH'
  clockStrArr                              = ['dawnward','all_IMF','duskward']
  byMin                                    = 3.0

  delayArr                                 = [0,60,120,180,240, $
                                              300,360,420,480,540, $
                                              600,660,720,780,840, $
                                              900,960,1020,1080,1140, $
                                              1200,1260,1320,1380,1440, $
                                              1500,1560,1620,1680,1740, $
                                              1800]/60

  ;;Now, let's get a specified number of maxima: loop through files, let us know if any don't exist

  h2dFNameFmt                              = '("raw/polarplots_"' + $
     ',A0,"--"' + $
     ',A0,"--logAvg--"' + $
     ',A0,"--0stable--OMNI_GSM_"' + $
     ',I0,"mindelay_byMin_",F3.1,".dat")'
  h2dFile                                  = STRING(FORMAT=h2dFNameFmt, $
                                                    fileDay,hemi,clockStrArr[0],delayArr[0],byMin)

  RESTORE,h2dFileDir+h2dFile
  PRINT,"Starting the action for a dawn/dusk figure of merit for: " + h2dStrArr[h2d_i].title
  PRINT,''
  IF KEYWORD_SET(printemall) THEN BEGIN
     PRINT,FORMAT='("Delay (m)",T20,"IMF",T30,"Comb. FOM",T45,"Dawn FOM",T60,"Dusk FOM")' ;header
     fmtString                             = '(I-4,T20,A9,T30,F0.2,T45,F0.2,T60,F0.2)'
  ENDIF
  bogusFmt                                 = '(I0,T10,F0.3,T25,F0.3,T40,F0.3)' ;for bogus vals

  IMFPredomList                            = LIST(!NULL)
  combFOMList                              = LIST(!NULL)
  dawnFOMList                              = LIST(!NULL)
  duskFOMList                              = LIST(!NULL)
  delayList                                = LIST(!NULL)
  nDelay                                   = N_ELEMENTS(delayArr)
  nClock                                   = N_ELEMENTS(clockStrArr)
  FOR k=0,nClock-1 DO BEGIN
     h2dFileArr                            = !NULL
     combfomArr                            = !NULL
     dawnfomArr                            = !NULL
     duskfomArr                            = !NULL

     PRINT,'****'+STRUPCASE(clockStrArr[k])+'****'
     FOR i=0,nDelay-1 DO BEGIN
        dawnExceed_ii                         = !NULL
        duskExceed_ii                         = !NULL
        dawnExceedVals                        = !NULL
        duskExceedVals                        = !NULL
        dawnExceedN                           = !NULL
        duskExceedN                           = !NULL

        h2dFile                            = STRING(FORMAT=h2dFNameFmt, $
                                                    fileDay,hemi,clockStrArr[k],delayArr[i],byMin)
        
        IF FILE_TEST(h2dFileDir+h2dFile) THEN BEGIN    ;Got 'im!

           restore,h2dFileDir+h2dFile
           
           ;handle the masked cells
           masked_i                        = WHERE(h2dStrArr[-1].data GT 250)
           h2dStrArr[h2d_i].data[masked_i] = -10

           dawn_data                       = h2dStrArr[h2d_i].data[dawn_i]
           dawn_maxima                     = 10.0^(GET_N_MAXIMA_IN_ARRAY(dawn_data,N=n_maxima,OUT_I=dawnMaxima_ii, $
                                                                         THRESHOLD=threshold_max, $
                                                                         OUT_EXCEEDED_THRESHOLD_VALS=dawnExceedVals, $
                                                                         OUT_EXCEEDED_THRESHOLD_I=dawnExceed_ii, $
                                                                         OUT_EXCEEDED_THRESHOLD_N=dawnExceedN))
           dawn_max_ilats                  = centersILAT[dawn_i[dawnMaxima_ii]]
           dawn_max_mlts                   = centersMLT[dawn_i[dawnMaxima_ii]]

           dusk_data                       = h2dStrArr[h2d_i].data[dusk_i]
           dusk_maxima                     = 10.0^(GET_N_MAXIMA_IN_ARRAY(dusk_data,N=n_maxima,OUT_I=duskMaxima_ii, $
                                                                         THRESHOLD=threshold_max, $
                                                                         OUT_EXCEEDED_THRESHOLD_VALS=duskExceedVals, $
                                                                         OUT_EXCEEDED_THRESHOLD_I=duskExceed_ii, $
                                                                         OUT_EXCEEDED_THRESHOLD_N=duskExceedN))
           dusk_max_ilats                  = centersILAT[dusk_i[duskMaxima_ii]]
           dusk_max_mlts                   = centersMLT[dusk_i[duskMaxima_ii]]
           
           ;;Show any bogus vals
           dawn_bogus_ilats                = centersILAT[dawn_i[dawnExceed_ii]]
           dawn_bogus_mlts                 = centersMLT[dawn_i[dawnExceed_ii]]

           dusk_bogus_ilats                = centersILAT[dusk_i[duskExceed_ii]]
           dusk_bogus_mlts                 = centersMLT[dusk_i[duskExceed_ii]]

           IF dawnExceedN GT 0 OR duskExceedN GT 0 THEN BEGIN
              PRINTF,lun,FORMAT='("Delay",T10,"Bogus val",T25,"Bogus ILAT",T40,"Bogus MLT")'

           IF dawnExceedN GT 0 THEN BEGIN
              PRINTF,lun,"Bogus dawnward vals"
              FOR l=0,dawnExceedN-1 DO BEGIN
                 PRINTF,lun,FORMAT=bogusFmt,delayArr[i],10.0^dawnExceedVals[l],dawn_bogus_ilats[l],dawn_bogus_mlts[l]
              ENDFOR
           END
           
           IF duskExceedN GT 0 THEN BEGIN
              PRINTF,lun,"Bogus duskward vals"
              FOR l=0,duskExceedN-1 DO BEGIN
                 PRINTF,lun,FORMAT=bogusFmt,delayArr[i],10.0^duskExceedVals[l],dusk_bogus_ilats[l],dusk_bogus_mlts[l]
              ENDFOR
           END

        ENDIF           

           ;;calculate figures of merit
           dawn_fom                        = MEAN(dawn_maxima)
           dusk_fom                        = MEAN(dusk_maxima)
           comb_fom                        = dawn_fom+dusk_fom

           ;;want to see?
           IF KEYWORD_SET(printemall) THEN BEGIN
              PRINT,FORMAT=fmtString,delayArr[i],clockStrArr[k],comb_fom,dawn_fom,dusk_fom
           ENDIF
           
           combfomArr                      = [combfomArr,comb_fom]
           dawnfomArr                      = [dawnfomArr,dawn_fom]
           duskfomArr                      = [duskfomArr,dusk_fom]
           h2dFileArr                      = [h2dFileArr,h2dFile]

        ENDIF ELSE BEGIN
           PRINT,""
           PRINT,"File doesn't exist: " + h2dFile
           PRINT,""
        ENDELSE

     ENDFOR

     ;;Now lets see which figures of merit are most awesome
     combFOM_awesome                       = GET_N_MAXIMA_IN_ARRAY(combfomArr,N=nFOM_to_print,OUT_I=combFOM_i)
     dawnFOM_awesome                       = dawnfomArr[combFOM_i]
     duskFOM_awesome                       = duskfomArr[combFOM_i]
     delay_awesome                         = delayArr[combFOM_i]

     PRINT,"************THE RESULTS************"
     PRINT,""
     PRINT,FORMAT='("Rank",T10,"Delay (m)",T20,"Comb. FOM",T35,"Dawn FOM",T50,"Dusk FOM")' ;header
     fomFmtString                          = '(I-2,T10,I-4,T20,F0.3,T35,F0.3,T50,F0.3)'
     
     PRINT,'******'+STRUPCASE(clockStrArr[k])+'******'
     FOR i                                 =0,nFOM_to_print-1 DO BEGIN
        PRINT,FORMAT=fomFmtString,i+1,delay_awesome[i],combFOM_awesome[i],dawnFOM_awesome[i],duskFOM_awesome[i]
     ENDFOR
     PRINT,''
     PRINT,''
     
     IMFPredomList.add,clockStrArr[k]
     ;; combFOMList.add,combFOM_awesome
     ;; dawnFOMList.add,dawnFOM_awesome
     ;; duskFOMList.add,duskFOM_awesome
     ;; delayList.add,delay_awesome

     combFOMList.add,combfomArr
     dawnFOMList.add,dawnfomArr
     duskFOMList.add,duskfomArr
     ;; delayList.add,delay_awesome

  ENDFOR
  nFiles                                   = N_ELEMENTS(h2dFileArr)

  IMFPredomList.remove,0
  combFOMList.remove,0
  dawnFOMList.remove,0
  duskFOMList.remove,0
  delayList.remove,0

  ;;Now combine stuff from each IMF predominance
  ;; FOR i=0,nDelay-1 DO BEGIN
  combDawnDusk                          = combFOMList[0]+combFOMList[2]
  ;; ENDFOR
  
  combDawnDusk_awesome                  = GET_N_MAXIMA_IN_ARRAY(combDawnDusk,N=nFOM_to_print,OUT_I=combDawnDusk_i)
  delayDawnDusk_awesome                 = delayArr[combDawnDusk_i]
  PRINT,"************RESULTS FROM COMBINATION OF DAWNWARD AND DUSKWARD IMF STUFF************"
  PRINT,""
  PRINT,FORMAT='(T47,"DAWNWARD IMF",T77,"DUSKWARD IMF")'
  PRINT,FORMAT='("Rank",T10,"Delay (m)",T20,"Combined FOM |",T40,"Dawn cell",T55,"Dusk cell  |",T70,"Dawn cell",T85,"Dusk cell")' ;header
  fomUltimateFmtString                  = '(I-2,T10,I-4,T20,F0.3,"        |",T40,F0.3,T55,F0.3,"      |",T70,F0.3,T85,F0.3)'
  
  FOR i=0,nFOM_to_print-1 DO BEGIN
     PRINT,FORMAT=fomUltimateFmtString,i+1,delayDawnDusk_awesome[i],combDawnDusk_awesome[i],dawnFOMList[0,i],duskFOMList[0,i],dawnFOMList[2,i],duskFOMList[2,i]
  ENDFOR

  PRINTF,lun,'Saving lists to ' + outFile
  save,IMFPredomList,combFOMList,dawnFOMList,duskFOMList,delayList,FILENAME=outFile

END