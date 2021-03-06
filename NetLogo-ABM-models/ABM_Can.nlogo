globals
[
  ;; totoal number of infected people
  num-sick
  num-sick-patients
  num-sick-HCWs
  num-sick-volunteers
  ;; counter used to keep the model running for a little while after the last turtle gets infected
  delay
  ;;
  infection-chance-HCW-from-Patient
  infection-chance-volunteers-from-Patient
  infection-chance-HCW-to-Patient
  infection-chance-volunteers-to-Patient
  ;;Patient-HCW transmission rate
  betaPH
  ;;Patient-Volunteer transmission rate
  betaPV
  ;;
  total

]

breed [patients patient]
breed [HCWs HCW]
breed [volunteers volunteer]

turtles-own
[
  infected?
]

;; set up
to setup
  clear-all
  ask patches [ set pcolor gray ]

  ;;
  setup-hospital
  set betaPH 0.72
  set betaPV 0.20
end

to setup-hospital
  set-default-shape patients "person"
  set-default-shape HCWs "person"
  set-default-shape volunteers "person"
  set num-sick 0
  set total initial-patient + initial-HCW + initial-volunteer
  create-some-patients
  create-some-HCWs
  create-some-Volunteers
  ask one-of patients [ get-sick ]
  reset-ticks
end

to create-some-patients
  create-Patients initial-patient
  [
    setxy random-pxcor random-pycor
    set color yellow
    set heading 90 * random 4
    set infected? false
  ]
end

to create-some-HCWs
  create-HCWs initial-HCW
  [
    setxy random-pxcor random-pycor
    set color blue
    set heading 90 * random 4
    set infected? false
  ]
end

to create-some-Volunteers
  create-Volunteers initial-volunteer
  [
    setxy random-pxcor random-pycor
    set color green
    set heading 90 * random 4
    set infected? false
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;
;; Runtime Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;

to go
  if ticks = 100 [ stop ]
  if count turtles with [ infected? ] = 0 [ask one-of patients [ get-sick ]]
  Move
  spread-disease
  discharge-colonized-patients
  tick
end

to Move
  ask HCWs [setxy random-pxcor random-pycor]
  ask volunteers [setxy random-pxcor random-pycor]
  wait 0.3
end

to spread-disease
  spread-disease-patients-to-HCWs
  spread-disease-patients-to-volunteers
  spread-disease-patients-from-HCWs
  spread-disease-patients-from-volunteers
  set num-sick count turtles with [ infected? ]
end

to discharge-colonized-patients
  ask patients with [infected?]
    [
      if random-float 1 < 0.077 ;; 1/13
      [ discharge ]
    ]
end

to spread-disease-patients-to-HCWs
  set num-sick-patients count patients with [ infected? ]
  set num-sick-HCWs count HCWs with [ infected? ]
  set infection-chance-HCW-from-Patient ((1 - HCW-hand-hygiene-rate) / initial-patient * betaPH * num-sick-patients * (initial-HCW - num-sick-HCWs))
  if infection-chance-HCW-from-Patient > 10
    [set infection-chance-HCW-from-Patient infection-chance-HCW-from-Patient / 100]
  if infection-chance-HCW-from-Patient > 1
    [set infection-chance-HCW-from-Patient infection-chance-HCW-from-Patient / 10]
  ask patients with [infected?]
    [ ask HCWs in-radius 2
      [
        if (not infected?) and (random-float 1 < infection-chance-HCW-from-Patient)
        [ get-sick ]
      ]
    ]
end

to spread-disease-patients-to-volunteers
  set num-sick-patients count patients with [ infected? ]
  set num-sick-volunteers count volunteers with [ infected? ]
  set infection-chance-volunteers-from-Patient ((1 - Volunteer-hand-hygiene-rate) / initial-patient * betaPV * num-sick-patients * (initial-volunteer - num-sick-volunteers))
  if infection-chance-volunteers-from-Patient > 10
    [set infection-chance-volunteers-from-Patient infection-chance-volunteers-from-Patient / 100]
  if infection-chance-volunteers-from-Patient > 1
    [set infection-chance-volunteers-from-Patient infection-chance-volunteers-from-Patient / 10]
  ask patients with [infected?]
    [ ask volunteers in-radius 2
      [
        if (not infected?) and (random-float 1 < infection-chance-volunteers-from-Patient)
        [ get-sick ]
      ]
    ]
end

to spread-disease-patients-from-HCWs
  set num-sick-patients count patients with [ infected? ]
  set num-sick-HCWs count HCWs with [ infected? ]
  set infection-chance-HCW-to-Patient ((1 - HCW-hand-hygiene-rate) / initial-patient * betaPH * num-sick-HCWs * (initial-patient - num-sick-patients))
  if infection-chance-HCW-to-Patient > 10
    [set infection-chance-HCW-to-Patient infection-chance-HCW-to-Patient / 100]
  if infection-chance-HCW-to-Patient > 1
    [set infection-chance-HCW-to-Patient infection-chance-HCW-to-Patient / 10]
  ask HCWs with [infected?]
    [ ask patients in-radius 2
      [
        if (not infected?) and (random-float 1 < infection-chance-HCW-to-Patient)
        [ get-sick ]
      ]
    ]
end

to spread-disease-patients-from-volunteers
  set num-sick-patients count patients with [ infected? ]
  set num-sick-volunteers count volunteers with [ infected? ]
  set infection-chance-volunteers-to-Patient ((1 - Volunteer-hand-hygiene-rate) / initial-patient * betaPV * num-sick-volunteers * (initial-patient - num-sick-patients))
  if infection-chance-volunteers-to-Patient > 10
    [set infection-chance-volunteers-to-Patient infection-chance-volunteers-to-Patient / 100]
  if infection-chance-volunteers-to-Patient > 1
    [set infection-chance-volunteers-to-Patient infection-chance-volunteers-to-Patient / 10]
  ask volunteers with [infected?]
    [ ask patients in-radius 2
      [
        if (not infected?) and (random-float 1 < infection-chance-volunteers-to-Patient)
        [ get-sick ]
      ]
    ]
end


;;;;;;;;;;;;;;;;;;;;;;;
;; Help Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; set the appropriate variables to make this turtle sick
to get-sick ;; turtle procedure
  if not infected? [
    set infected? true
    set shape word shape " sick"
  ]
end

to discharge
  if infected? [
    set infected? false
    set shape "person"
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
348
45
889
587
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
0
0
1
ticks
30.0

BUTTON
0
10
242
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
322
243
355
Volunteer-hand-hygiene-rate
Volunteer-hand-hygiene-rate
0
1
0.24
0.01
1
NIL
HORIZONTAL

TEXTBOX
0
438
332
483
Discharge rate of colonized patients:\ndeltaC=1.0/13.0
15
0.0
1

TEXTBOX
0
560
255
607
Patient-HCW transmission rate:\nbetaPH = 0.72
15
0.0
1

TEXTBOX
0
500
301
543
Patient-Volunteer transmission rate:\nbetaPV = 0.20
15
0.0
1

TEXTBOX
0
376
150
432
Keys:
20
0.0
1

SLIDER
0
118
242
151
initial-patient
initial-patient
0
100
77.0
1
1
NIL
HORIZONTAL

SLIDER
0
161
242
194
initial-HCW
initial-HCW
0
100
86.0
1
1
NIL
HORIZONTAL

SLIDER
0
205
241
238
initial-volunteer
initial-volunteer
0
50
6.0
1
1
NIL
HORIZONTAL

BUTTON
0
52
243
85
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
956
177
1377
585
Number Sick
Day
Number of Sick People
0.0
100.0
0.0
200.0
false
true
"set-plot-y-range 0 total" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot num-sick"
"Patients" 1.0 0 -1184463 true "" "plot num-sick-patients"
"HCWs" 1.0 0 -13345367 true "" "plot num-sick-HCWs"
"Volunteer" 1.0 0 -13840069 true "" "plot num-sick-Volunteers"

SLIDER
0
279
243
312
HCW-hand-hygiene-rate
HCW-hand-hygiene-rate
0
1
0.24
0.01
1
NIL
HORIZONTAL

TEXTBOX
960
15
1112
59
Legend:
20
0.0
1

TEXTBOX
957
76
1221
164
Yellow -- Patients\nBlue -- HCWs\nGreen -- Volunteers\nWith Red Circle -- Infected
15
0.0
1

@#$#@#$#@
## WHAT IS IT?

This model simulates the spread of the virus in the hospital through a small isolated population.

Users can change different characters' hand hygiene levels and should see the distinct disparity of infected number between HCWs who have high hand hygiene level and low hand hygiene level.

There has a realtime linear chart to show the number of sick people in each character and total population.

There are three characters patient, healthcare worker and volunteers. Each of them can transmit the virus to others with specific probability based on characters.
The probability of transmission is most related to hand hygiene level and patients have a small chance to recover.

All the mathematic models and formulas are from reference paper one section 3.2 and the Python source code from reference paper two which is on the below.



## HOW IT WORKS

Abbreviation 	Description

betaPH 	        Patient-HCW transmission rate

betaPV 	        Patient-Volunteer transmission rate

eta 	        HCW hand hygiene rate

xi 	        Volunteer hand hygiene rate



Colonization Type 	Calculate Fumular

patient by HCW 	        ( 1 - eta ) / total_patients * betaPH * contaminated_HCWs * (                              total_patients - colonized_patients)

patient by Volunteer 	( 1 - xi ) /total_patients * betaPV * contaminated_Volunteers * (                          total_patients - colonized_patients )

HCW by Patient 	        ( 1 - eta ) / total_patients * betaPH * colonized_patients * (
                         total_HCWs - contaminated_HCWs )

Volunteer by Patient 	( 1 - xi ) / total_patients * betaPV * colonized_patients * (                              total_volunteers - contaminated_Volunteers )


## HOW TO USE IT


The hand hygiene slider allows the user to control the quality of the hand cleaning regimen that is in place within the hospital, where 100% means that it kills all virous on the hands, and 0% means that it kills none of the virous.

The model speed slider allows the user to speed up or slow down how often the simulation changes states.

Once the user has set the variables, they click on setup to generate the starting state of the simulation and click go to start simulation.


To use to model: 
0. Settle the number of patients, HCWs and volunteers.
1. Click the setup button and all the people will be set up
2. Click on the go button to run the model. 
3. Increase or decrease the level of hand hygiene present for HCWs and volunteers in the hospital ward  
5. The graph displays the number of sick people in each character and total population.

## THINGS TO NOTICE

Notice how the handwash rate affects the spread of the infection in a simple simulation of a hospital.

The hand hygiene slider allows the user to control the quality of the hand cleaning regimen that is in place within the hospital, where 100% means that it kills all virous on the hands, and 0% means that it kills none of the virous.low hand hygiene level, an outbreak occurs far more often.

## THINGS TO TRY

Try changing the handwash rate.
See what the effect of increasing the cleaning regimen is on the spread.

## EXTENDING THE MODEL
## NETLOGO FEATURES
## RELATED MODELS
## CREDITS AND REFERENCES

1. Martín López-García andTheodore Kypraios.2018 A unified stochastic modelling framework for the spread of nosocomial infectionsJ. R. Soc. Interface.1520180060. http://doi.org/10.1098/rsif.2018.0060
2. Wang J, Wang L, Magal P, Wang Y, Zhuo J, Lu X, Ruan S. 2011Modelling the transmission dynamics of meticillin-resistant Staphylococcus aureus in Beijing Tongren hospital. J. Hosp. Infect. 79, 302–308. (doi:10.1016/j.jhin.2011.08.019) Crossref, PubMed, Google Scholar
3. Dancer, S.J., White, L.F., Lamb, J. et al. Measuring the effect of enhanced cleaning in a UK hospital: a prospective cross-over study. BMC Med 7, 28 (2009). https://doi.org/10.1186/1741-7015-7-28
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person sick
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Circle -2674135 true false 178 163 95

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
