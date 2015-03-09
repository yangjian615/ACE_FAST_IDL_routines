;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_dusk_dawn_plots

  date='03072015'
  dbDate='02282015'

;;  hemi='North'
;;  mirror = !NULL
  hemi='South'
  mirror = !NULL

  ;dirs='all_IMF'
  ;; dirs=['dawn-north', 'dawn-south', 'dusk-north', 'dusk-south']
  ;; dirs=['duskward', 'dawnward','bzSouth','bzNorth']
  dirs=['duskward', 'dawnward']
  ;; dirs=['bzNorth','bzSouth']

  ;Plot prefix?
  ;;plotprf="Foolin_round_" + date + "/quads/Dartdb_" + dbDate
  plotDir="plots/Foolin_round_" + date + "/"
  plotSuff="Dartdb_" + dbDate + "--" + "pFlux_GE_0.1"
  ;; plotprf="LaBelle_Bin_mtg--" + date + "/Dartdb_" + dbDate

  ;; mask min?
  mskm=3

  ;; midnight?
  midn=!NULL
  ;; midn=1

  ;; byMin?
  byMin=3.0 ;for bzNorth, bzSouth plots
  ;; byMin=3.0

  ;; whole cap?
  wc=1
  ;; wc=1

  ;;median histogram data?
  medHistOutData=1

  ;;median histogram text output?
  medHistOutTxt=1

  ;;different delay?
  delay=!NULL
  ;;delay=1020

  ;;smooth IMF data?
  ;; smoothWindow=!NULL
  smoothWindow=5 ;in Min

  ;;stability requirement?
  ;; stableIMF = !NULL
  stableIMF = 1 ; in Min

  ;delete postscript?
  del_PS = 1

  ;charERange?
  charERange=[4.0,300]

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /orbPlots, /orbContribPlot,/orbTotPlot,/orbFreqPlot, $
                                        /nEventPerOrbPlot,/logneventperorb, /divNEvByApplicable, $
;;                                        neventperorbrange=[0.0,3.5], $
;;                                        neventperorbrange=[0.0,80.0], $
                                        neventperorbrange=[FLOOR(100.0*ALOG10(mskm))/100.0,2], $
;;for northern hemi, 0.1 min poynting flux                                        nEventsRange=[100,750], orbFreqRange=[0.0, 0.15], orbContribRange=[0,40], $
                                        nEventsRange=[0,425], orbFreqRange=[0.0, 0.1], orbContribRange=[0,20], $
                                        WHOLECAP=wc,midnight=midn,BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS
  
  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",eplotrange=[-1,2.0],/logefplot,/nonegeflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",eplotrange=[-1,1.4],/logefplot,/abseflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS

  
  ;;;;;;;;;;;;;;;
  ;ion plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /ionplots,ifluxplottype="Max",iplotrange=[6.0,9.0],/logifplot,/absiflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS

  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,pplotrange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot, $
  ;; ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir + "ChastRange_",directions=dirs,maskmin=mskm, $
  ;; ;;                                       /pplots,pplotrange=[0.01,1.5],/abspflux,/medianplot, $
  ;;                                       WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
  ;;                                       altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, $
  ;;                                       MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
  ;;                                       SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
  ;;                                       DEL_PS=del_PS
  
  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,/logpfplot,/nonegpflux,/medianplot, $
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir + "otherRange_",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,/abspflux,/medianplot, $
                                        pplotrange=[-1,1], $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff, directions=dirs,maskmin=mskm, $
                                        /chareplots,charetype="lossCone",/logchareplot,/nonegchare,charePlotRange=[1.3, 2.477], $
                                        /medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS

END