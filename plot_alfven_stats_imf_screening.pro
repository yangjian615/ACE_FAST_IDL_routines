;+
; NAME: PLOT_ALFVEN_STATS_IMF_SCREENING
;
; PURPOSE: Plot FAST data processed by Chris Chaston's ALFVEN_STATS_5 procedure (with mods).
;          All data are binned by MLT and ILAT (bin sizes can be set manually).
;
; CALLING SEQUENCE: PLOT_ALFVEN_STATS_IMF_SCREENING
;
; INPUTS:
;
; OPTIONAL INPUTS:   
;                *DATABASE PARAMETERS
;                    CLOCKSTR          :  Interplanetary magnetic field clock angle.
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', 'all_IMF',
;                                            'dawn-north', 'dawn-south', 'dusk-north', or 'dusk-south'.
;		     ANGLELIM1         :     
;		     ANGLELIM2         :     
;		     ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
;                    NUMORBLIM         :  Minimum number of orbits passing through a given bin in order for the bin to be 
;                                            included and not masked in the plot.
; 		     MINMLT            :  MLT min  (Default: 9)
; 		     MAXMLT            :  MLT max  (Default: 15)
; 		     BINMLT            :  MLT binsize  (Default: 0.5)
;		     MINILAT           :  ILAT min (Default: 64)
;		     MAXILAT           :  ILAT max (Default: 80)
;		     BINILAT           :  ILAT binsize (Default: 2.0)
;		     MIN_NEVENTS       :  Minimum number of events an orbit must contain to qualify as a "participating orbit"
;                    MASKMIN           :  Minimum number of events a given MLT/ILAT bin must contain to show up on the plot.
;                                            Otherwise it gets shown as "no data". (Default: 1)
;                    BYMIN             :  Minimum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMIN             :  Minimum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;                    BYMAX             :  Maximum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMAX             :  Maximum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;		     NPLOTS            :  Plot number of orbits.   
;                    HEMI              :  Hemisphere for which to show statistics. Can be "North", "South", or "Both".
;
;                *IMF SATELLITE PARAMETERS
;                    SATELLITE         :  Satellite to use for checking FAST data against IMF.
;                                           Can be any of "ACE", "wind", "wind_ACE", or "OMNI" (default).
;                    OMNI_COORDS       :  If using "OMNI" as the satellite, choose between GSE or GSM coordinates for the database.
;                    DELAY             :  Time (in seconds) to lag IMF behind FAST observations. 
;                                         Binzheng Zhang has found that current IMF conditions at ACE or WIND usually rear   
;                                            their heads in the ionosphere about 11 minutes after they are observed.
;                    STABLEIMF         :  Time (in minutes) over which stability of IMF is required to include data.
;                                            NOTE! Cannot be less than 1 minute.
;                    SMOOTHWINDOW      :  Smooth IMF data over a given window (default: none)
;
;                *HOLZWORTH/MENG STATISTICAL AURORAL OVAL PARAMETERS 
;                    HWMAUROVAL        :  Only include those data that are above the statistical auroral oval.
;                    HWMKPIND          :  Kp Index to use for determining the statistical auroral oval (def: 7)
;
;                *ELECTRON FLUX PLOT OPTIONS
;		     EPLOTS            :     
;                    EFLUXPLOTTYPE     :  Options are 'Integ' for integrated or 'Max' for max data point.
;                    LOGEFPLOT         :  Do log plots of electron energy flux.
;                    ABS_EFLUX         :  Use absolute value of electron energy flux (required for log plots).
;                    NONEG_EFLUX       :  Do not use negative e fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOS_EFLUX       :  Do not use positive e fluxes in any of the plots
;                    EPLOTRANGE        :  Range of allowable values for e- flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *ELECTRON NUMBER FLUX PLOT OPTIONS
;		     ENUMFLPLOTS       :  Do plots of max electron number flux
;                    ENUMFLPLOTTYPE    :  Options are 'Total_Eflux_Integ', 'Eflux_Losscone_Integ', 'ESA_Number_flux'.
;                    LOGENUMFLPLOT     :  Do log plots of electron number flux.
;                    ABSENUMFL         :  Use absolute value of electron number flux (required for log plots).
;                    NONEGENUMFL       :  Do not use negative e num fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOSENUMFL       :  Do not use positive e num fluxes in any of the plots
;                    ENUMFLPLOTRANGE   :  Range of allowable values for e- num flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;                    
;                *POYNTING FLUX PLOT OPTIONS
;		     PPLOTS            :  Do Poynting flux plots.
;                    LOGPFPLOT         :  Do log plots of Poynting flux.
;                    ABSPFLUX          :  Use absolute value of Poynting flux (required for log plots).
;                    NONEGPFLUX        :  Do not use negative Poynting fluxes in any of the plots
;                    NOPOSPFLUX        :  Do not use positive Poynting fluxes in any of the plots
;                    PPLOTRANGE        :  Range of allowable values for e- flux plots. 
;                                         (Default: [0,3]; [-1,0.5] for log plots)
;
;                *ION FLUX PLOT OPTIONS
;		     IONPLOTS          :  Do ion plots (using ESA data).
;                    IFLUXPLOTTYPE     :  Options are 'Integ', 'Max', 'Integ_Up', 'Max_Up', or 'Energy'.
;                    LOGIFPLOT         :  Do log plots of ion flux.
;                    ABSIFLUX          :  Use absolute value of ion flux (required for log plots).
;                    NONEGIFLUX        :  Do not use negative ion fluxes in any of the plots (positive is earthward for ion flux)
;                    NOPOSIFLUX        :  Do not use positive ion fluxes in any of the plots
;                    IPLOTRANGE        :  Range of allowable values for ion flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *CHAR E PLOTS
;                    CHAREPLOTS        :  Do characteristic electron energy plots
;                    CHARETYPE         :  Options are 'lossCone' for electrons in loss cone or 'Total' for all electrons.
;                    LOGCHAREPLOT      :  Do log plots of characteristic electron energy.
;                    ABSCHARE          :  Use absolute value of characteristic electron (required for log plots).
;                    NONEGCHARE        :  Do not use negative char e in any of the plots (positive MIGHT be earthward...)
;                    NOPOSCHARE        :  Do not use positive char e in any of the plots
;                    CHAREPLOTRANGE    :  Range of allowable values for characteristic electron energy plots. 
;                                         (Default: [-500000,500000]; [0,3.6] for log plots)
;
;                *ORBIT PLOT OPTIONS
;		     ORBCONTRIBPLOT    :  Contributing orbit plots
;		     ORBCONTRIBRANGE   :  Range for contributing orbit plot
;		     ORBTOTPLOT        :  Plot of total number of orbits for each bin, 
;                                            given user-specified restrictions on the database.
;		     ORBTOTRANGE       :  Range for Orbtotplot 
;		     ORBFREQPLOT       :  Plot of orbits contributing to a given bin, 
;		     ORBFREQRANGE      :  Range for Orbfreqplot.
;                                            divided by total orbits passing through the bin.
;                    NEVENTSPLOTRANGE  :  Range for nEvents plot.
;                    LOGNEVENTSPLOT    :  Do log plot for n events
;
;                    NEVENTPERORBPLOT  :  Plot of number of events per orbit.
;                    NEVENTPERORBRANGE :  Range for Neventperorbplot.
;                    LOGNEVENTPERORB   :  Log of Neventperorbplot (for comparison with Chaston et al. [2003])
;                    DIVNEVBYAPPLICABLE:  Divide number of events in given bin by the number of orbits occurring 
;                                            during specified IMF conditions. (Default is to divide by total number of orbits 
;                                            pass through given bin for ANY IMF condition.)
;
;                    NEVENTPERMINPLOT  :  Plot of number of events per minute that FAST spent in a given MLT/ILAT region when
;                                           FAST electron survey data were available (since that's the only time we looked
;                                           for Alfvén activity.
;                    LOGNEVENTPERMIN   :  Log of Neventpermin plot 
;                    MAKESMALLESTBINMIN:  Find the smallest bin, make that 
;
;                *ASSORTED PLOT OPTIONS--APPLICABLE TO ALL PLOTS
;		     MEDIANPLOT        :  Do median plots instead of averages.
;                    LOGAVGPLOT        :  Do log averaging instead of straight averages
;		     LOGPLOT           :     
;		     SQUAREPLOT        :  Do plots in square bins. (Default plot is in polar stereo projection)    
;                    POLARCONTOUR      :  Do polar plot, but do a contour instead
;                    WHOLECAP*         :   *(Only for polar plot!) Plot the entire polar cap, not just a range of MLTs and ILATs
;                    MIDNIGHT*         :   *(Only for polar plot!) Orient polar plot with midnight (24MLT) at bottom
;		     DBFILE            :  Which database file to use?
;                    NO_BURSTDATA      :  Exclude data from burst runs of Alfven_stats_5 (burst data were produced 2015/08/10)
;		     DATADIR           :     
;		     DO_CHASTDB        :  Use Chaston's original ALFVEN_STATS_3 database. 
;                                            (He used it for a few papers, I think, so it's good).
;
;                  *VARIOUS OUTPUT OPTIONS
;		     WRITEASCII        :     
;		     WRITEHDF5         :      
;                    WRITEPROCESSEDH2D :  Use this to output processed, histogrammed data. That way you
;                                            can share with others!
;		     SAVERAW           :  Save all raw data
;		     RAWDIR            :  Directory in which to store raw data
;                    JUSTDATA          :  No plots whatsoever; just give me the dataz.
;                    SHOWPLOTSNOSAVE   :  Don't save plots, just show them immediately
;		     PLOTDIR           :     
;		     PLOTPREFIX        :     
;		     PLOTSUFFIX        :     
;                    OUTPUTPLOTSUMMARY :  Make a text file with record of running params, various statistics
;                    MEDHISTOUTDATA    :  If doing median plots, output the median pointer array. 
;                                           (Good for further inspection of the statistics involved in each bin
;                    MEDHISTDATADIR    :  Directory where median histogram data is outputted.
;                    MEDHISTOUTTXT     :  Use 'medhistoutdata' output to produce .txt files with
;                                           median and average values for each MLT/ILAT bin.
;                    DEL_PS            :  Delete postscript outputted by plotting routines
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS: 
;                    MAXIMUS           :  Return maximus structure used in this pro.
;

; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE: 
;     Use Chaston's original (ALFVEN_STATS_3) database, only including orbits falling in the range 1000-4230
;     plot_alfven_stats_imf_screening,clockstr="duskward",/do_chastdb,$
;                                          plotpref='NESSF2014_reproduction_Jan2015--orbs1000-4230',ORBRANGE=[1000,4230]
;
;
;
; MODIFICATION HISTORY: Best to follow my mod history on the Github repository...
;                       2015/08/15 : Changed INCLUDE_BURST to NO_BURSTDATA, because why wouldn't we want to use it?
;                       Aug 2015   : Added INCLUDE_BURST option, which includes all Alfvén waves identified by as5 while FAST
;                                    was running in burst mode.
;                       Jan 2015  :  Finally turned interp_plots_str into a procedure! Here you have
;                                    the result.
;-

PRO plot_alfven_stats_imf_screening, maximus, $
                                     CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                     minMLT=minMLT,maxMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                     DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                     HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                     MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                                     BYMIN=byMin, BZMIN=bzMin, $
                                     BYMAX=byMax, BZMAX=bzMax, $
                                     SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                     HEMI=hemi, $
                                     DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                     NPLOTS=nPlots, $
                                     EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, ABS_EFLUX=abs_eFlux, $
                                     ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                                     NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                     PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                     NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                     IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                     NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                     CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                     NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                     ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                     ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                     NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                     DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                     NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                                     PROBOCCURRENCEPLOT=probOccurrencePlot,PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence, $
                                     MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                     LOGPLOT=logPlot, $
                                     SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                     DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                     NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                     WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                     SAVERAW=saveRaw, RAWDIR=rawDir, $
                                     JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                     PLOTDIR=plotDir, PLOTPREFIX=plotPrefix, PLOTSUFFIX=plotSuffix, $
                                     MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                                     _EXTRA = e

;;  COMPILE_OPT idl2

  ;;variables to be used by interp_contplot.pro

  !EXCEPT=0                                                      ;Do report errors, please
  ;;***********************************************
  ;;Tons of defaults
  
  defeFluxPlotType = "Max"
  defENumFlPlotType = "ESA_Number_flux" 
  defIFluxPlotType = "Max"
  defCharEPlotType = "lossCone"

  ; assorted
  defMaskMin = 1

  defPlotDir = '/SPENCEdata/Research/Cusp/ACE_FAST/plots/'
  defRawDir = 'rawsaves/'

  defOutSummary = 1 ;for output plot summary

  defDataDir = "/SPENCEdata/Research/Cusp/database/"
  defMedHistDataDir = 'out/medHistData/'
  defTempDir='/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  

  IF N_ELEMENTS(nPlots) EQ 0 THEN nPlots = 0                              ; do num events plots?
  IF N_ELEMENTS(ePlots) EQ 0 THEN ePlots =  0                             ;electron energy flux plots?
  IF N_ELEMENTS(eFluxPlotType) EQ 0 THEN eFluxPlotType = defEFluxPlotType ;options are "Integ" and "Max"
  IF N_ELEMENTS(iFluxPlotType) EQ 0 THEN iFluxPlotType = defIFluxPlotType ;options are "Integ", "Max", "Integ_Up", "Max_Up", and "Energy"
  IF N_ELEMENTS(eNumFlPlots) EQ 0 THEN eNumFlPlots = 0                    ;electron number flux plots?
  IF N_ELEMENTS(eNumFlPlotType) EQ 0 THEN eNumFlPlotType = defENumFlPlotType ;options are "Total_Eflux_Integ","Eflux_Losscone_Integ", "ESA_Number_flux" 
  IF N_ELEMENTS(pPlots) EQ 0 THEN pPlots =  0                             ;Poynting flux [estimate] plots?
  IF N_ELEMENTS(ionPlots) EQ 0 THEN ionPlots =  0                         ;ion Plots?
  IF N_ELEMENTS(charEPlots) EQ 0 THEN charEPlots =  0                     ;char E plots?
  IF N_ELEMENTS(charEType) EQ 0 THEN charEType = defCharEPlotType         ;options are "lossCone" and "Total"
  IF N_ELEMENTS(orbContribPlot) EQ 0 THEN orbContribPlot =  0             ;Contributing orbits plot?
  IF N_ELEMENTS(orbTotPlot) EQ 0 THEN orbTotPlot =  0                     ;"Total orbits considered" plot?
  IF N_ELEMENTS(orbFreqPlot) EQ 0 THEN orbFreqPlot =  0                   ;Contributing/total orbits plot?
  IF N_ELEMENTS(nEventPerOrbPlot) EQ 0 THEN nEventPerOrbPlot =  0         ;N Events/orbit plot?
  IF N_ELEMENTS(nEventPerMinPlot) EQ 0 THEN nEventPerMinPlot =  0         ;N Events/min plot?
  
  IF (KEYWORD_SET(nEventPerOrbPlot) OR KEYWORD_SET(nEventPerMinPlot) ) AND NOT KEYWORD_SET(nPlots) THEN BEGIN
     print,"Can't do nEventPerOrbPlot without nPlots!!"
     print,"Enabling nPlots..."
     nPlots=1
  ENDIF

  IF N_ELEMENTS(plotDir) EQ 0 THEN plotDir = defPlotDir ;;Directory stuff
  IF N_ELEMENTS(rawDir) EQ 0 THEN rawDir=defRawDir
  IF N_ELEMENTS(dataDir) EQ 0 THEN dataDir = defDataDir

  IF N_ELEMENTS(del_ps) EQ 0 THEN del_ps = 1            ;;not-directory stuff

  IF KEYWORD_SET(showPlotsNoSave) AND KEYWORD_SET(outputPlotSummary) THEN BEGIN    ;;Write output file with data params?
     print, "Is it possible to have outputPlotSummary==1 while showPlotsNoSave==0? You used to say no..."
     outputPlotSummary=defOutSummary   ;;Change to zero if not wanted
  ENDIF 

  ;;Any of multifarious reasons for needing output?
  IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN BEGIN
     keepMe = 1
  ENDIF ELSE keepMe = 0

  IF KEYWORD_SET(medHistOutTxt) AND NOT KEYWORD_SET(medHistOutData) THEN BEGIN
     PRINT, "medHistOutTxt is enabled, but medHistOutData is not!"
     print, "Enabling medHistOutData, since corresponding output is necessary for medHistOutTxt"
     WAIT, 0.5
     IF ~KEYWORD_SET(medHistDataDir) THEN medHistDataDir = defMedHistDataDir 
     medHistOutData = 1
  ENDIF

  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                  DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                  PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                  HOYDIA=hoyDia,LUN=lun
  
  ;;Shouldn't be leftover, unused params from batch call
  IF ISA(e) THEN BEGIN
     IF $
        NOT tag_exist(e,"wholecap") AND NOT tag_exist(e,"noplotintegral") $
        AND NOT tag_exist(e,"mirror") AND NOT tag_exist(e,"labelFormat") $ ;keywords for interp_polar2dhist
        AND NOT tag_exist(e,"plottitle") $
     THEN BEGIN                 ;Check for passed variables here
        help,e
        print,e
        print,"Why the extra parameters? They have no home..."
        RETURN
     ENDIF ELSE BEGIN
        IF tag_exist(e,"wholecap") THEN BEGIN
           IF e.wholecap GT 0 THEN BEGIN
              minM=0.0
              maxM=24.0
              IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
                 minI=defMinI
                 maxI=defMaxI
              ENDIF ELSE BEGIN
                 minI=-defMaxI
                 maxI=-defMinI
              ENDELSE
           ENDIF
        ENDIF
     ENDELSE
     
  ENDIF
  
  ;;Check on ILAT stuff; if I don't do this, all kinds of plots get boogered up
  IF ( (maxI-minI) MOD binI ) NE 0 THEN BEGIN
     IF STRLOWCASE(hemi) EQ "north" THEN BEGIN
        minI += CEIL(maxI-minI) MOD binI
     ENDIF ELSE BEGIN
        maxI -= CEIL(maxI-minI) MOD binI
     ENDELSE
  ENDIF

  ;;********************************************
  ;;A few other strings to tack on
  ;;tap DBs, and setup output
  IF KEYWORD_SET(no_burstData) THEN inc_burstStr ='burstData_excluded--' ELSE inc_burstStr=''

  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "_med" ELSE BEGIN
     IF KEYWORD_SET(logAvgPlot) THEN plotMedOrAvg = "_logAvg" ELSE plotMedOrAvg = "_avg"
  ENDELSE

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr=''
  IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = defMaskMin $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='maskMin_' + STRCOMPRESS(maskMin,/REMOVE_ALL) + '_'
     ENDIF
  ENDELSE
  
  ;;doing polar contour?
  polarContStr=''
  IF KEYWORD_SET(polarContour) THEN BEGIN
     polarContStr='polarCont_'
  ENDIF

  ;;parameter string
  paramStr=paramStr+plotMedOrAvg+maskStr+inc_burstStr + polarContStr

  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN $
     OPENW,lun,plotDir + 'outputSummary_'+paramStr+'.txt',/GET_LUN $
  ELSE lun=-1                   ;-1 is lun for STDOUT
  
  ;;********************************************************
  ;;Now clean and tap the databases and interpolate satellite data
  plot_i = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delay,LUN=lun, $
                                                  DBTIMES=cdbTime,dbfile=dbfile,DO_CHASTDB=do_chastdb, HEMI=hemi, $
                                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange,POYNTRANGE=poyntRange, $
                                                  MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                                  DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                  BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax,CLOCKSTR=clockStr,BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                  STABLEIMF=stableIMF,OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
                                                  HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData)
    
  ;;********************************************************
  ;;WHICH ORBITS ARE UNIQUE?
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  ;;printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."
  
  ;;********************************************
  ;;Variables for histos
  ;;Bin sizes for 2d histos

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot lims
  SET_ALFVEN_STATS_PLOT_LIMS,EPLOTRANGE=EPlotRange,LOGEFPLOT=logEfPlot, $
                             ENUMFLPLOTRANGE=ENumFlPlotRange,LOGENUMFLPLOT=logENumFlPlot, $
                             PPLOTRANGE=PPlotRange,LOGPFPLOT=logPfPlot, $
                             CHAREPLOTRANGE=charePlotRange,LOGCHAREPLOT=logCharEPlot,CHARERANGE=charERange, $
                             CHARIEPLOTRANGE=chariEPlotRange, $
                             NEVENTPERMINRANGE=nEventPerMinRange,LOGNEVENTPERMIN=logNEventPerMin, $
                             PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence
  
  ;;********************************************
  ;;Now time for data summary

  PRINT_SUMMARY_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                            ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                            minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                            DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                            MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                            HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                            BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                            PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                            SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                            HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                            HOYDIA=hoyDia,LUN=lun

  printf,lun,FORMAT='("Events per bin req",T30,": >=",T35,I8)',maskMin
  printf,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)',N_ELEMENTS(uniqueOrbs_ii)
  printf,lun,FORMAT='("Total N events",T30,":",T35,I8)',N_ELEMENTS(plot_i)
;; printf,lun,FORMAT='("Percentage of Chaston DB used: ",T35,I0)' + $
;;        strtrim((N_ELEMENTS(plot_i))/134925.0*100.0,2) + "%"
  printf,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")',(FLOAT(N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0)

  ;;********************************************************
  ;;HISTOS

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  GET_NEVENTS_AND_MASK,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       NEVENTSPLOTRANGE=nEventsPlotRange, $
                       H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr,H2DFLUXN=h2dFluxN,MASKMIN=maskMin,TMPLT_H2DSTR=tmplt_h2dStr, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr

  IF keepMe THEN BEGIN 
     dataRawPtrArr=dataRawPtr
     dataNameArr=[dataName,"histoMask_"] 
     dataRawPtrArr=[dataRawPtrArr,PTR_NEW(h2dMaskStr.data)] 
  ENDIF
  IF KEYWORD_SET(nPlots) THEN h2dStrArr=[h2dStr,h2dMaskStr] ELSE h2dStrArr = h2dMaskStr
  
  ;;#####FLUX QUANTITIES#########
  ;;########ELECTRON FLUX########
  IF KEYWORD_SET(eplots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_EFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=eFluxPlotType,PLOTRANGE=ePlotRange, $
                       NOPOSFLUX=noPoseflux,NONEGFLUX=noNegeflux,ABSFLUX=abseflux,LOGFLUXPLOT=logEfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF 
  ENDIF

  ;;########ELECTRON NUMBER FLUX########
  IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_ENUMFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=eNumFlPlotType,PLOTRANGE=ePlotRange, $
                       NOPOSFLUX=noPosENumFl,NONEGFLUX=noNegENumFl,ABSFLUX=absENumFl,LOGFLUXPLOT=logEfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF 

  ENDIF

  ;;########Poynting Flux########
  IF KEYWORD_SET(pplots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_PFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=PPlotRange, $
                       NOPOSFLUX=noPosPflux,NONEGFLUX=noNegPflux,ABSFLUX=absPflux,LOGFLUXPLOT=logPfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF

  ;;########ION FLUX########
  IF KEYWORD_SET(ionPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_IFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=iFluxPlotType,PLOTRANGE=iPlotRange, $
                       NOPOSFLUX=noPosIflux,NONEGFLUX=noNegIflux,ABSFLUX=absIflux,LOGFLUXPLOT=logIfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF

  ;;########CHARACTERISTIC ELECTRON ENERGY########
  IF KEYWORD_SET(chareEPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_CHAREE,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=charEType,PLOTRANGE=charEPlotRange, $
                       NOPOSFLUX=noPosCharE,NONEGFLUX=noNegCharE,ABSFLUX=absCharE,LOGFLUXPLOT=logCharEPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF

  ;;########CHARACTERISTIC ION ENERGY########
  IF KEYWORD_SET(chariEPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_CHARIE,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=chariEPlotRange, $
                       NOPOSFLUX=noPosChariE,NONEGFLUX=noNegChariE,ABSFLUX=absChariE,LOGFLUXPLOT=logChariEPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF


  ;;########Orbits########
  ;;Now do orbit data to show how many orbits contributed to each thingy.
  ;;A little extra tomfoolery is in order to get this right
  ;;h2dOrbN is a 2d histo just like the others
  ;;orbArr, on the other hand, is a 3D array, where the
  ;;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
  ;;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]

  ;;The following two lines shouldn't be necessary; the data are being corrupted somewhere when I run this with clockstr="dawnward"
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  
  IF KEYWORD_SET(orbContribPlot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) OR KEYWORD_SET(numOrbLim) THEN BEGIN
     GET_CONTRIBUTING_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                      DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                      ORBCONTRIBRANGE=orbContribRange, $
                                      H2DSTR=h2dOrbStr,TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                      DATANAME=dataName

     IF KEYWORD_SET(orbContribPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF

     ;;Mask all bins that don't have requisite number of orbits passing through
     IF KEYWORD_SET(numOrbLim) THEN BEGIN 
        h2dStrArr[KEYWORD_SET(nPlots)].data[WHERE(h2dOrbStr.data LT numOrbLim)] = 255 ;mask 'em!

        ;;little check to see how many more elements are getting masked
        ;;exc_orb_i = where(h2dOrbStr.data LT numOrbLim)
        ;;masked_i = where(h2dStr(1).data EQ 255)
        ;;print,n_elements(exc_orb_i) - n_elements(cgsetintersection(exc_orb_i,masked_i))
        ;;8
     ENDIF
     
  ENDIF

  ;;########TOTAL Orbits########
  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN
     GET_TOTAL_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                               DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                               ORBTOTRANGE=orbTotRange, $
                               H2DSTR=h2dTotOrbStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                               DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                               NPLOTS=nPlots,UNIQUEORBS_II=uniqueOrbs_ii

     IF KEYWORD_SET(orbTotPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dTotOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF
  ENDIF

  ;;########Orbit FREQUENCY########
  IF KEYWORD_SET(orbfreqplot) THEN BEGIN
     GET_ORBIT_FREQUENCY_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  ORBFREQRANGE=orbFreqRange, $
                                  H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                  DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                                  NPLOTS=nPlots,ORBTOTPLOT=orbTotPlot,UNIQUEORBS_II=uniqueOrbs_ii

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     
  ENDIF
     
  ;;########NEvents/orbit########
  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 
     GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                    DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                    ORBFREQRANGE=orbFreqRange,DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                    H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                    DATANAME=dataName,DATARAWPTR=dataRawPtr

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,dataName]
  ENDIF

  IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) THEN BEGIN 
     tHistDenominator = GET_TIMEHIST_DENOMINATOR(CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                                 ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                                 BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                                 HEMI=hemi, $
                                                 DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                                 MINM=minM,MAXM=maxM,BINM=binM, $
                                                 MINI=minI,MAXI=maxI,BINI=binI, $
                                                 DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                                 FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                                 FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                                 BURSTDATA_EXCLUDED=burstData_excluded, $
                                                 DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme)
     
     ;;########NEvents/minute########
     IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN
        GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                                  MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  LOGNEVENTPERMIN=logNEventPerMin,NEVENTPERMINRANGE=nEventPerMinRange, $
                                  H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                                  DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF

     ;;########Event probability########
     IF KEYWORD_SET(probOccurrencePlot) THEN BEGIN
        GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                     LOGPROBOCCURRENCE=logProbOccurrence, PROBOCCURRENCERANGE=probOccurrenceRange, DO_WIDTH_X=do_width_x, $
                                     MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                     DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                     OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                     H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                     DATANAME=dataName,DATARAWPTR=dataRawPtr

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF
  ENDIF

  ;;********************************************************
  ;;If something screwy goes on, better take stock of it and alert user
  FOR i = 2, N_ELEMENTS(h2dStrArr)-1 DO BEGIN 
     IF n_elements(where(h2dStrArr[i].data EQ 0,/NULL)) LT $
        n_elements(where(h2dStrArr[0].data EQ 0,/NULL)) THEN BEGIN 
        printf,lun,"h2dStrArr."+h2dStrArr[i].title + " has ", strtrim(n_elements(where(h2dStrArr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_elements(where(h2dStrArr[0].data EQ 0)),2),"." 
     printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
  ENDFOR

  ;;Now that we're done using nplots, let's log it, if requested:
  IF KEYWORD_SET(nPlots) AND KEYWORD_SET(logNEventsPlot) THEN BEGIN
     dataNameArr[0] = 'log_' + dataNameArr[0]
     h2dStrArr[0].data(where(h2dStrArr.data GT 0)) = ALOG10(h2dStrArr[0].data(where(h2dStrArr.data GT 0)))
     h2dStrArr[0].lim = [(h2dStrArr[0].lim[0] LT 1) ? 0 : ALOG10(h2dStrArr[0].lim[0]),ALOG10(h2dStrArr[0].lim[1])] ;lower bound must be one
     h2dStrArr[0].title = 'Log ' + h2dStrArr[0].title
  ENDIF
  ;;********************************************************
  ;;Handle Plots all at once

  ;;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively
  h2dStrArr=SHIFT(h2dStrArr,-1-(nPlots))
  IF keepMe THEN BEGIN 
     dataNameArr=SHIFT(dataNameArr,-2) 
     dataRawPtrArr=SHIFT(dataRawPtrArr,-2) 
  ENDIF

  IF N_ELEMENTS(squarePlot) EQ 0 THEN save,h2dStrArr,dataNameArr,maxM,minM,maxI,minI,binM,binI,do_lShell,minL,maxL,binL,$
                           rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemi,$
                           filename=defTempDir + 'polarplots_'+paramStr+".dat"

  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(showPlotsNoSave) THEN BEGIN 
     IF N_ELEMENTS(justData) EQ 0 AND KEYWORD_SET(squarePlot) THEN $
        cgWindow, 'interp_contplotmulti_str', h2dStrArr,$
                  Background='White', $
                  WTitle='Flux plots for '+hemi+'ern Hemisphere, '+clockStr+ $
                  ' IMF, ' + strmid(plotMedOrAvg,1) $
     ELSE IF N_ELEMENTS(justData) EQ 0 THEN $
        FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO $ 
           cgWindow,'interp_polar2dhist',h2dStrArr[i],defTempDir + 'polarplots_'+paramStr+".dat", $
                CLOCKSTR=clockStr, _extra=e,$
                Background="White",wxsize=800,wysize=600, $
                WTitle='Polar plot_'+dataNameArr[i]+','+hemi+'ern Hemisphere, '+clockStr+ $
                ' IMF, ' + strmid(plotMedOrAvg,1) $
                
     ELSE PRINTF,LUN,"**Plots turned off with justData**" 
  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(squarePlot) AND NOT KEYWORD_SET(justData) THEN BEGIN 
        CD, CURRENT=c ;; & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 

        ;;Create a PostScript file.
        cgPS_Open, plotDir + plotPrefix + 'fluxplots_'+paramStr+'.ps', /nomatch, xsize=1000, ysize=1000
        interp_contplotmulti_str,h2dStrArr 
        cgPS_Close 

        ;;Create a PNG file with a width of 800 pixels.
        cgPS2Raster, plotDir + plotPrefix + 'fluxplots_'+paramStr+'.ps', $
                     /PNG, Width=800, DELETE_PS = del_PS
     
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(justData) EQ 0 THEN BEGIN 
           CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
           PRINTF,LUN, "Creating output files..." 
           
           FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
              
              IF KEYWORD_SET(polarContour) THEN BEGIN
                 ;; The NAME field of the !D system variable contains the name of the
                 ;; current plotting device.
                 mydevice = !D.NAME
                 ;; Set plotting to PostScript:
                 SET_PLOT, 'PS'
                 ;; Use DEVICE to set some PostScript device options:
                 DEVICE, FILENAME='myfile.ps', /LANDSCAPE
                 ;; Make a simple plot to the PostScript file:
                 interp_polar2dcontour,h2dStrArr[i],dataNameArr[i],defTempDir + 'polarplots_'+paramStr+".dat", $
                                       fname=plotDir + dataNameArr[i]+paramStr+'.png', _extra=e
                 ;; Close the PostScript file:
                 DEVICE, /CLOSE
                 ;; Return plotting to the original device:
                 SET_PLOT, mydevice
              ENDIF ELSE BEGIN
                 ;;Create a PostScript file.
                 cgPS_Open, plotDir + dataNameArr[i]+paramStr+'.ps' 
                 ;;interp_polar_plot,[[*dataRawPtrArr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
                 ;;          h2dStrArr[0].lim 
                 interp_polar2dhist,h2dStrArr[i],defTempDir + 'polarplots_'+paramStr+".dat",CLOCKSTR=clockStr,_extra=e 
                 cgPS_Close 
                 ;;Create a PNG file with a width of 800 pixels.
                 cgPS2Raster, plotDir + dataNameArr[i]+paramStr+'.ps', $
                              /PNG, Width=800, DELETE_PS = del_PS
              ENDELSE
              
           ENDFOR    
        
        ENDIF
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
     CLOSE,lun 
     FREE_LUN,lun 
  ENDIF

  ;;Save raw data, if desired
  IF KEYWORD_SET(saveRaw) THEN BEGIN
     SAVE, /ALL, filename=rawDir+'fluxplots_'+paramStr+".dat"

  ENDIF

   ;;********************************************************
   ;;Thanks, IDL Coyote--time to write out lots of data
   IF KEYWORD_SET(writeHDF5) THEN BEGIN 
      ;;write out raw data here
      FOR j=0, N_ELEMENTS(h2dStrArr)-2 DO BEGIN 
         fname=plotDir + dataNameArr[j]+paramStr+'.h5' 
         PRINT,"Writing HDF5 file: " + fname 
         fileID=H5F_CREATE(fname) 
         datatypeID=H5T_IDL_CREATE(h2dStrArr[j].data) 
         dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
         datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
         H5D_WRITE,datasetID, h2dStrArr[j].data 
         H5F_CLOSE,fileID 
      ENDFOR 

      ;;To read your newly produced HDF5 file, do this:
      ;;s = H5_PARSE(fname, /READ_DATA)
      ;;HELP, s.mydata._DATA, /STRUCTURE  
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR j=0, N_ELEMENTS(h2dStrArr)-2 DO BEGIN 
            fname=plotDir + dataNameArr[j]+paramStr+'.h5' 
            PRINT,"Writing HDF5 file: " + fname 
            fileID=H5F_CREATE(fname) 
            
            ;;    datatypeID=H5T_IDL_CREATE() 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStrArr[j].data 
            
            datatypeID=H5T_IDL_CREATE(h2dStrArr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStrArr[j].data     
            
            
            datatypeID=H5T_IDL_CREATE(h2dStrArr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStrArr[j].data 
            H5F_CLOSE,fileID 
         ENDFOR 
      ENDIF 
   ENDIF

   IF KEYWORD_SET(writeASCII) THEN BEGIN 
      ;;These are the "raw" data, just as we got them from Chris
      FOR j = 0, n_elements(dataRawPtrArr)-3 DO BEGIN 
         fname=plotDir + dataNameArr[j]+paramStr+'.ascii' 
         PRINT,"Writing ASCII file: " + fname 
         OPENW,lun2, fname, /get_lun 

         FOR i = 0, N_ELEMENTS(plot_i) - 1 DO BEGIN 
            PRINTF,lun2,(maximus.ILAT(plot_i))[i],(maximus.MLT(plot_i))[i],$
                   (*dataRawPtrArr[j])[i],$
                   FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
         ENDFOR 
         CLOSE, lun2   
         FREE_LUN, lun2 
      ENDFOR 
      
      ;;NOW DO PROCESSED H2D DATA 
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR i = 0, n_elements(h2dStrArr)-1 DO BEGIN 
            fname=plotDir + "h2d_"+dataNameArr[i]+paramStr+'.ascii' 
            PRINT,"Writing ASCII file: " + fname 
            OPENW,lun2, fname, /get_lun 
            FOR j = 0, N_ELEMENTS(outH2DBinsMLT) - 1 DO BEGIN 
               FOR k = 0, N_ELEMENTS(outH2DBinsILAT) -1 DO BEGIN 
                  PRINTF,lun2,outH2DBinsILAT[k],$
                         outH2DBinsMLT[j],$
                         (h2dStrArr[i].data)[j,k],$
                         FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
               ENDFOR 
            ENDFOR 
            CLOSE, lun2   
            FREE_LUN, lun2 
         ENDFOR 
      ENDIF 
   ENDIF

END