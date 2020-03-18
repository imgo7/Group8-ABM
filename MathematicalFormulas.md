# Mathematical Formulas
### These formulas are used within the agent-based model, to calculate the spread of infection,effect of variables(hand hygiene and cleaning regimens) and ratio of infected to uninfected. 

### Spread of Infection - Imalia

R0 is the Reproduction Number of a disease. R0 is used to calculate the degree of contagiousness of an infection. R0 is used to approximate the average number of people that can catch the disease from an infected person. The R0 that we will use within the agent-based model is based upon Case Study 3.2 in the research paper: López-García, Martín  and Kypraios,Theodore 2018, 'A unified stochastic modelling framework for the spread of nosocomial infections', *Journal of the Royal Society Interface*, vol. 15, no. 143. The model explored in depth in this section is from the paper: Wang J, Wang L, Magal P, Wang Y, Zhuo J, Lu X, Ruan S. 2011, 'Modelling the transmission dynamics of meticillin-resistant Staphylococcus aureus in Beijing Tongren hospital.' *The Journal Of Hospital Infection* vol.79, issue no. 4. An additional Python code sample was provided courtesy of the paper's author, Dr. López-García.

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

