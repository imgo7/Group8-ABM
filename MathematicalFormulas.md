# Mathematical Formulas
### These formulas are used within the agent-based model, to calculate the spread of infection,effect of variables(hand hygiene and cleaning regimens) and ratio of infected to uninfected. 

### Spread of Infection - Imalia

#### ABM.nlogo (and ABM-main.html)
#### Calculating R0

Definition - R0 is the Reproduction Number of a disease. R0 is used to calculate the degree of contagiousness of an infection. R0 is used to approximate the average number of people that can catch the disease from an infected person. <br>
The R0 that we will use within the agent-based model is based upon Case Study 3.2 in the research paper: López-García, Martín  and Kypraios,Theodore 2018, 'A unified stochastic modelling framework for the spread of nosocomial infections', *Journal of the Royal Society Interface*, vol. 15, no. 143. The model explored in depth in this section is from the paper: Wang J, Wang L, Magal P, Wang Y, Zhuo J, Lu X, Ruan S. 2011, 'Modelling the transmission dynamics of meticillin-resistant Staphylococcus aureus in Beijing Tongren hospital.' *The Journal Of Hospital Infection* vol.79, issue no. 4. An additional Python code sample was provided courtesy of the paper's author, Dr. López-García.<br>
To begin with the sample Python code was run, which contains the results of 10,000 simulations to calculate R0. When run, the output delivers the approximate R0 of a Patient amongst Healthcare Workers (HCWs). I ran the code five times,added the five values and divided the total by five to provide me with an approximate R0 (*approx_r0* variable in code). This R0 occurs when the handwashing rate (*hand-hygiene-level* slider in Netlogo) is set to 24.0. The 24.0 value stands for 24 times d<sup>-1</sup> (López-García and Kypraios, 'A unified stochastic modelling framework for the spread of nosocomial infections') which is the average amount that a HCW washes their hands in this ward. The hygienic level(HCW-patient) is set at 0.46 when the hand hygiene level is 24.0, as according to Supplementary Material, López-García and Kypraios, 'A unified stochastic modelling framework for the spread of nosocomial infections', Table S2. <br>
I proceeded to vary the hygienic rate to 0.23 and hand hygiene level of 12.0, reran the sample code and recorded the resulting R0. I repeated this procedure with a hygienic rate of 0.92 and hand hygiene level of 12.0. The optimal hand hygiene level for this model is 52.0 and a hygiene rate of 1 which produces an R0 of 0.0 (based on the sample code). <br>


### Effect of Variables - Can
| Abbreviation | Description |
| :---: | :---: | 
| betaPH | Patient-HCW transmission rate |
| betaPV | Patient-Volunteer transmission rate |
| eta | HCW hand hygiene rate |
| xi | Volunteer hand hygiene rate |

| Colonization Type | Calculate Fumular |
| :---: | :---: | 
| patient by HCW | ( 1 - eta ) / total_patients * betaPH * contaminated_HCWs * ( total_patients - colonized_patients) |
| patient by Volunteer | ( 1 - xi ) /total_patients * betaPV * contaminated_Volunteers * ( total_patients - colonized_patients ) |
| HCW by Patient | ( 1 - eta ) / total_patients * betaPH * colonized_patients * ( total_HCWs - contaminated_HCWs ) |
| Volunteer by Patient | ( 1 - xi ) / total_patients * betaPV * colonized_patients * ( total_volunteers - contaminated_Volunteers ) |

### Infected to Uninfected Ratio - Kian

