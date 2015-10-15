PRO SET_ALFVEN_STATS_PLOT_LIMS,CHAREPLOTRANGE=charePlotRange,LOGCHAREPLOT=logCharEPlot,CHARERANGE=charERange, $
                               PPLOTRANGE=PPlotRange,LOGPFPLOT=logPfPlot, $
                               ENUMFLPLOTRANGE=ENumFlPlotRange,LOGENUMFLPLOT=logENumFlPlot, $
                               EPLOTRANGE=EPlotRange,LOGEFPLOT=logEfPlot, $
                               NEVENTPERMINRANGE=nEventPerMinRange,LOGNEVENTPERMIN=logNEventPerMin, $
                               PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence

  COMPILE_OPT idl2

  ;;  defCharEPlotRange         = [1,4000]
  ;;  defCharELogPlotRange      = [0,3.60206]
  ;;  defCharELogPlotRange      = [0,3.69897]

  defENumFlPlotRange        = [1e5,1e9]
  defENumFlLogPlotRange     = [1,9]

  defEPlotRange             = [0.01,100]
  defELogPlotRange          = [-2,2]

  defPPlotRange             = [0.1,2.5]
  defPLogPlotRange          = [-1.5288,0.39794]

  defNEventPerMinRange      = [0,25]
  defLogNEventPerMinRange   = [1,ALOG10(25.0)]

  defProbOccurrenceRange    = [0,1]
  defLogProbOccurrenceRange = [10e-4,1]

  IF N_ELEMENTS(CharEPlotRange) EQ 0 THEN BEGIN   ;;For linear or log charE plotrange
;;     IF N_ELEMENTS(logCharEPlot) EQ 0 THEN CharEPlotRange = defCharEPlotRange ELSE CharEPlotRange= defCharELogPlotRange
     IF N_ELEMENTS(logCharEPlot) EQ 0 THEN CharEPlotRange=charERange ELSE CharEPlotRange=ALOG10(charERange)
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(logCharEPlot) GT 0 THEN CharEPlotRange=ALOG10(charEPlotRange)
  ENDELSE

  IF N_ELEMENTS(ENumFlPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- number flux plotrange
     IF N_ELEMENTS(logENumFlPlot) EQ 0 THEN ENumFlPlotRange= defENumFlPlotRange ELSE ENumFlPlotRange= defENumFlLogPlotRange
  ENDIF

  IF N_ELEMENTS(EPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- energy Flux plotrange
     IF N_ELEMENTS(logEfPlot) EQ 0 THEN EPlotRange = defEPlotRange ELSE EPlotRange = defELogPlotRange
  ENDIF

  ;;For linear or log PFlux plotrange
  IF N_ELEMENTS(PPlotRange) EQ 0 THEN BEGIN
     IF N_ELEMENTS(logPfPlot) EQ 0 THEN PPlotRange=defPLogPlotRange ELSE PPlotRange= defPPlotRange
  ENDIF

  IF N_ELEMENTS(nEventPerMinRange) EQ 0 OR N_ELEMENTS(nEventPerMinRange) NE 2 THEN BEGIN
     IF N_ELEMENTS(logNEventPerMin) EQ 0 THEN nEventPerMinRange = defNEventPerMinRange ELSE nEventPerMinRange = defLogNEventPerMinRange
  ENDIF
     
  IF N_ELEMENTS(probOccurrenceRange) EQ 0 OR N_ELEMENTS(probOccurrenceRange) NE 2 THEN BEGIN
     IF N_ELEMENTS(logProbOccurrence) EQ 0 THEN probOccurrenceRange = defProbOccurrenceRange ELSE probOccurrenceRange = defLogProbOccurrenceRange
  ENDIF
     
END