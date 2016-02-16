;2016/02/15 
PRO JOURNAL__20160215__DATA_FOR_PROBOCCURRENCE__DAWNDUSKALL__LOOP_OVER_DELAYS__FASTLOC_INTERVALS4

  justData                       = 1
  nonstorm                       = 1

  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 67
  ;; maxILAT                        = 75
  ;; binILAT                        = 4

  hemi                           = 'SOUTH'
  minILAT                        = -75
  maxILAT                        = -67
  binILAT                        = 4

  nEventsPlotRange               = [4e1,4e3]        ; North   ;for chare 4-300eV
  nEventsPlotRange               = [1e1,1e3]        ; North   ;for chare 300-4000eV

  ;; hemi                           = 'SOUTH'
  ;; maxILAT                        = -55
  ;; minILAT                        = -85
  ;; binILAT                        = 2.5
  ;; nEventsPlotRange               = [2e1,2e3]   ; South

  minMLT                         = 8.5
  maxMLT                         = 15.5
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  byMin                          = 3
  do_abs_bymin                   = 1
  bzMax                          = 0
  ;; smoothWindow                   = 5
  ;; delayArr                       = [-300,  -240,  -180,  -120,  -60, $
  ;;                                      0,    60,   120,   180,   240, $
  ;;                                    300,   360,   420,   480,   540, $
  ;;                                    600,   660,   720,   780,   840, $
  ;;                                    900,   960,  1020,  1080,  1140, $
  ;;                                   1200,  1260,  1320,  1380,  1440, $
  ;;                                   1500]
  
  delayArr                         = [ -300, -270,  -240,  -210,  -180,  -120, $
                                       -90,   -60,   -30,     0,    30,    60, $
                                       90, $
                                       120,   150,   180,   210,   240,   270, $  
                                       300,   330,   360,   390,   420,   450, $  
                                       480,   510,   540,   570,   600,   630, $  
                                       660,   690,   720,   750,   780,   810, $  
                                       840,   870,   900,   930,   960,  1020, $
                                       1050,  1080, $
                                       1110,  1140,  1170,  1200]
  
  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]


  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [2e-3,2e-1]

  do_despun                      = 1

  FOR i = 0, N_ELEMENTS(delayArr)-1 DO BEGIN
     PRINT,'*******************************************'
     PRINT,FORMAT='("*************DELAY=",I04,"s*******************")',delayArr[i]
     PRINT,'*******************************************'
     PRINT,''
     PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL, $
        NONSTORM=nonstorm, $
        JUSTDATA=justData, $
        CHARERANGE=charERange, $
        PLOTSUFFIX=plotSuff, $
        HEMI=hemi, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINMLT=minMLT, $
        MAXMLT=maxMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        /MIDNIGHT, $
        DELAY=delayArr[i], $
        DO_DESPUNDB=do_despun, $
        BYMIN=byMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        BZMAX=bzMax, $
        SMOOTHWINDOW=smoothWindow, $
        ;; /MEDIANPLOT, $
        /LOGAVGPLOT, $
        /NPLOTS, $
        ;; /ENUMFLPLOTS, $
        ;; /EPLOTS, $
        ;; /IONPLOTS, $
        ;; /PPLOTS, $
        /PROBOCCURRENCEPLOT, $
        /LOGNEVENTSPLOT, $
        ;; LOGIFPLOT=logIFPlot, $
        ;; LOGPFPLOT=logPFPlot, $
        ;; LOGENUMFLPLOT=logENumFlPlot, $
        ;; LOGEFPLOT=logEFPlot, $
        /LOGPROBOCCURRENCE, $
        ;; NEVENTSPLOTRANGE=nEventsPlotRange, $
        ;; EPLOTRANGE=ePlotRange, $
        ;; ENUMFLPLOTRANGE=eNumFlRange, $
        ;; IPLOTRANGE=iPlotRange, $
        ;; PPLOTRANGE=pPlotRange, $
        ;; PROBOCCURRENCERANGE=probOccurrenceRange, $
        PROBOCCURRENCERANGE=probOccurrenceRange
        ;; ENUMFLPLOTTYPE=eNumFlPlotType, $
        ;; IFLUXPLOTTYPE=iFluxPlotType, $
        ;; /CB_FORCE_OOBHIGH, $
        ;; /CB_FORCE_OOBLOW, $
        ;; /COMBINE_PLOTS, $
        ;; /SAVE_COMBINED_WINDOW, $
        ;; /COMBINED_TO_BUFFER

  ENDFOR     
END