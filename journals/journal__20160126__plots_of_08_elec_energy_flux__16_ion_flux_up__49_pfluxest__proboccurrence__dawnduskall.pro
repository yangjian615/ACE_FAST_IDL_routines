;2016/01/26 Crikey, we knew something had to be wrong. Now we're ready to write the other paper!
; There was a serious issue of my own making with the OMNI DB. Check out this journal for more info:
; ACE_FAST/journals/../SW_IMF_data_parsing_routines/check_space_between_omnidata_20150221.pro
PRO JOURNAL__20160126__PLOTS_OF_08_ELEC_ENERGY_FLUX__16_ION_FLUX_UP__49_PFLUXEST__PROBOCCURRENCE__DAWNDUSKALL

  nonstorm                       = 0

  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 54
  ;; ;; nEventsPlotRange               = [5e1,5e3]        ; North   ;for chare 3-400eV
  ;; nEventsPlotRange               = [5e1,5e3]        ; North   ;for chare 3-400eV

  hemi                           = 'SOUTH'
  maxILAT                        = -54
  nEventsPlotRange               = [1e1,1e3]   ; South

  byMin                          = 5
  do_abs_bymin                   = 1
  ;; bzMax                          = 1
  ;; smoothWindow                   = 5
  ;; delay                          = 720

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;NEVENTS

   ;;10-EFLUX_LOSSCONE_INTEG
   ;; eNumFlPlotType                 = 'eflux_Losscone_Integ'
   ;; ;; eNumFlRange                    = [10^(0.5),10^(5.5)]
   ;; eNumFlRange                    = [2e1,2e3]
   ;; logENumFlPlot                  = 1

  ;;18-INTEG_UPWARD_ION_FLUX
  ;; iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(7.5),10^(11.5)]
  ;; logIFPlot                      = 1
  
  ;;08--ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [2e-1,2e1]
  logEFPlot                      = 1

  ;;16--ION_FLUX_UP
  iFluxPlotType                  = 'Max_Up'
  iPlotRange                     = [10^(7.0),10^(9.0)]
  logIFPlot                      = 1
  
  ;;49--pFluxEst
  pPlotRange                     = [1e-1,1e1]
  logPFPlot                      = 1

  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [3e-3,3e-1]

  binMLT                         = 1.0
  shiftMLT                       = 0.5

  do_despun                      = 1

  PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL, $
                                  NONSTORM=nonstorm, $
                                  CHARERANGE=charERange, $
                                  PLOTSUFFIX=plotSuff, $
                                  HEMI=hemi, $
                                  BINMLT=binMLT, $
                                  SHIFTMLT=shiftMLT, $
                                  MINILAT=minILAT, $
                                  MAXILAT=maxILAT, $
                                  /MIDNIGHT, $
                                  DELAY=delay, $
                                  DO_DESPUNDB=do_despun, $
                                  BYMIN=byMin, $
                                  DO_ABS_BYMIN=do_abs_bymin, $
                                  BZMAX=bzMax, $
                                  SMOOTHWINDOW=smoothWindow, $
                                  ;; /MEDIANPLOT, $
                                  /LOGAVGPLOT, $
                                  /NPLOTS, $
                                  ;; /ENUMFLPLOTS, $
                                  /EPLOTS, $
                                  /IONPLOTS, $
                                  /PPLOTS, $
                                  /LOGNEVENTSPLOT, $
                                  LOGIFPLOT=logIFPlot, $
                                  LOGPFPLOT=logPFPlot, $
                                  LOGENUMFLPLOT=logENumFlPlot, $
                                  LOGEFPLOT=logEFPlot, $
                                  NEVENTSPLOTRANGE=nEventsPlotRange, $
                                  EPLOTRANGE=ePlotRange, $
                                  ENUMFLPLOTRANGE=eNumFlRange, $
                                  IPLOTRANGE=iPlotRange, $
                                  PPLOTRANGE=pPlotRange, $
                                  ENUMFLPLOTTYPE=eNumFlPlotType, $
                                  IFLUXPLOTTYPE=iFluxPlotType, $
                                  /CB_FORCE_OOBHIGH, $
                                  /CB_FORCE_OOBLOW, $
                                  /COMBINE_PLOTS, $
                                  /SAVE_COMBINED_WINDOW, $
                                  /COMBINED_TO_BUFFER

  ;;prob occurrence last because it takes so long
  PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL, $
                                  NONSTORM=nonstorm, $
                                  CHARERANGE=charERange, $
                                  PLOTSUFFIX=plotSuff, $
                                  HEMI=hemi, $
                                  BINMLT=binMLT, $
                                  SHIFTMLT=shiftMLT, $
                                  MINILAT=minILAT, $
                                  MAXILAT=maxILAT, $
                                  /MIDNIGHT, $
                                  DELAY=delay, $
                                  DO_DESPUNDB=do_despun, $
                                  BYMIN=byMin, $
                                  DO_ABS_BYMIN=do_abs_bymin, $
                                  BZMAX=bzMax, $
                                  SMOOTHWINDOW=smoothWindow, $
                                  /LOGAVGPLOT, $
                                  /PROBOCCURRENCEPLOT, $
                                  /LOGPROBOCCURRENCE, $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  /CB_FORCE_OOBHIGH, $
                                  /CB_FORCE_OOBLOW, $
                                  /COMBINE_PLOTS, $
                                  /SAVE_COMBINED_WINDOW, $
                                  /COMBINED_TO_BUFFER



END