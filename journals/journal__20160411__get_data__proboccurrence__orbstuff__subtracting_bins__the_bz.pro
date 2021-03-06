;2016/04/04 How about intensities?
PRO JOURNAL__20160411__GET_DATA__PROBOCCURRENCE__ORBSTUFF__SUBTRACTING_BINS__THE_BZ

  nonstorm                       = 0
  justData                       = 1

  ;; altitudeRange                  = [50,4175]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  eNumFlPlots               = 1
  pPlots                    = 1
  ionPlots                  = 1
  nEventPerOrbPlot          = 0
  probOccurrencePlot        = 1
  nPlots                    = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Bonus
  do_timeAvg_fluxQuantities      = 1
  logAvgs                        = 0
  maskMin                        = 10
  divide_by_width_x              = 1


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 64
  maxILAT                        = 88

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -88
  ;; maxILAT                        = -63

  ;; binILAT                        = 4.0        ;2016/03/{23,31}
  ;; binILAT                        = 2.0        ;2016/03/24
  ;; binILAT                        = 2.5        ;2016/03/30
  ;; binILAT                        = 3.0        ;2016/03/31
  ;; binILAT                        = 5.0        ;2016/03/29
  binILAT                        = 8.0        ;2016/04/03
  ;; binILAT                        = 7.0        ;2016/04/03

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; binMLT                         = 0.75        ;2016/03/2{3,9}
  ;; shiftMLT                       = 0.375       ;2016/03/2{3,9}

  binMLT                         = 1.0       ;2016/03/24
  shiftMLT                       = 0.50       ;2016/03/24

  ;; binMLT                         = 1.5       ;2016/03/31
  ;; shiftMLT                       = 0.75      ;2016/03/31

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff

  ;; stableIMF                      = 20

  ;;2016/04/11 For Bz south plots (the ones we subtract By dawn/dusk plots from)
  dont_consider_clockAngles      = 1
  ;; byMin                          = 5
  ;; do_abs_bymin                   = 1
  bzMax                          = -3

  ;; byMax                          = 5
  ;; do_abs_bymax                   = 1
  ;; do_clock_angles                = 0
  ;; bzMin                          = -5
  ;; DO_abs_bzMin                   = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DB stuff
  do_despun                      = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;delay stuff
  totMinToDisplay                = 120
  delayDeltaSec                  = 1800
  delay_res                      = 1800

  ;; delayDeltaSec                  = 900
  ;; delay_res                      = 900
  ;; binOffset_delay                = 0

  ;; delayDeltaSec                  = 600
  ;; delay_res                      = 600

  ;; totMinToDisplay                = 180
  ;; delayDeltaSec                  = 3600
  ;; delay_res                      = 3600

  binOffset_delay                = 0

  ;; delayDeltaSec                  = 1200
  ;; delay_res                      = 1200
  ;; binOffset_delay                = 600

  ;; delayDeltaSec                  = 1800
  ;; delay_res                      = 1800
  ;; binOffset_delay                = 900

  ;; nDelays                        = 401
  nDelays                        = FIX(FLOAT(totMinToDisplay)/delayDeltaSec*60)
  IF (nDelays MOD 2) EQ 0 THEN nDelays++

  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;BONUS
  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  probOccurrenceRange            = [0,1e-1]
  logProbOccurrence              = 1

  ;; Events per orb
  nEventPerOrbRange              = [0,100]
  logNEventPerOrb                = 1

  ;;nEvents
  nEventsPlotRange               = [0,500]
  logNEventsPlot                 = 0

  ;;49--pFluxEst
  pPlotRange                     = [0,1] ;for time-averaged
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  eNumFlRange                   = [0,1]
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)]
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [0,1e8] ;for time-averaged plot
  logIFPlot                      = 1
  noNegIFlux                     = 1  

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        JUSTDATA=justData, $
        NONSTORM=nonstorm, $
        CHARERANGE=charERange, $
        ALTITUDERANGE=altitudeRange, $
        MASKMIN=maskMin, $
        HEMI=hemi, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        
        DELAY=delayArr, $
        /MULTIPLE_DELAYS, $
        RESOLUTION_DELAY=delay_res, $
        BINOFFSET_DELAY=binOffset_delay, $
        DESPUNDB=despun, $
        STABLEIMF=stableIMF, $
        DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
        BYMIN=byMin, $
        BYMAX=byMax, $
        BZMAX=bzMax, $
        BZMIN=bzMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        DO_ABS_BYMAX=do_abs_byMax, $
        DO_ABS_BZMIN=do_abs_bzmin, $
        DO_ABS_BZMAX=do_abs_bzMax, $
        ANGLELIM1=angleLim1, $
        ANGLELIM2=angleLim2, $
        SMOOTHWINDOW=smoothWindow, $
        LOGAVGPLOT=logAvgs, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        NPLOTS=nPlots, $
        NEVENTPERORBRANGE=nEventPerOrbRange, $
        LOGNEVENTPERORB=logNEventPerOrb, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        LOGNEVENTSPLOT=logNEventsPlot, $
        PPLOTS=pPlots, $
        LOGPFPLOT=logPFPlot, $
        PPLOTRANGE=pPlotRange, $
        ENUMFLPLOTS=eNumFlPlots, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        ENUMFLPLOTRANGE=eNumFlRange, $
        LOGENUMFLPLOT=logENumFlPlot, $
        NONEGENUMFL=noNegENumFl, $
        IONPLOTS=ionPlots, $
        IFLUXPLOTTYPE=iFluxPlotType, $
        IPLOTRANGE=iPlotRange, $
        LOGIFPLOT=logIFPlot, $
        NONEGIFLUX=noNegIFlux, $
        /CB_FORCE_OOBHIGH, $
        /CB_FORCE_OOBLOW, $
        COMBINE_PLOTS=~KEYWORD_SET(justData), $
        /SAVE_COMBINED_WINDOW, $
        /COMBINED_TO_BUFFER

END

