### I AM RRI PROJECT: the context
[I AM RRI project](https://iamrri.eu), it is an Horizon 2020 research project carried out in the context of the EU’s _Science with and for Society_ programme (SwafS-12-2017 call), that ha the aim to investigate **Webs of Innovation Value Chains (WIVCs) in Additive Manufacturing (AM)**, to identify openings for Responsible Research & Innovation (RRI).

The project started on 1st May 2018.

### I AM RRI SKIN: the model
The aim of I AM RRI project is to develop a complex network model of AM innovation chains and their associated processes, which is directed towards RRI, at all levels.

The model developed ([I AM RRI SKIN model - v0.1](https://github.com/GradoZeroTeam/IAMRRI/blob/master/IAMRRI-ver0.1.nlogo)), coded in **NetLogo** using an **Agent-Based Modelling** (ABM) approach, originated as an extension of the already existing [SKIN model](https://cress.soc.surrey.ac.uk/skin/), and it is mainly focused on the study of IVCs, webs of IVCs and especially their openings for RRI.

The I AM RRI SKIN model incorporates complexity, covering various stages of the IVC life, mainly: idea generation and product developemnt.
The development of the innovation process goes through phases in which the _Capabilities_ (large domains of knowledge), and the _Abilities_ (applications in these domains), needed for an idea to be further developed, are not well defined. It is therefore essential the cooperation among _Agents_ and the creation of networks of IVCs. 

Moreover, unlike SKIN, from which I AM RRI SKIN derives, the innovation process develops through different _ticks_ and it is not obtained just in _one model running cycle_.
Each IVC phase modelled covers a defined number of running cycles, defined as a result of the study conducted into the I AM RRI project. 

The implemented IVC phases are, as mentioned above, mainly two:
1. Idea generation (3 _ticks_).
2. Product development (12 _ticks_).

This choice derives from the study of use-cases present into the I AM RRI project, that cover two specialisations of the AM Industry: Automotive & Biomedical.
The main time-related assumption made by the project is that 1 _tick_ equals to 1 month.
Additionally, as main difference between SKIN and I AM RRI SKIN, the decisions and the behavior of the Agents are not only price-related and cost-related, but time-related and especially RRI-related.

Each Agent is equipped with three _RRI state variables_ representing RRI inclinations that are translated into the model in the following 3 keys:
- Open Access.
- Public Engagement.
- Ethical Thinking.

These keys profoundly influence the decision-making process.

Other relatively minor extensions have been introduced to adapt the I AM RRI SKIN model to Automotive and Biomedical use-cases.
A double-industry model has been built, in which five different types of _Agents’ breeds_  - particular typologies of _AgentSet_ endowed with particular variables, interact between them also participating to more networks simultaneously.
The five types of breeds implemented are:
1. _AM-techs_
2. _Suppliers_
3. _Customers_
4. _OEMs_
5. _Research-insts_ 

Other Agents like the _Funding Organizations_ and the _Standard Organizations_ are modeled in terms of aggregated entities - in the version of the model [v0.1](https://github.com/GradoZeroTeam/IAMRRI/blob/master/IAMRRI-ver0.1.nlogo), _Funding Organizations_ and _Standard Organizations_ are modelled as environmental-global variables.

#### I AM RRI SKIN: the refined model

Some refinements have been introduced into the ([I AM RRI SKIN model - v0.2](https://github.com/GradoZeroTeam/IAMRRI/blob/master/IAMRRI-ver0.2.nlogo)) (the **last version of the model available**), in order to take into account the developments of the I AM RRI project, and also to be more stick with the richness of the conceptual model, derived from it.

The main refinements you will find in the new version ([v0.2)](https://github.com/GradoZeroTeam/IAMRRI/blob/master/IAMRRI-ver0.2.nlogo) of the model are: 
- The knowledge base of the Agents, that in this version has been updated through a long work of verification and revision made on the Agents' _kenes_ (the triples of _Capabilities_, _Abilities_ and _Expertises_).
- A new RRI key was added, Gender Equality, to the keys of the first version of the model, to work as a proxy for to support for a better definition and to reinforce the predisposition to ethical values of an Agent.
- A new breed was added for the characterisation of a new family of Agents in the model, the _NGO_ (non-governmental organization).

Other small changes were also made, which necessity emerged more  the model verification phase, such as the adjustment of the Open Access key.

### CREDITS
To cite the I AM RRI SKIN model please use the original  acknowledgement of [SKIN model](https://github.com/InnovationNetworks/skin), from which it derives, and additionally the following acknowledgement:

Cozzoni, Enrico (Grado Zero Espace S.r.l.), Ponsiglione, Cristina, Primario, Simonetta and Passavanti, Carmine and Marsiglia, Giulia (Department of Industrial Engineering, University “Federico II” of Naples).

Permission to use, modify or redistribute this model is hereby granted, provided that both of the following requirements are followed: a) the copyrights are respected; b) the model it is not redistributed for profit without permission; and c) the requirements of the [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/) are complied with.

The authors gratefully acknowledge funding from the European Commission, into the framework of [I AM RRI](https://iamrri.eu) H2020 project, GA 788361.
