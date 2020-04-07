# Mathematical Formulas
### These formulas are used within the agent-based model, to calculate the spread of infection,effect of variables(hand hygiene and cleaning regimens) and ratio of infected to uninfected. 

### Spread of Infection - Imalia

#### ABM.nlogo (and ABM-main.html)
#### Calculating R0

Definition - R0 is the Reproduction Number of a disease. R0 is used to calculate the degree of contagiousness of an infection. R0 is used to approximate the average number of people that can catch the disease from an infected person. <br>
The R0 that we will use within the agent-based model is based upon Case Study 3.2 in the research paper: López-García, Martín  and Kypraios,Theodore 2018, 'A unified stochastic modelling framework for the spread of nosocomial infections', *Journal of the Royal Society Interface*, vol. 15, no. 143, http://doi.org/10.1098/rsif.2018.0060. The model explored in depth in this section is from the paper: Wang J, Wang L, Magal P, Wang Y, Zhuo J, Lu X, Ruan S. 2011, 'Modelling the transmission dynamics of meticillin-resistant Staphylococcus aureus in Beijing Tongren hospital.' *The Journal Of Hospital Infection* vol.79, issue no. 4, doi:10.1016/j.jhin.2011.08.019 . An additional Python code sample was provided courtesy of the paper's author, Dr. López-García.<br>
To begin with the sample Python code was run, which contains the results of 10,000 simulations to calculate R0. When run, the output delivers the approximate R0 of a Patient amongst Healthcare Workers (HCWs). I ran the code five times,added the five values and divided the total by five to provide me with an approximate R0 (*approx_r0* variable in code). This R0 occurs when the handwashing rate (*hand-hygiene-level* slider in Netlogo) is set to 24.0. The 24.0 value stands for 24 times d<sup>-1</sup> (López-García and Kypraios, 'A unified stochastic modelling framework for the spread of nosocomial infections') which is the average amount that a HCW washes their hands in this ward. The hygienic level(HCW-patient) is set at 0.46 when the hand hygiene level is 24.0, as according to Supplementary Material, López-García and Kypraios, 'A unified stochastic modelling framework for the spread of nosocomial infections', Table S2. <br>
I proceeded to vary the hygienic rate to 0.23 and hand hygiene level of 12.0, reran the sample code and recorded the resulting R0. I repeated this procedure with a hygienic rate of 0.92 and hand hygiene level of 12.0. The optimal hand hygiene level for this model is 52.0 and a hygiene rate of 1 which produces an R0 of 0.0 (based on the sample code). <br>

In order to calculate the R0 so that it would change once the hand hygiene level is applied. The hand hygiene level was measured on a scale of 12 up to 52. The approximate reproduction number, *approx_r0*, for the hand hygiene level of 12 was produced as 16.7316 after running the sample code given. A hand hygiene level of 52 produced an approximate R0 of 0.0. Thus, the hand hygiene level was measured on a scale from 12 to 52. There are 40 units (or steps) between these two numbers, so to calculate the value of each step : 16.7316/40 = 0.41829. Furthermore to calculate the approximate reproduction number , taking into account the hand hygiene level, the formula is: 16.7316 – (step)(0.41829). Assume 12 as step 0 and 52 as step 40 on the hand-hygiene-level slider. The R0 decreases as the hand hygiene improves, so 16.7316 is reduced.<br>
In the method *infection-reduce-colour* the number of infected individuals is reduced as according to the article, ‘Evidence of hand hygiene to reduce transmission and infections by multidrug resistant organisms in health-care settings’, World Health Organization. The figure used in the main model is from a 2010 USA hospital study depicted in Carboneau C, Benge E, Jaco MT, Robinson M. A lean Six Sigma team increases hand hygiene compliance and reduces hospital-acquired MRSA infections by 51%. J Healthc Qual. 2010 Jul-Aug;32(4):61-70. The summarising point is that the study found that there was a 51% decrease in MRSA cases during the 12-month period when the hand hygiene level went from 65% to 82%. Our 65% hand hygiene level has a value of 38 and our 82% rate is 44.8 on the *hand-hygiene-level* slider. Consequently, set approximately 50%(rounding 51%) of colonised patients to uninfected when the hand hygiene level increases by 6.8. Following on from this assumption, increasing by 1 step results in a decrease of 7.4% of infected patients. Hence, for each step calculate the *reduceInfectionRate* (0.074\*step) to find how many people (*noLongerInfected*) have become uninfected – *noLongerInfected* = *infectedPeople* \* *reduceInfectionRate*. Also, a new infected patient (red dot) is introduced every 13 ticks as according to the supplementaryl material from López-García, Martín and Kypraios,Theodore 2018, 'A unified stochastic modelling framework for the spread of nosocomial infections',Table S2, length of stay. <br>
The cleaning regimen variable’s foundations are concluded from the paper, Dancer, S.J., White, L.F., Lamb, J. et al. Measuring the effect of enhanced cleaning in a UK hospital: a prospective cross-over study. BMC Med 7, 28 (2009). https://doi.org/10.1186/1741-7015-7-28. The paper states that an increased cleaning regimen results in a 32.5% decrease in levels of 
contamination. In this model I applied this to mean 32.5% less infected agents as a result of an ameliorated cleaning regimen, represented by the *increased-cleaning-regimen* slider. This is demonstrated in a 32.5% reduction in approx_r0. The number of infected agents is also reduced by a rate of 32.5%, so the red dots are converted to white dots, representing uninfected agents in the procedure infection-reduce-r0-cleaning-regimen.<br>





### **Mathematical Formulas &&  Usage of probability - Can**
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
