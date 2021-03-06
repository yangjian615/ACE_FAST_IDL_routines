;
PRO JOURNAL__20161121__ZHANG_2014__BZ_SOUTH_RELATIONSHIP__LOOSER_CURRENT_RESTRICTION

  COMPILE_OPT IDL2

  ;; nonstorm                       = 1
  ;; DSTcutoff                      = -25
  ;; smooth_dst                     = 1

  ;; plotPref                       = 'Dstcut_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL) + '--'
  ;; IF KEYWORD_SET(smooth_dst) THEN BEGIN
  ;;    plotPref += 'smDst--'
  ;; ENDIF

  do_timeAvg_fluxQuantities      = 1
  logAvgPlot                     = 0
  divide_by_width_x              = 1

  show_integrals                 = 1

  EA_binning                     = 0
  use_AACGM                      = 1

  minMC                          = 1
  maxNegMC                       = -1

  ;;DB stuff
  do_despun                      = 0

  autoscale_fluxPlots            = 0
  
  ;;bonus
  print_avg_imf_components       = 0
  calc_KL_sw_coupling_func       = 1

  ;;grossrate stuff
  do_grossRate_fluxQuantities    = 0
  grossRate_info_file_pref       = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
                                   '--bzSouth--alfIMFpaper--'
  make_integral_txtFile          = 0
  make_integral_savFile          = 1
  integralSavFilePref            = 'integrals--bzSouth_paper--'
  print_master_OMNI_file         = 1
  make_OMNI_stats_savFile        = 1
  OMNI_statsSavFilePref          = 'bzSouthIntegs--AlfIMF--'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plot

  pPlots                         = 1

  ;; logPfPlot                   = 1
  ;; PPlotRange                  = [1e-1,1e1]
  logPfPlot                      = 1
  PPlotRange                     = [1e-3,1e0]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds  = 1
  reset_OMNI_inds  = 1

  ;; altRange      = [[340,4180]]
  altitudeRange    = [[1000,4180]]

  orbRange         = [1000,10800]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  ;; start_bz      = 10
  ;; stepWidth     = 2.5
  ;; nSteps        = 8
  ;; stepDelta     = 2.5
  start_bz         = 10
  stepWidth        = 2.5
  nSteps           = 8
  stepDelta        = 2.5

  bzMaxArr         = (-1)*INDGEN(nSteps)*stepDelta+start_bz
  bzMinArr         = (-1)*(INDGEN(nSteps)*stepDelta+stepWidth)+start_bz

  ;; bzMaxArr         = [20,12,8,6,4,2,0 ,-2,-4,-6, -8,-12]
  ;; bzMinArr         = [12, 8,6,4,2,0,-2,-4,-6,-8,-12,-20]

  ;; bzMaxArr         = [40,10  ,7.5,5,3,1,0 ,-1,-3,-5  , -7.5,-10]
  ;; bzMinArr         = [10, 7.5,5  ,3,1,0,-1,-3,-5,-7.5,-10  ,-40]

  ;; bzMaxArr         = [40,9,6,4,2, 0,-2,-4,-6, -9]
  ;; bzMinArr         = [ 9,6,4,2,0,-2,-4,-6,-9,-40]

  bzMaxArr         = [40,8,5  ,2.5,   0,-2.5,-5, -8]
  bzMinArr         = [ 8,5,2.5,  0,-2.5,-5  ,-8,-40]

  clockStrings     = 'all_Bz'

  smoothWindow     = 11

  angleLim1        = 67.5
  angleLim2        = 112.5  

  ;;Delay stuff
  nDelays          = 1
  delayDeltaSec    = 1800
  delayArr         = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 60
  ;; maxILAT                        = 90
  ;; maskMin                        = 10
  ;; tHist_mask_bins_below_thresh   = 5
  ;; maskMin                        = 5
  

  hemi                           = 'SOUTH'
  minILAT                        = -90
  maxILAT                        = -60
  ;; maskMin                        =  10.0

  tHist_mask_bins_below_thresh   =  2.0

  ;; binILAT                     = 2.0
  binILAT                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.0

  ;; minMLT                      = 6
  ;; maxMLT                      = 18

  ;;Bonus

  IF N_ELEMENTS(minMLT) EQ 0 THEN minMLT = 0
  IF N_ELEMENTS(maxMLT) EQ 0 THEN maxMLT = 24

  FOR i=0,N_ELEMENTS(bzMinArr)-1 DO BEGIN
     IMFStr                      = clockStrings
     IMFTitle                    = ''
     bzMin                       = bzMinArr[i]
     bzMax                       = bzMaxArr[i]

     ;; IF bzMin EQ ((-1.)*start_Bz) THEN bzMin = -2.*start_Bz
     ;; IF bzMax EQ (      start_Bz) THEN bzMax =  2.*start_Bz

     altStr                      = STRING(FORMAT='(I0,"-",I0,"_km--orbits_",I0,"-",I0)', $
                                          altitudeRange[0], $
                                          altitudeRange[1], $
                                          orbRange[0], $
                                          orbRange[1])

     plotPrefix                  = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

     IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
        IMFStr += '--bzMax_' + STRCOMPRESS(bzMax,/REMOVE_ALL)
        IMFTitle += ' B!Dt!N Max: ' + STRCOMPRESS(bzMax,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
        IMFStr += '--bzMin_' + STRCOMPRESS(bzMin,/REMOVE_ALL)
        IMFTitle += ' B!Dt!N Min: ' + STRCOMPRESS(bzMin,/REMOVE_ALL) + 'nT'
     ENDIF

     grossRate_info_file            = STRING(FORMAT='(A0,A0,I0,"-",I0,"_MLT.txt")', $
                                             grossRate_info_file_pref, $
                                             IMFStr, $
                                             minMLT, $
                                             maxMLT)

     suffix_plotDir                 = '/' + IMFStr
     ;; suffix_txtDir                  = '/' + IMFStr

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        CLOCKSTR=clockStrings, $
        MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        DELAY=delayArr, $
        ;; /MULTIPLE_DELAYS, $
        RESOLUTION_DELAY=delayDeltaSec, $
        BINOFFSET_DELAY=binOffset_delay, $
        NUMORBLIM=numOrbLim, $
        MINMLT=minMLT, $
        MAXMLT=maxMLT, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        EQUAL_AREA_BINNING=EA_binning, $
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        ANGLELIM1=angleLim1, $
        ANGLELIM2=angleLim2, $
        BYMIN=byMin, $
        BYMAX=byMax, $
        BZMIN=bzMin, $
        BZMAX=bzMax, $
        BTMIN=btMin, $
        BTMAX=btMax, $
        BXMIN=bxMin, $
        BXMAX=bxMax, $
        DO_ABS_BYMIN=abs_byMin, $
        DO_ABS_BYMAX=abs_byMax, $
        DO_ABS_BZMIN=abs_bzMin, $
        DO_ABS_BZMAX=abs_bzMax, $
        DO_ABS_BTMIN=abs_btMin, $
        DO_ABS_BTMAX=abs_btMax, $
        DO_ABS_BXMIN=abs_bxMin, $
        DO_ABS_BXMAX=abs_bxMax, $
        ;; RUN_AROUND_THE_RING_OF_CLOCK_ANGLES=run_the_clockAngle_ring, $
        RESET_OMNI_INDS=reset_omni_inds, $
        SATELLITE=satellite, $
        OMNI_COORDS=omni_Coords, $
        PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
        PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
        PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
        SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
        MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
        OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
        CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
        HEMI=hemi, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        ;; /DO_NOT_CONSIDER_IMF, $
        NONSTORM=nonStorm, $
        RECOVERYPHASE=recoveryPhase, $
        MAINPHASE=mainPhase, $
        DSTCUTOFF=dstCutoff, $
        NPLOTS=nPlots, $
        EPLOTS=ePlots, $
        EPLOTRANGE=ePlotRange, $                                       
        EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
        ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
        ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
        NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
        IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
        OXYPLOTS=oxyPlots, $
        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
        LOGOXYFPLOT=logOxyfPlot, $
        ABSOXYFLUX=absOxyFlux, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        OXYPLOTRANGE=oxyPlotRange, $
        CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        ORBCONTRIBPLOT=orbContribPlot, $
        LOGORBCONTRIBPLOT=logOrbContribPlot, $
        ORBCONTRIBRANGE=orbContribRange, $
        ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
        ORBCONTRIB_NOMASK=orbContrib_noMask, $
        ORBTOTPLOT=orbTotPlot, $
        ORBFREQPLOT=orbFreqPlot, $
        ORBTOTRANGE=orbTotRange, $
        ORBFREQRANGE=orbFreqRange, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        LOGNEVENTPERORB=logNEventPerOrb, $
        NEVENTPERORBRANGE=nEventPerOrbRange, $
        NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
        DIVNEVBYTOTAL=divNEvByTotal, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        NEVENTPERMINRANGE=nEventPerMinRange, $
        LOGNEVENTPERMIN=logNEventPerMin, $
        NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
        NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
        NOWEPCO_RANGE=nowepco_range, $
        NOWEPCO_AUTOSCALE=nowepco_autoscale, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        THISTDENOMINATORPLOT=tHistDenominatorPlot, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
        THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
        THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
        WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
        WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
        SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
        MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots, $
        SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
        DBFILE=dbfile, $
        NO_BURSTDATA=no_burstData, $
        RESET_GOOD_INDS=reset_good_inds, $
        DATADIR=dataDir, $
        CHASTDB=chastDB, $
        DESPUNDB=despun, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_MAG_COORDS=use_MAG, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, SAVEDIR=saveDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIX=plotSuff, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        SUFFIX_PLOTDIR=suffix_plotDir, $
        SUFFIX_TXTDIR=suffix_txtDir, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        EPS_OUTPUT=eps_output, $
        SUPPRESS_THICKGRID=suppress_thickGrid, $
        SUPPRESS_GRIDLABELS=suppress_gridLabels, $
        SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
        SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
        SUPPRESS_MLT_NAME=suppress_MLT_name, $
        SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
        SUPPRESS_TITLES=suppress_titles, $
        OUT_TEMPFILE_LIST=out_tempFile_list, $
        OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
        OUT_PLOT_I_LIST=out_plot_i_list, $
        OUT_PARAMSTRING_LIST=out_paramString_list, $
        GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        ;; TILEPLOTSUFFS=tilePlotSuffs, $
        TILING_ORDER=tiling_order, $
        TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
        TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
        TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        TILEPLOTTITLE=tilePlotTitle, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        
        FANCY_PLOTNAMES=fancy_plotNames, $
        SHOW_INTEGRALS=show_integrals, $
        MAKE_INTEGRAL_TXTFILE=make_integral_txtFile, $
        MAKE_INTEGRAL_SAVFILE=make_integral_savFile, $
        INTEGRALSAVFILEPREF=integralSavFilePref, $
        _EXTRA=e
     ;; /GET_PLOT_I_LIST_LIST, $
     ;; /GET_PARAMSTR_LIST_LIST, $
     ;; PLOT_I_LIST_LIST=plot_i_list_list, $
     ;; PARAMSTR_LIST_LIST=paramStr_list_list
     
  ENDFOR

END



