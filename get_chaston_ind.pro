;***********************************************
;This script merely accesses the ACE and Chaston
;current filaments databases in order to generate
;Created 01/08/2014
;See 'current_event_Poynt_flux_vs_imf.pro' for
;more info, since that's where this code comes from.

FUNCTION get_chaston_ind,maximus,satellite,lun,DBFILE=dbfile,CDBTIME=cdbTime,CHASTDB=CHASTDB, $
                         ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange,CHARERANGE=charERange

  COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNegMC

  ;;***********************************************
  ;;Load up all the dater, working from ~/Research/ACE_indices_data/idl
  
  defLoaddataDir = '/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
  defPref = "Dartdb_02282015--500-14999"
  defCDBTimeFile = defLoaddataDir + defPref + "--cdbTime.sav"
  defDBFile = defLoaddataDir + defPref + "--maximus.sav"

  IF NOT KEYWORD_SET(dbfile) AND NOT KEYWORD_SET(CHASTDB) THEN BEGIN
     pref = "Dartdb_02282015--500-14999"
     dbfile = pref + "--maximus.sav"
     loaddataDir = defLoaddataDir
     cdbTimeFile = defCDBTimeFile
     IF FILE_TEST(cdbTimeFile) AND cdbTime EQ !NULL THEN restore,cdbTimeFile
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(CHASTDB) THEN BEGIN
        dbfile = "maximus.dat"
        loaddataDir='/SPENCEdata/Research/Cusp/database/processed/'
        cdbTimeFile = loaddataDir + 'cdbTime.sav'
        IF FILE_TEST(cdbTimeFile) THEN restore,cdbTimeFile
     ENDIF
  ENDELSE

  ;;Load, if need be
  IF maximus EQ !NULL THEN restore,loaddataDir + dbfile ELSE BEGIN 
     print,"There is already a maximus struct loaded! Not loading " + defDBFile
  ENDELSE

  ;;generate indices based on restrictions in interp_plots.pro
  ind_region=where(maximus.ilat GE minI AND maximus.ilat LE maxI AND maximus.mlt GE minM AND maximus.mlt LE maxM)
  ind_magc_ge10=where(maximus.mag_current GE minMC)
  ind_magc_leneg10=where(maximus.mag_current LE maxNegMC)
  ind_magc_geabs10=where(maximus.mag_current LE maxNegMC OR maximus.mag_current GE minMC)
  ind_region_magc_ge10=cgsetintersection(ind_region,ind_magc_ge10)
  ind_region_magc_leneg10=cgsetintersection(ind_region,ind_magc_leneg10)
  ind_region_magc_geabs10=cgsetintersection(ind_region,ind_magc_geabs10)
  ;;ind_e_ge_min_le_max=where(maximus.char_ion_energy GE minE AND maximus.char_ion_energy LE maxE)
  ;;ind_region_e=cgsetintersection(ind_e_ge_min_le_max,ind_region)
  ;;ind_region_e_curge10=cgsetintersection(ind_region_e,ind_magc_ge10)
  ;;ind_region_e_curleneg10=cgsetintersection(ind_region_e,ind_magc_leneg10) 
  ;; ind_n_orbs=where(maximus.orbit GE orbRange[0] AND maximus.orbit LE orbRange[1])
  ;; ind_region_e_n_orbs=cgsetintersection(ind_region_e,ind_n_orbs)
  
  ;;limits on orbits to use?
  IF KEYWORD_SET (orbRange) THEN BEGIN
     IF N_ELEMENTS(orbRange) EQ 2 THEN BEGIN
        
        printf,lun,"Min orbit: " + strcompress(orbRange[0],/remove_all)
        printf,lun,"Max orbit: " + strcompress(orbRange[1],/remove_all)

        ind_n_orbs=where(maximus.orbit GE orbRange[0] AND maximus.orbit LE orbRange[1])
        ind_region_magc_geabs10=cgsetintersection(ind_region_magc_geabs10,ind_n_orbs)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'orbRange'!!"
        printf,lun,"Please use orbRange=[minOrb maxOrb]"
        RETURN, -1
     ENDELSE
  ENDIF
  
  ;;limits on altitudes to use?
  IF KEYWORD_SET (altitudeRange) THEN BEGIN
     IF N_ELEMENTS(altitudeRange) EQ 2 THEN BEGIN
        
        printf,lun,"Min altitude: " + strcompress(altitudeRange[0],/remove_all)
        printf,lun,"Max altitude: " + strcompress(altitudeRange[1],/remove_all)

        ind_n_orbs=where(maximus.alt GE altitudeRange[0] AND maximus.alt LE altitudeRange[1])
        ind_region_magc_geabs10=cgsetintersection(ind_region_magc_geabs10,ind_n_orbs)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'altitudeRange'!!"
        printf,lun,"Please use altitudeRange=[minAlt maxAlt]"
        RETURN, -1
     ENDELSE
  ENDIF
  
  ;;limits on characteristic electron energies to use?
  IF KEYWORD_SET (charERange) THEN BEGIN
     IF N_ELEMENTS(charERange) EQ 2 THEN BEGIN
        
        printf,lun,"Min characteristic electron energy: " + strcompress(charERange[0],/remove_all)
        printf,lun,"Max characteristic electron energy: " + strcompress(charERange[1],/remove_all)

        ind_n_orbs=where(maximus.max_chare_losscone GE charERange[0] AND maximus.max_chare_losscone LE charERange[1])
        ind_region_magc_geabs10=cgsetintersection(ind_region_magc_geabs10,ind_n_orbs)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'charERange'!!"
        printf,lun,"Please use charERange=[minCharE maxCharE]"
        RETURN, -1
     ENDELSE
  ENDIF


  ;;gotta screen to make sure it's in ACE db too:
  ;;Only so many are useable, since ACE data start in 1998
  
  ind_ACEstart=(satellite EQ "ACE") ? 82896 : 0
  
  ind_region_magc_geabs10_ACEstart=ind_region_magc_geabs10(where(ind_region_magc_geabs10 GE ind_ACEstart,$
                                                                 nGood,complement=lost,ncomplement=nlost))
  lost=ind_region_magc_geabs10(lost)

  ;;Now, clear out all the garbage (NaNs & Co.)
  good_i = alfven_db_cleaner(maximus,LUN=lun)
  IF good_i NE !NULL THEN ind_region_magc_geabs10_ACEstart=cgsetintersection(ind_region_magc_geabs10_ACEstart,good_i)

  ;Re-make cdbTime if we don't have it made already
  IF cdbTime EQ !NULL THEN cdbTime=str_to_time( maximus.time( ind_region_magc_geabs10_ACEstart ) ) $
  ELSE cdbTime = cdbTime(ind_region_magc_geabs10_ACEstart)
  
  printf,lun,""
  printf,lun,"****From get_chaston_ind.pro****"
  printf,lun,"DBFile = " + dbfile
  printf,lun,""
  IF KEYWORD_SET (orbRange) AND N_ELEMENTS(orbRange) EQ 2 THEN BEGIN
     printf,lun,"Min orbit: " + strcompress(orbRange[0],/remove_all)
     printf,lun,"Max orbit: " + strcompress(orbRange[1],/remove_all)
  ENDIF
  IF KEYWORD_SET (altitudeRange) AND N_ELEMENTS(altitudeRange) EQ 2 THEN BEGIN
     printf,lun,"Min altitude: " + strcompress(altitudeRange[0],/remove_all)
     printf,lun,"Max altitude: " + strcompress(altitudeRange[1],/remove_all)
  ENDIF
  IF KEYWORD_SET (charERange) AND N_ELEMENTS(charERange) EQ 2 THEN BEGIN
     printf,lun,"Min characteristic electron energy: " + strcompress(charERange[0],/remove_all)
     printf,lun,"Max characteristic electron energy: " + strcompress(charERange[1],/remove_all)
  ENDIF
  printf,lun,"There are " + strtrim(n_elements(ind_region_magc_geabs10_ACEstart),2) + " total events making the cut." 
  IF (satellite EQ "ACE") THEN $
     printf,lun,"You're losing " + strtrim(nlost,2) + $
            " current events because ACE data doesn't start until " + strtrim(maximus.time(ind_ACEstart),2) + "."
  printf,lun,"****END get_chaston_ind.pro****"
  printf,lun,""

  ;;***********************************************
  ;;Delete all the unnecessaries
;;  undefine,ind_region,ind_magc_ge10,ind_magc_leneg10,ind_magc_geabs10,$
;;              ind_region_magc_ge10,ind_region_magc_leneg10,ind_region_magc_geabs10,$
;;              ind_ACEstart

  RETURN, ind_region_magc_geabs10_ACEstart
  
END