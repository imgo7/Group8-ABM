breed [HCWs HCW] ;healthcare worker
breed [volunteers volunteer] ; volunteer in ward
breed [patients patient] ;patients

HCWs-own[HCWtype] ; type of healthcare worker

turtles-own
[
  infected? ;switch - whether the turtle is infected or not
  infected-people ; number of people the turtle has infected
]

globals
[
 prev-infected ; previous tick - total number of infected people
 phi ; probability of patient being infected
 tRate ; transmission rate between patients and healthcare workers
 approx_r0 ;approximate reproduction number- patient amongst HCWs
 noOfSims ; number of simulations for reproduction number
 counter ; used in to go method
]

to setup
  clear-all ;to refresh the model every time it is run
  setup-hospital ; setup all people in hospital
  set tRate 0.72 ; transmission rate set
  set noOfSims 10000 ; number of simulations for R0
  set approx_r0 0 ; reproduction number at the start is 0
  reset-ticks ; set tick counter to 0
end

to setup-hospital
  create-HCWs 14 ; healthcare workers
  [
    setxy random-xcor random-ycor
    set infected? false ; switch to show if infected
    set shape "dot"
    set color white ; for now white can indicate an uninfected turtle
  ]

  create-patients 7
  [
    setxy random-xcor random-ycor
    set infected? false ;switch to show if infected
    set shape "dot"
    set color white ; for now white can indicate an uninfected turtle
  ]

  create-volunteers 2
  [
    setxy random-xcor random-ycor
    set infected? false ;switch to show if infected
    set shape "dot"
    set color white ; for now white can indicate an uninfected turtle
  ]
   ; infection procedure - start of infection
  ask turtle 15 ; hospital begins with 1 infected agent (turtle )
    [
      set infected? true
      assign-turtle-color ; assign each agent's colour
    ]

  ask turtle 16 ; ask turtle with turtle id 2 to be the second infected individual
    [
      set infected? true
      assign-turtle-color ; assign each agent's colour
    ]


end

to go
  ask turtles
  [
    move-hospital ; ask the turtles to move about
  ]
  ask turtles with [infected?] ;all turtles that are infected
  [
    infection-outbreak ; spread infection amongst agents
  ]
  ask turtles
  [
    assign-turtle-color ; assign infected/uninfected colour
    calc-r0 ; calculate the reproduction number
  ]

  tick ; advance tick counter by 1
  set counter counter + 1 ; increment counter

  ; our assumption every 13 ticks (1 tick = 1 day) a new colonized patient is admitted
  ; as average stay of colonized patient is 13 days - research paper
  if (ticks mod 13 = 0) ; if the number of ticks is divisible by 13- every 13 ticks
  [
    ask turtle 1 ;  1 infected patient (turtle id 1) - new colonized patient
    [
      set infected? true
      assign-turtle-color
    ]
  ]

end

; set the turtle's colour to red if infected
to assign-turtle-color
  if infected?
  [ set color red ]
end

; The turtles move about randomly
to move-hospital ; get the turtles to interact
  lt random 360; turn left randomly
  fd 5 ; move forward 5 steps
end

;method to create the spread of infection
to infection-outbreak
  ; the infection spreads amongst the agent's neighbours
  let hospital-neighbours (turtles-on neighbors4) ; selecting the turtles in the 4 surrounding patches
  with [
    not infected? ; neighbours that are not infected
  ]
  ask hospital-neighbours
  [ if random-float 1 < tRate ; chance of infection (taking into account transmission rate)
    [ set infected? true ; becomes infected
    ]
  ]
end

; infection is reduced by the hand-hygiene level and the agents are coloured accordingly
to infection-reduce-colour
  let step (hand-hygiene-level - 12); gives the exact position between 12 and 52
  let reduceInfectionRate (0.074 * step) ; for each increase the spread of infection is decreased by 7.4% for each 1 step * number of levels(hand-hygiene)
  let infectedPeople count turtles with [infected?] ; count all the agents which are infected
  let noLongerInfected (infectedPeople * reduceInfectionRate) ; number of agents that are no longer infected - due to the increased hand-hygiene level

  let counter_2 0 ; used to count number of infected people becoming uninfected

    ask turtles with [infected?] ; select all infected turtles only
  [
    if (counter_2 != noLongerInfected) ; whilst the number of uninfected patients is not equal to count
    [
      ask one-of turtles with [infected?]
      [
        set infected? false ; not infected as increased hand hygiene decreases number of infected people
        set color white ; not infected colour = white
      ]
      set counter_2 (counter_2 + 1) ; counter increases by one person each time, increment
    ]
  ]
end

; procedure to reduce the number of infected agents if increased cleaning regimen (switch is on)
; based on results from the research paper ("Measuring the effects of enhanced cleaning in a UK hospital:
; a prospective cross-over study")
to infection-reduce-r0-cleaning-regimen

  ; reduce current r0 by 32.5%
  set approx_r0 (approx_r0 * 0.675) ;reduced r0 is 67.5% of original r0 (as reduced by 32.5%)

  ;reduce number of coloured infected agents by 32.5%

  let infectedPeople count turtles with [infected?] ; count all the agents which are infected
  let noLongerInfected (infectedPeople * 0.325) ; 32.5% of agents are no longer infected due to increased cleaning regimen
  let counter_3 0 ; used to count number of infected people becoming uninfected
  ask turtles with [infected?] ; select all infected turtles only
  [
    if (counter_3 != noLongerInfected) ; whilst the number of uninfected patients is not equal to count
    [
      ask one-of turtles with [infected?] ; ask one of the infected people
      [
        set infected? false ; not infected as increased cleaning regimen reduced number of infected people
        set color white ; not infected colour = white
      ]
      set counter_3 (counter_3 + 1) ; counter increases by one person each time, increment
    ]

  ]

end

;method to calculate the reproduction number of patient among HCWs
to calc-r0
let sim_no 0 ; simulation =0 first one
  let t 0 ; time
  let finale 0 ;the end of the simulation process
  let infected_patients 0 ; at the start no one is infected
  let infected_HCWs 0

  ;this ABM has 1 infected patient and 1 infected HCW
  set infected_patients 1
  set infected_HCWs 1

  ;After running the Section 3-Case Study 2 (Wang et al. model) simulation code to find the mean reproduction number
  ;- the code wasprovided by the research paper's author
  ;24.0 hand-washing rate
  if(hand-hygiene-level = 24.0)
  [
  let run_0 12.216399999999998
  let run_1 11.805700000000003
  let run_2 11.945299999999998
  let run_3 12.145800000000003
  let run_4  12.105900000000009

; the approximate r0 is 12 - from Case Study 3 of the research paper
  set approx_r0 ((run_0 + run_1 + run_2 + run_3 + run_4) / 5) ; approximate r0
  ]
  output-print approx_r0 ; print r0 to console
   if(hand-hygiene-level = 12.0)
  [
  set approx_r0 ( 16.731599999999982) ;HCW hygiene rate 0.23
  ]
  if(hand-hygiene-level = 52.0)
  [
  set approx_r0 0.0 ; perfect hand hygiene level
  ]
  if(hand-hygiene-level = 48.0)
  [
  set approx_r0 1.7695999999999972 ; HCW hygiene rate = 0.92
  ]

  let step (hand-hygiene-level - 12); gives the exact position between 12 and 52
  set approx_r0 (16.7316 - (step * 0.41829)) ; approximated from reproduction number and
                                             ; number of times washed hands per day

  ; Now to colour the agents when the hand-hygiene-level increases
  infection-reduce-colour

  ;if cleaning regimen is switched on there is a 32.5% reduction in the spread of infection
  ; based on results from the research paper ("Measuring the effects of enhanced cleaning in a UK hospital:
  ; a prospective cross-over study")
  ; reduction in number of agents infected and reduced R0

  ; only call the following method if the switch is on - increased cleaning regimen
   ifelse increased-cleaning-regimen? ; checks value of switch
  [
  ;show "switch is on" ; to test that user pressed switch
  infection-reduce-r0-cleaning-regimen ; if true- switched on
  ]
  [
     ; if switched nothing changes
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
297
10
734
448
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
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
18
19
81
52
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

BUTTON
111
20
174
53
go
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

SLIDER
10
63
182
96
hand-hygiene-level
hand-hygiene-level
12
52
38.0
1
1
NIL
HORIZONTAL

PLOT
5
144
252
362
Rate of spread due to patient
NIL
Rate of spread
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot approx_r0"

TEXTBOX
6
391
156
433
Legend:\n\twhite - uninfected\n\tred   - infected
11
0.0
1

OUTPUT
5
361
170
388
11

SWITCH
9
106
221
139
increased-cleaning-regimen?
increased-cleaning-regimen?
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

The agent-based model shows the spread of infection in a hospital ward that consists of 23 people; 14 Healthcare Workers (HCWs), 7 patients and 2 Volunteers, the figures based upon the paper: Case Study 3.2 in the research paper: López-García, Martín and Kypraios,Theodore 2018, 'A unified stochastic modelling framework for the spread of nosocomial infections', Journal of the Royal Society Interface, vol. 15, no. 143, http://doi.org/10.1098/rsif.2018.0060. The model explored in depth in this section is from the paper: Wang J, Wang L, Magal P, Wang Y, Zhuo J, Lu X, Ruan S. 2011, 'Modelling the transmission dynamics of meticillin-resistant Staphylococcus aureus in Beijing Tongren hospital.' The Journal Of Hospital Infection vol.79, issue no. 4 (doi:10.1016/j.jhin.2011.08.019). The reproduction number used for the model is the patient among HCWs . A further Python code sample was provided courtesy of the paper's author, Dr. López-García. 

## HOW IT WORKS

The approximate reproduction number of a patient among HCWs is calculated, to demonstrate the spread of infection within the hospital ward. To begin with the sample code was run to calculate an estimated R0. When run, the output delivers the approximate R0 of a Patient amongst Healthcare Workers (HCWs). The output was recorded five times,was added and then divided by five to provide an approximate R0. This R0 occurs when the handwashing rate (hand-hygiene-level slider in Netlogo) is set to 24.0.<br> 

In order to calculate the R0 so that it would change once the hand hygiene level is applied. The hand hygiene level was measured on a scale of 12 to 52. The approximate reproduction number, approx_r0.In order to calculate the approximate reproduction number , taking into account the hand hygiene level, the formula is: 16.7316 – (step)(0.41829).<br>

The cleaning regimen variable’s foundations are concluded from the paper, Dancer, S.J., White, L.F., Lamb, J. et al. Measuring the effect of enhanced cleaning in a UK hospital: a prospective cross-over study. BMC Med 7, 28 (2009). https://doi.org/10.1186/1741-7015-7-28. The paper states that an improved cleaning regimen results in a 32.5% decrease in levels of 
contamination. In this model I applied this to mean 32.5% less infected agents as a result of an increased cleaning regimen.<br>

For additional information about the mathematical formulas behind the main model, consult our GitHub Repository, and read MathematicalFormulas.md for a detailed explanation behind the formulas applied in the main model.





## HOW TO USE IT
To use to model: <br>
1.	Click the setup button and all the people will be set up, with the white agents marked as uninfected and red agents as infected (as according to the legend).<br>
2.	Click on the go button to run the model.<br>
3.	Increase or decrease the level of hand hygiene present in the hospital ward by augmenting the slider named “hand-hygiene-level”.<br>
4.	Switch on the switch called “increased-cleaning-regimen’ to view what an amelioration of the level of cleaning present in the hospital ward does to the spread of infection. <br>
5.	The graph displays how the reproduction number is impacted by the hand hygiene level and cleaning regimen. The reproduction number is also displayed underneath the graph so the user is able to view the approximate reproduction number produced as a result.<br>


## THINGS TO NOTICE

Notice how the handwash rate affects the spread of the infection in a simple simulation of a hospital.

Notice that the exact rate of spread caused by the patients to HCWs is shown below the graph.

Notice that if you change the hand hygiene level, the agents become uninfected and another simulation begins of a hospital being infected.

Notice that with a very low hand hygiene level, an outbreak occurs far more often.

## THINGS TO TRY

Try changing the handwash rate.

See what the effect of increasing the cleaning regimen is on the spread.

## EXTENDING THE MODEL

## NETLOGO FEATURES

Proximity of turtles to each other influences the simulation

## RELATED MODELS


## CREDITS AND REFERENCES

Martín López-García andTheodore Kypraios.2018 A unified stochastic modelling framework for the spread of nosocomial infectionsJ. R. Soc. Interface.1520180060. http://doi.org/10.1098/rsif.2018.0060 <br

Wang J, Wang L, Magal P, Wang Y, Zhuo J, Lu X, Ruan S. 2011Modelling the transmission dynamics of meticillin-resistant Staphylococcus aureus in Beijing Tongren hospital. J. Hosp. Infect. 79, 302–308. (doi:10.1016/j.jhin.2011.08.019) Crossref, PubMed, Google Scholar<br>

Dancer, S.J., White, L.F., Lamb, J. et al. Measuring the effect of enhanced cleaning in a UK hospital: a prospective cross-over study. BMC Med 7, 28 (2009). https://doi.org/10.1186/1741-7015-7-28<br>


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
