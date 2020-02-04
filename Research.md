# Research

This project uses the following research article as a reference :
López-García, Martín  and Kypraios,Theodore 2018, 'A unified stochastic modelling framework for the spread of nosocomial infections', *Journal of the Royal Society Interface*, vol. 15, no. 143.
We have summarised the paper's findings in our own words. 

## Abstract - Can
**This paper illustrates:**
- a highly versatile stochastic modelling framework that can account for [these factors](#factors).
- allows one to exactly analyse the reproduction number of eachagent at the hospital ward during a nosocomial outbreak.
- having case studies to show this unified modelling framework.
- the results show [these points](#show).
## Section 1 - Can
**Introduction:**
- worldwide **problem**:
    1. getting infections at the hospital.
    2. pathogens --> antibiotic resistance appearing and spreading.
- Easy to spread multidrug-resistant bacteria (MDRB) in **healthcare environments**.
- **Mode** of transmission (uncertain but usually):
    1. exogenous
    2. endogenous
- **Transmission** occur:
    1. HCW–patient
    2. environmental contamination
    3. airborne spread
- Infection **control strategies** in hospital:
    1. hand disinfection procedures
    2. environmental  cleaning
    3. active  screening  for colonization among patients
    4. isolation of colonized individuals
    5. managing staffing levels
    6. antibiotic prescription 
    7. decolonization procedures
    8. patient cohorting
- Using **agent-based models** in this paper:  
  agent-based models -- where one keeps track of the state ofeach individual within the population throughout time, allowing one to model heterogeneities at the individual level.
- The **factors** <a name="factors"></a> have been considered in these stochastic models:  
    1. spontaneous colonization of patients
    2. patient-to-staff and staff-to-patient contamination/colonization
    3. environmental contamination
    4. patient cohorting
    5. room configuration of thehospital ward
    6. staff hand-washing compliance level
    7. the presence of different types of HCWs or specific staff–patient contact network structures
- This paper **results show**: <a name="show"></a>
    1. highlight the importance of maintaining high hand-hygiene compliance levelsby HCWs
    2. support control strategies including to improve environmental cleaning during nosocomial outbreaks
    3. show the potential of some healthcare workers to act as super-spreaders during these outbreaks
    
## Section 2 - Imalia
The structure suggested by the author to build the agent-based model is directly outlined within this section.  The authors propose a model whereby the agents existing in the model can be classed under different types such as patients, healthcare workers (HCWs), surfaces and patients situated in alternative rooms. The basis of the proposed model is built on the concept of a continuous-time Markov chain. The reason for this selection is clarified by the authors who expand the logic behind their choice by stating that the Markov chain facilitates the necessary accuracy needed to calculate the reproduction number of the various agents. This leads to a method of measuring the number of infections that are introduced by the agent. The model also measures the degree of infectiousness of an individual agents when interacting with different individuals. 
### Section 2.1 - Imalia
The process of infection takes into account the equation: X = {X(t)  = (I<sub>1</sub>(t),I<sub>2</sub>(t), …, I<sub>k</sub>(t))} where t ≥ 0 and I<sub>N</sub>(t) relates the number of Infectives at a certain level N at time t. The level is defined by the case study in question. The number of likely cases S<sub>N</sub>(t) is given by the equation L<sub>N</sub>-I<sub>N</sub>(t) for t≥0. An additional equation is found to define the states present. The states (i<sub>1</sub>,…, i<sub>k</sub>) refer to the number of contaminated individuals i<sub>N</sub> at the levels 1 ≤ N ≤ k. The final state F indicates the end of the transition of states. 
<br><br>Removal occurs at level N:  (i<sub>1</sub>,…,i<sub>k</sub> )→(i<sub>1</sub>,…,i<sub>N</sub>-1,…,i<sub>k</sub>) at rate α<sub>N</sub>(i<sub>1</sub>,…,i<sub>k</sub>)
<br><br>
Infection occurs at level N:  (i<sub>1</sub>,…,i<sub>k</sub> )→(i<sub>1</sub>,…,i<sub>N</sub>-1,…,ik) at rate β<sub>N</sub>(i<sub>1</sub>,…,i<sub>k</sub>)
<br><br>
Detection of the infection outbreak (i<sub>1</sub>,…,i<sub>k</sub> )→F at rate γ(i<sub>1</sub>,…,i<sub>k</sub>)
<br><br>
Every factor depends on the individual case study in question. The γ rate enables the discovery of where the pathogen is introduced.
The exact reproduction number refers to the number of infections that have been instigated by the individual until the person is removed or the outbreak has been detected successfully. This can be summed up by: R<sub>(i1,…,ik)</sub><sup>(N)</sup> = ∑<sub>(a=1)</sub><sup>k</sup> R<sub>(i1,…,ik)</sub>(N)<sup>(a)</sup>. R is the number of infections caused by the individual at a level N. This value is a global variable.

### Section 2.2 - Imalia
 R<sub>(i1,…,ik)</sub><sup>(N)</sup> In the initial starting state the value R’s states encompass the basic reproduction number to produce the mean value. In this initial state R results in being R<sub>(0,..,0,1,…,0)</sub><sup>(N)</sup>. Infection and removal rates are calculated using the R<sub>(i1,…,ik)</sub><sup>(N)</sup> and R<sub>(i1,…,ik)</sub><sup>(N)</sup>(a) values. Every infected person at level N is removed at rate αN and every individual can be infected externally or by another individual with rate βN. Probabilities can be computed using the equation v<sub>(i1,…,ik)</sub><sup>(N)</sup>(q) = P(R<sub>(i1,…,ik)</sub><sup>(N)</sup>=q), q≥0.
The Markov chain consists of a system that is able to transition from state to state, whilst obeying rules relating to probability. The subsequent states are determined on the current state and time passed.

## Section 3 - Ben
### Section 3.1 - Ben
This model focuses on a hospital with Np patients and Nhcw healthcare workers. Patients can be colonized or uncolonized and are discharged at rate μ. New patients take their place as soon as they leave and the new patients have chance σ of being infected. HCWs wash their hands at rate μ' Colonized patients contaminate the hands of hcws at rate β′, whilst contaminated hands of hcws contaminate patients at rate β. It is assumed in [21] that each colonized patient is detected at rate γ, which can be incorporated here by setting δ(i1, i2) = γi1 (i.e. outbreak declaration occurs upon detection of the first colonized patient). This case sets m to 2 for simplicity sake. The diagrams in the paper perfectly explain everything past this
### Section 3.2 - Akinfolarin
### Section 3.3 - Akinfolarin
### Section 3.4 - Kian
### Section 3.5 - Kian
## Section 4 - Eoin
The model used within the case study allows for the user to analyse the spread while being able to consider different hypotheses regarding the spread of a hospital-born disease or infection and to consider the different variables that could be important factors of the spread of nosocomial diseases, i.e hand hygiene routines in the hospital, environmental cleaning, etc. The methodology in the framework should allow for the user to see the infectiousness of the nosocomial disease to different groups of people: patiens, health care workers, so that the spread of the disease can be assessed by who is most likely to be the cause of further spreading.

Several assumptions will be made throughout the project, most notably that a constant number of agents (patients, HCWs, surfaces) will be in the hospital at a given time. The events of the spread are assumed to be Markovian ( the probability of an event occurring is affected by another event preceding it)

## Data accessibility and Authors' contributions - Eoin
All python code is available within the paper
