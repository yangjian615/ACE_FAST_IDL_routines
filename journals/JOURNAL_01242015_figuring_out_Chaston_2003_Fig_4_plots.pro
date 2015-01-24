;;01242015, Sat. around 4pm
;This journal represents my effort to figure out why we always get such crappy electron energy plots.
;I am now led to believe that it's because I've been allowing for values that are way too high (e.g., 1e4 or 1e5).
;If I restrict these to be between 0.01 and 100, they make way more sense.

restore,'scripts_for_processing_Dartmouth_data/Dartdb_01242015_maximus.sav'
help,maximus,/str
;;** Structure <98b488>, 46 tags, length=52204440, data length=52204430, refs=1:
;;  ORBIT           INT       Array[269095]
;;  ALFVENIC        FLOAT     Array[269095]
;;  TIME            STRING    Array[269095]
;;  ALT             FLOAT     Array[269095]
;;  MLT             FLOAT     Array[269095]
;;  ILAT            FLOAT     Array[269095]
;;  MAG_CURRENT     FLOAT     Array[269095]
;;  ESA_CURRENT     FLOAT     Array[269095]
;;  ELEC_ENERGY_FLUX
;;                  FLOAT     Array[269095]
;;  INTEG_ELEC_ENERGY_FLUX
;;                  FLOAT     Array[269095]
;;  EFLUX_LOSSCONE_INTEG
;;                  FLOAT     Array[269095]
;;  TOTAL_EFLUX_INTEG
;;                  FLOAT     Array[269095]
;;  MAX_CHARE_LOSSCONE
;;                  FLOAT     Array[269095]
;;  MAX_CHARE_TOTAL FLOAT     Array[269095]
;;  ION_ENERGY_FLUX FLOAT     Array[269095]
;;                  < Press Spacebar to continue, ? for help > 
;;  ION_FLUX        FLOAT     Array[269095]
;;  ION_FLUX_UP     FLOAT     Array[269095]
;;  INTEG_ION_FLUX  FLOAT     Array[269095]
;;  INTEG_ION_FLUX_UP
;;                  FLOAT     Array[269095]
;;  CHAR_ION_ENERGY FLOAT     Array[269095]
;;  WIDTH_TIME      FLOAT     Array[269095]
;;  WIDTH_X         FLOAT     Array[269095]
;;  DELTA_B         FLOAT     Array[269095]
;;  DELTA_E         FLOAT     Array[269095]
;;  SAMPLE_T        FLOAT     Array[269095]
;;  MODE            FLOAT     Array[269095]
;;  PROTON_FLUX_UP  FLOAT     Array[269095]
;;  PROTON_CHAR_ENERGY
;;                  FLOAT     Array[269095]
;;  OXY_FLUX_UP     FLOAT     Array[269095]
;;  OXY_CHAR_ENERGY FLOAT     Array[269095]
;;  HELIUM_FLUX_UP  FLOAT     Array[269095]
;;  HELIUM_CHAR_ENERGY
;;                  FLOAT     Array[269095]
;;  SC_POT          FLOAT     Array[269095]
;;  L_PROBE         FLOAT     Array[269095]
;;                  < Press Spacebar to continue, ? for help > 
;;  MAX_L_PROBE     FLOAT     Array[269095]
;;  MIN_L_PROBE     FLOAT     Array[269095]
;;  MEDIAN_L_PROBE  FLOAT     Array[269095]
;;  TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
;;                  FLOAT     Array[269095]
;;  TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT
;;                  FLOAT     Array[269095]
;;  TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;;                  FLOAT     Array[269095]
;;  TOTAL_ION_OUTFLOW_SINGLE
;;                  FLOAT     Array[269095]
;;  TOTAL_ION_OUTFLOW_MULTIPLE_TOT
;;                  FLOAT     Array[269095]
;;  TOTAL_ALFVEN_ION_OUTFLOW
;;                  FLOAT     Array[269095]
;;  TOTAL_UPWARD_ION_OUTFLOW_SINGLE
;;                  FLOAT     Array[269095]
;;  TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;;                  FLOAT     Array[269095]
;;  TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
;;                  FLOAT     Array[269095]

cghistoplot,maximus.ELEC_ENERGY_FLUX,locations=locs,omax=omax,omin=omin
print,omax
;;     113914.
print,omin
;;-6.53648e-06
print,locs
;;-6.53648e-06      15.9937      31.9875      47.9812      63.9749      79.9687
;;     95.9624      111.956      127.950      143.944      159.937      175.931
;;     191.925      207.919      223.912      239.906      255.900      271.894
;;     287.887      303.881      319.875      335.868      351.862      367.856
;;     383.850      399.843      415.837      431.831      447.825      463.818
;;     479.812      495.806      511.800      527.793      543.787      559.781
;;     575.775      591.768      607.762      623.756      639.750      655.743
;;     671.737      687.731      703.724      719.718      735.712      751.706
;;     767.699      783.693      799.687      815.681      831.674      847.668
;;     863.662      879.656      895.649      911.643      927.637      943.630
;;     959.624      975.618      991.612      1007.61      1023.60      1039.59
;;     1055.59      1071.58      1087.57      1103.57      1119.56      1135.56
;;     1151.55      1167.54      1183.54      1199.53      1215.52      1231.52
;;     1247.51      1263.51      1279.50      1295.49      1311.49      1327.48
;;     1343.47      1359.47      1375.46      1391.46      1407.45      1423.44
;;     1439.44      1455.43      1471.42      1487.42      1503.41      1519.41
;;     1535.40      1551.39      1567.39      1583.38      1599.37      1615.37
;;     1631.36      1647.35      1663.35      1679.34      1695.34      1711.33
;;     1727.32      1743.32      1759.31      1775.30      1791.30      1807.29
;;     .......................................................................
;;     113620.      113636.      113652.      113667.      113683.      113699.
;;     113715.      113731.      113747.      113763.      113779.      113795.
;;     113811.      113827.      113843.      113859.      113875.      113891.
;;     113907.
cghistoplot,maximus.ELEC_ENERGY_FLUX,locations=locs,omax=omax,omin=omin,histdata=hdata
help,hdata
;;HDATA           LONG      = Array[7123]
print,n_elements(locs)
;;       7123
for i=0,200 do print,locs(i),hdata[i]
;;-6.53648e-06      260666
;;     15.9937        4309
;;     31.9875        1229
;;     47.9812         641
;;     63.9749         345
;;     79.9687         254
;;     95.9624         164
;;     111.956         156
;;     127.950         119
;;     143.944         175
;;     159.937         139
;;     175.931         119
;;     191.925         111
;;     207.919         102
;;     223.912          93
;;     239.906          71
;;     255.900          58
;;     271.894          43
;;     287.887          39
;;     303.881          49
;;     319.875          34
;;     335.868          19
;;     351.862          19
;;     367.856          16
;;     383.850          13
;;     399.843          16
;;     415.837           8
;;     431.831          10
;;     447.825           9
;;     463.818           5
;;     479.812           6
;;     495.806           5
;;     511.800           5
;;     527.793           0
;;     543.787           3
;;     559.781           3
;;     575.775           1
;;     591.768           2
;;     607.762           2
;;     623.756           2
;;     639.750           0
;;     655.743           0
;;     671.737           0
;;     687.731           2
;;     703.724           2
;;     719.718           0
;;     735.712           1
;;     751.706           3
;;     767.699           0
;;     783.693           0
;;     799.687           0
;;     ..............
;;     3166.76           0
;;     3182.75           0
;;     3198.75           0
cghistoplot,maximus.ELEC_ENERGY_FLUX,locations=locs,omax=omax,omin=omin,histdata=hdata,maxinput=1000
print,n_elements(where(maximus.elec_energy_flux GT 1000))
;;         23
print,n_elements(maximus.elec_energy_flux)
;;     269095
