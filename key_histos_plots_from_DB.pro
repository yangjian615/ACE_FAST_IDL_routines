;+
; NAME: KEY_HISTOS_PLOTS_FROM_DB
;
;
;
; PURPOSE: Get a sense for what's happening in a given database. Specifically, the key data products I'm picking here are
;          -> alt                  (altitude)
;          -> mag_current          (Yep, current derived from magnetometer)
;          -> elec_energy_flux     (electron energy flux)
;          -> delta_b              (peak-to-peak of the max magnetic field fluctuation)
;          -> delta_e              (peak-to-peak of the max electric field fluctuation)
;          -> max_chare_losscone   (Max characteristic energy in the losscone)
;          -> pfluxEst             (Poynting flux estimate)
;            
;          Could also mess around with
;          -> width_x              (width of filament along spacecraft trajectory)
;          -> width_time           (temporal width)
;
; CATEGORY: Are you serious? Everyone knows the answer to this.
;
;
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY: 2015/03/27
;                       Birth
;-

PRO KEY_HISTOS_PLOTS_FROM_DB,dbFile,DAYSIDE=dayside,NIGHTSIDE=nightside,CHARESCR=chareScr,ABSMAGCSCR=absMagcScr

  default_DBFile = "scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav"

  IF NOT KEYWORD_SET(dbFile) THEN restore,default_DBFile ELSE restore,dbFile
  
  ;;names of the POSSIBILITIES
  maxTags=tag_names(maximus)

  ;;****************************************
  ;;screen on maximus? YES

  ;;dayside
  ;; IF KEYWORD_SET(dayside) THEN BEGIN
  ;;    maximus = resize_maximus(maximus,4,6,18)  ;; Dayside MLTs
  ;;    maximus = resize_maximus(maximus,5,60,84) ;; ILAT range
  ;; ENDIF

  ;;nightside
  ;;Not currently functional, because resize_maximus can't handle selecting MLTS 18-6, you see
  ;; IF KEYWORD_SET(nightside) THEN BEGIN
  ;;    maximus = resize_maximus(maximus,4,6,18)    ;; Nightside MLTs
  ;;    maximus = resize_maximus(maximus,5,60,84)   ;; ILAT range
  ;; ENDIF

  ;; screen by characteristic energy
  ;; IF KEYWORD_SET(charEScr) THEN maximus = resize_maximus(maximus,12,4,300)  

  ;; screen by magnetometer current
  ;; IF KEYWORD_SET(absMagcScr) THEN maximus = resize_maximus(maximus,6,-ABS(absMagcScr),ABS(absMagcScr))  

  ;;****************************************


  plotSuff = ""
  ;; plotSuff = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE"

  ;"Key" data products (I guess they're key)
  ;; print,maxTags(3)      ;alt
  ;; print,maxTags(6)      ;mag_current
  ;; print,maxTags(8)      ;elec_energy_flux
  ;; print,maxTags(12)     ;max_chare_losscone
  ;; print,maxTags(22)     ;delta_b
  ;; print,maxTags(23)     ;delta_e
  ;; print,maxTags(48)     ;pfluxEst

  ;; optional
  ;; print,maxTags(21)     ;width_x
  ;; print,maxTags(20)     ;width.time
  
  ;; maxStructInd = [3,6]
  maxStructInd = [3,6,8,12,22,23,48]
  n_dataz = n_elements(maxStructInd)

  maxStructLims=make_array(n_elements(maxStructInd),2)

  ;; limits imposed by alfven_db_cleaner
  maxStructLims[0,*] = [0,5000] ; alt
  maxStructLims[1,*] = [-500,500] ; mag_current
  maxStructLims[2,*] = [0,1e3] ; elec_energy_flux
  maxStructLims[3,*] = [4,4e3] ; max_chare_losscone
  maxStructLims[4,*] = [5,1e3] ; delta_b
  maxStructLims[5,*] = [10,1e4] ; delta_e
  database has no imposed limit for pflux
  maxStructLims[6,*] = [1e-5,10] ; pfluxEst

  maxStructLims[0,*] = [0,4300] ; alt
  maxStructLims[1,*] = [-250,250] ; mag_current
  maxStructLims[2,*] = [1e-3,100] ; elec_energy_flux
  maxStructLims[3,*] = [4,4000] ; max_chare_losscone
  maxStructLims[4,*] = [5,1000] ; delta_b
  maxStructLims[5,*] = [10,10000] ; delta_e
  maxStructLims[6,*] = [1e-5,0.1]  ; pfluxEst


  maxStructLog = MAKE_ARRAY(n_elements(maxStructInd), VALUE=0)
  maxStructLog[2] = 1
  maxStructLog[3] = 1
  maxStructLog[4] = 1
  maxStructLog[5] = 1
  maxStructLog[6] = 1

  ;log it up
  FOR k=0,n_elements(maxStructInd)-1 DO BEGIN
     IF maxStructLog[k] THEN BEGIN
        mS_k = (maxStructInd[k])
        maximus.(mS_k) = ALOG10(maximus.(mS_k))
        maxStructLims[k,*] = ALOG10(maxStructLims[k,*])
     ENDIF
  ENDFOR


  ;; Here's a winning strategy to plot everything versus everything
  ;; This will loop over every unique pair in maxStructInd

  FOR i=1,n_dataz DO BEGIN

     tempStructInd = shift(maxStructInd,-i+1)
     tempStructLims = shift(maxStructLims,-i+1)
     tempStructLog =  shift(maxStructLog,-i+1)
     mS_i = maxStructInd(i-1)

     FOR j=1,n_dataz-i DO BEGIN

        mS_j = tempStructInd(j)
;;        print,format='(A0,T20,A0)',maxTags(maxStructInd(i)),maxTags(tempStructInd(j))
        print,format='(I0,T5,I0)',mS_i,mS_j

        ;; Now if we just create a [n_dataz-1]x2 matrix of limits for each data product, we can plot everything versus everything with ease!
        ;; Something like this
        ;; cgscatter2d,maximus.(mS_i),maximus.(mS_j), $
        ;;             TRANSPARENCY=80,SYMSIZE=0.5,PSYM=9, $ ;This is necessary. There is such a high density of points that we need transparency
        ;;             XRANGE=maxStructLims(i-1,*),YRANGE=tempStructLims(j,*), $
        ;;             XTITLE=maxTags(mS_i),YTITLE=maxTags(mS_j), $
        ;;             OUTFILENAME=maxTags(mS_i)+"_vs_"+maxTags(mS_j)+".png"

        curPlot = scatterplot(maximus.(mS_j),maximus.(mS_i), $
                              SYMBOL="o",SYM_TRANSPARENCY=99,SYM_SIZE=0.5, $ ;There is such a high density of points that we need transparency
                              XRANGE=tempStructLims(j,*),YRANGE=maxStructLims(i-1,*), $
                              XTITLE=maxTags(mS_j),YTITLE=maxTags(mS_i), $
                              DIMENSIONS=[600,600])
        

        curPlot.save,maxTags(mS_i)+"_vs_"+maxTags(mS_j)+plotSuff+".png",resolution=300

     ENDFOR

     cghistoplot,maximus.(mS_i),TITLE=maxTags(mS_i), $
                 MININPUT=maxStructLims(i-1,0),MAXINPUT=maxStructLims(i-1,1),$
                 OUTPUT=maxTags(mS_i)+"_histogram"+plotSuff+".png"

  ENDFOR

END