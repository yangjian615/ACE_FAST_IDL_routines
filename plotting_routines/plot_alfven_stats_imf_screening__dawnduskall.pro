;2016/01/01 This is a wrapper so that we don't have to do the gobbledigook below every time we want to see 'sup with these plots
;;mod history
;;;;;;;
;;TO DO
;;
;;
PRO PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL,maximus, $
                                    CLOCKSTR=clockStr, $
                                    RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                    ANGLELIM1=angleLim1, $
                                    ANGLELIM2=angleLim2, $
                                    ORBRANGE=orbRange, $
                                    ALTITUDERANGE=altitudeRange, $
                                    CHARERANGE=charERange, $
                                    POYNTRANGE=poyntRange, $
                                    NUMORBLIM=numOrbLim, $
                                    MINMLT=minMLT,MAXMLT=maxMLT, $
                                    BINMLT=binMLT, $
                                    SHIFTMLT=shiftMLT, $
                                    MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                    DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                    MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                    HWMAUROVAL=HwMAurOval, $
                                    HWMKPIND=HwMKpInd, $
                                    MIN_NEVENTS=min_nEvents, $
                                    MASKMIN=maskMin, $
                                    BYMIN=byMin, $
                                    BZMIN=bzMin, $
                                    BYMAX=byMax, $
                                    BZMAX=bzMax, $
                                    DO_ABS_BYMIN=abs_byMin, $
                                    DO_ABS_BYMAX=abs_byMax, $
                                    DO_ABS_BZMIN=abs_bzMin, $
                                    DO_ABS_BZMAX=abs_bzMax, $
                                    SATELLITE=satellite, $
                                    OMNI_COORDS=omni_Coords, $
                                    HEMI=hemi, $
                                    BOTH_HEMIS=both_hemis, $
                                    NORTH=north, $
                                    SOUTH=south, $
                                    DELAY=delay, $
                                    STABLEIMF=stableIMF, $
                                    SMOOTHWINDOW=smoothWindow, $
                                    INCLUDENOCONSECDATA=includeNoConsecData, $
                                    NONSTORM=nonStorm, $
                                    RECOVERYPHASE=recoveryPhase, $
                                    MAINPHASE=mainPhase, $
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
                                    CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                    NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                    CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                                    NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
                                    ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                    ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                    NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                    DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                    NEVENTPERMINPLOT=nEventPerMinPlot, NEVENTPERMINRANGE=nEventPerMinRange, LOGNEVENTPERMIN=logNEventPerMin, $
                                    PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                    PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence, $
                                    MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                    ALL_LOGPLOTS=all_logPlots, $
                                    SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                    DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, $
                                    DO_CHASTDB=do_chastDB, $
                                    DO_DESPUNDB=do_despunDB, $
                                    NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                    WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                    SAVERAW=saveRaw, RAWDIR=rawDir, $
                                    JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                    PLOTDIR=plotDir, $
                                    PLOTPREFIX=plotPrefix, $
                                    PLOTSUFFIX=plotSuffix, $
                                    MEDHISTOUTDATA=medHistOutData, $
                                    MEDHISTOUTTXT=medHistOutTxt, $
                                    OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                    DEL_PS=del_PS, $
                                    COMBINE_PLOTS=combine_plots, $
                                    N_TO_COMBINE=n_to_combine, $
                                    COMBINED_TO_BUFFER=combined_to_buffer, $
                                    SAVE_COMBINED_WINDOW=save_combined_window, $
                                    SAVE_COMBINED_NAME=save_combined_name, $
                                    NO_COLORBAR=no_colorbar, $
                                    CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                    CB_FORCE_OOBLOW=cb_force_oobLow, $
                                    FANCY_PLOTNAMES=fancy_plotNames, $
                                    _EXTRA = e, $
                                    PRINT_DATA_AVAILABILITY=print_data_availability, $
                                    VERBOSE=verbose, $
                                    LUN=lun


  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY

  IF KEYWORD_SET(combine_plots) THEN BEGIN
     outTempFiles = !NULL
     no_colorbar  = [1,0,1]
  ENDIF ELSE BEGIN
     no_colorbar  = [0,0,0]
  ENDELSE

  ;; suff            = STRING(FORMAT='("--Dstcutoff_",I0)',dstCutoff)
  ;; clockStrings    = [""+suff,"mainphase"+suff,"recoveryphase"+suff]
  ;; niceStrings     = ["Non-storm","Main phase","Recovery phase"]
  clockStrings       = ['dawnward','all_IMF','duskward']

  FOR i=0,2 DO BEGIN

     PLOT_ALFVEN_STATS_IMF_SCREENING,maximus, $
                                     CLOCKSTR=clockStrings[i], ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, $
                                     CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                     NUMORBLIM=numOrbLim, $
                                     MINMLT=minMLT,MAXMLT=maxMLT, $
                                     BINMLT=binMLT, $
                                     SHIFTMLT=shiftMLT, $
                                     MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                     DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                     MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                     BOTH_HEMIS=both_hemis, $
                                     NORTH=north, $
                                     SOUTH=south, $
                                     HEMI=hemi, $
                                     HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                     MIN_NEVENTS=min_nEvents, $
                                     MASKMIN=maskMin, $
                                     BYMIN=byMin, $
                                     BZMIN=bzMin, $
                                     BYMAX=byMax, $
                                     BZMAX=bzMax, $
                                     DO_ABS_BYMIN=abs_byMin, $
                                     DO_ABS_BYMAX=abs_byMax, $
                                     DO_ABS_BZMIN=abs_bzMin, $
                                     DO_ABS_BZMAX=abs_bzMax, $
                                     DELAY=delay, $
                                     STABLEIMF=stableIMF, $
                                     SMOOTHWINDOW=smoothWindow, $
                                     INCLUDENOCONSECDATA=includeNoConsecData, $
                                     NONSTORM=nonStorm, $
                                     RECOVERYPHASE=recoveryPhase, $
                                     MAINPHASE=mainPhase, $
                                     NPLOTS=nPlots, $
                                     EPLOTS=ePlots, $
                                     EPLOTRANGE=ePlotRange, $                                       
                                     EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                                     ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                     ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
                                     LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                                     NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                     PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                     NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                     IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                     NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                     CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                     NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                     CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                                     NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
                                     ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                     ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                     NEVENTPERORBPLOT=nEventPerOrbPlot, $
                                     LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                     DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                     NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                                     PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                     PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence, $
                                     MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                     ALL_LOGPLOTS=all_logPlots, $
                                     SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                                     WHOLECAP=wholeCap, $
                                     DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, $
                                     DO_CHASTDB=do_chastDB, $
                                     DO_DESPUNDB=do_despunDB, $
                                     NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                     WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                     SAVERAW=saveRaw, RAWDIR=rawDir, $
                                     JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                     PLOTDIR=plotDir, $
                                     PLOTPREFIX=plotPrefix, $
                                     PLOTSUFFIX=plotSuffix, $
                                     MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                                     OUT_TEMPFILE=out_tempFile, $
                                     NO_COLORBAR=no_colorbar[i], $
                                     CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                     CB_FORCE_OOBLOW=cb_force_oobLow, $
                                     FANCY_PLOTNAMES=fancy_plotNames, $
                                     _EXTRA = e  
     
     IF KEYWORD_SET(combine_plots) THEN outTempFiles = [outTempFiles,out_tempFile]
              
  ENDFOR

  IF KEYWORD_SET(combine_plots) THEN BEGIN

     COMBINE_ALFVEN_STATS_PLOTS,niceStrings, $
                                N_TO_COMBINE=n_to_combine, $
                                TEMPFILES=outTempFiles, $
                                OUT_IMGS_ARR=out_imgs_arr, $
                                OUT_TITLEOBJS_ARR=out_titleObjs_arr, $
                                COMBINED_TO_BUFFER=combined_to_buffer, $
                                SAVE_COMBINED_WINDOW=save_combined_window, $
                                SAVE_COMBINED_NAME=save_combined_name, $
                                PLOTSUFFIX=plotSuffix, $
                                PLOTDIR=plotDir, $
                                /DELETE_PLOTS_WHEN_FINISHED
     
  ENDIF

END