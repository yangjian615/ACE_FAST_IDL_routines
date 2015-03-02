;01/30/2015 6 PM
;Here I am, reproducing these figures on a Friday night. It's totally excellent, because things appear to line up with Chaston's picture!

PRO commands_for_Chaston_2003_figs4a_c_reproduction

  date='02282015'

  dirs='all_IMF'
  ;; dirs=['duskward', 'dawnward']

  plotprf="Foolin_round_" + date + "/midnight_nomask/Dartdb_" + date 
  ;; plotprf="LaBelle_Bin_mtg--" + date + "/Chaston_2003_fig4a-d/Dartdb_" + date 

  ;;different delay?
  ;delay=!NULL
  delay=1020

  mskm=9

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm,/orbplots, $
                                        /orbcontribplot,/orbtotplot,/orbfreqplot, $
                                        /neventperorbplot, /logneventperorb, $
                                        ;; neventperorbrange=[0.01,10.0], $
                                        neventperorbrange=[-2.0,1.0], $
                                        nEventsRange=[0,3000], orbFreqRange=[0.0, 0.8], orbcontribrange=[1,200], $
                                        /WHOLECAP,/midnight,DELAY=delay

  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",customerange=[-1,1.5],/logefplot,/nonegeflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",eplotrange=[-1,1.5],/logefplot,/abseflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  
  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,pplotrange=[0.5,10],/abspflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  
  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[-1.2,1.0],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,/medianplot,/abspflux,/WHOLECAP,/midnight,DELAY=delay

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /chareplot,charetype="lossCone",chareplotrange=[0,250], $
                                        /medianplot,/WHOLECAP,/midnight,DELAY=delay

END