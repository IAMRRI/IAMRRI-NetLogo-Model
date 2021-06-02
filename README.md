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
Additionally, as main difference between SKIN and I AM RRI SKIN, the decisions and the behavior of the agents are not only price-related and cost-related, but time-related and especially RRI-related.

Each agent is equipped with three _RRI state variables_ representing RRI inclinations that are translated into the model in the following 3 keys:
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

Other agents like the _Funding Organizations_ and the _Standard Organizations_ are modeled in terms of aggregated entities - in the current version of the model ([v0.1](https://github.com/GradoZeroTeam/IAMRRI/blob/master/IAMRRI-ver0.1.nlogo)), _Funding Organizations_ and _Standard Organizations_ are modelled as environmental-global variables.
