;IAMRRI
;=====
;WEBS OF INNOVATION AND VALUE CHAINS OF ADDITIVE MANUFACTURING UNDER CONSIDERATION OF RRI
;
extensions [nw]
;;globals preceded by ';' below are set by sliders, not by code
globals [
  ; nAM-tech                     ; the number of AM-tech companies initially
  ; nSupplier                    ; the number of Suppliers initially
  ; nResearch-inst               ; the number of Research institutions initially
  ; nOEM                         ; the number of OEMs initially
  ; nCustomer                    ; the number of Customers initially
  ; big-firm-percent             ;number of firms with 10 times initial capital of rest
  ; attractiveness-threshold     ; how attractive a firm must be before it becomes a partner
  ; regulator                    ; requirements of regulators (depends on ethical thinking)
  ; standard-organization        ; requirements of standard organization (depends on idea quality)
  ; funding                      ; funding for deserving network
  ; funding-quality              ; quality required to receive funding
  ; funding-RRI                  ; RRI threshold required to receive funding
  ; RRI-start-up-trigger         ; RRI value threshold that triggers start up
  ; RRI-cost                     ; cost to support ethical values
  ; economic-threshold           ; economic threshold to be exceeded in order to publish open access
  ; RRI-open-access-trhesholds   ; RRI open access value threshold to be exceeded in order to publish open access
  ;modified by the turtles during simulation
  ;big-ngo-percent
  ;nNGO
  total-funding-amount           ; how many funds are available at the start of the simulation
  initial-capital                ; the capital that a firm starts with (except research-inst)
  initial-capital-for-big-firms  ; the amount of start-up capital for those firms set to be 'big'
  max-ih-length                  ; maximum length of an innovation hypothesis
  incr-research-tax              ; tax paid for one step of incremental research
  radical-research-tax           ; tax paid for one step of radical research
  refining-IH-cost               ; tax paid for every partnership per step
  min-partners                   ; minimum number of partners
  net-phase-1                    ; networks who have worked in the idea generation phase
  net-phase-2                    ; networks who have worked in the product development phase
  net-phase-3                    ; networks who have worked in the market diffusion phase
  net-gate-phase-2                ; networks trying to get into product development
  net-gate-phase-3                ; networks trying to get into "market diffusion"
  %survived-1                     ;Percentage of survived firms in idea generation
  %survived-2                     ;Percentage of survived firms in product developmet
]

breed [AM-techs AM-tech]
breed [Suppliers Supplier]
breed [OEMs OEM]
breed [Customers Customer]
breed [Research-insts Research-inst]
breed [Networks Network]
breed [NGOs NGO]

turtles-own [
  ;RRI values
  open-access
  public-engagement
  ethical-thinking
  gender-equality ; ethical-thinking's proxy

 ;ngos
  attendance

  RRI-value

  ;network
  max-partners                   ; maximum number of partners (depends on capital)
  max-project                    ; maximum number of projects in which an agent can participate (depends on capital)
  max-partners-same-breed        ; maximun number of oartners of the same breed
  partners
  previous-partners
  ;kene
  ih
  advert                          ; C in my ih
  capabilities                    ; the Firms kene part 1
  abilities                       ; the Firms kene part 2
  expertises                      ; the Firms kene part 3
  cap-capacity                    ; max capabilities' number in kene
  max-veiled                      ; maximum number of veiled capabilities

  ;breed
  capital                         ; the amount of capital of the firm (except network research-inst)
  industry                        ; industry in which agent works (except research-inst) [0 1 2] for AM-tech, Suppliers
  start-project?                  ; probability to be the initiator of a project, to be "focal" (except network)
  open-access-publications        ; number of open access publications
  state
]

Networks-own [
  RRI-net
  net-partners                    ; list including the parteners' ID
  who-net-partners
  net-dimension                   ; number of partners in the network
  focal                           ; the network's agent creator (start-project)
  invested-capital                ; sum of the capitals invested in the project by the partners
  phase                           ; phase of the evolution in which the network is working.
  quality                         ; quality of network's product

]

Suppliers-own [
  type-of-supplier                ; [0 1 2] typology of supplier
]

Research-insts-own [
  research-field                  ; [0 1 2] typology of research fields
  dimension                       ; could be assimilated to the “initial-capital” of industrial agents
]


to setup
  __clear-all-and-reset-ticks
  ;globals
  set max-ih-length 12
  set incr-research-tax 10
  set radical-research-tax 10
  set refining-IH-cost 5
  set min-partners 3
  set total-funding-amount 10000



  ;creation and setup agentset
  initialise-AM-techs
  ask AM-techs [ setup-AM-tech]
  initialise-Suppliers
  ask Suppliers [setup-Supplier]
  initialise-Customers
  ask Customers [setup-customer]
  initialise-OEMS
  ask OEMs [setup-OEM]
  initialise-NGOs
  ask NGOs [setup-NGO]
  initialise-Research-insts
  ask Research-insts [setup-research-inst]
  ask turtles with [start-project?][set state 0 ]
  reset-ticks
end


to initialise-NGOs
  create-NGOs nNGO[
    set shape "triangle 2"
    set size 3
    set color white
    setxy random-xcor random-ycor
    set initial-capital 100
    set capital initial-capital
    set industry random 2 + 1
    set ih []
   set max-veiled 1
   set start-project? false
   set partners no-turtles
   set max-partners 5
    set capabilities []
    set abilities []
    set expertises []
    set attendance random-normal ngo-attendance 0.1
   set open-access random-float 1
   set public-engagement random-float 1
   set gender-equality random-float 1
   set ethical-thinking gender-equality + 0.1    ;
   if ethical-thinking > 1 [ set ethical-thinking 1]  ;
   set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
   set open-access-publications 0
  ]

 ask n-of round  ((big-ngo-percent / 100) * nNGO) NGOs [
   set capital initial-capital * 4
    set max-partners 15 ]
  let n_start_project random nNGO
  ask n-of n_start_project NGOs [
    set start-project? true ]
end

to setup-NGO
  make-kene-NGO
  make-innovation-hypothesis
  make-advert
end

to make-kene-NGO
  set cap-capacity random  6 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]
  set capabilities n-of cap-capacity [2 4 11 12 18 17]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
    if i = 2 [ set abilities lput one-of [9 37] abilities]
    if i = 4  [ set abilities lput one-of [56 72] abilities]
    if i = 11 [ set abilities lput one-of [42 43 44 67] abilities]
    if i = 12 [ set abilities lput one-of [48 49 73 74 75] abilities]
    if i = 18 [ set abilities lput one-of [68 69] abilities]
    if i = 17 [ set abilities lput one-of [70 71] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput (random 10 + 1) expertises]
end


to initialise-AM-techs
  create-AM-techs nAM-tech [
    set shape "gear"
    set size 3
    setxy random-xcor random-ycor
    set initial-capital  100
    set capital initial-capital
    set industry random 3                 ;assigne to each of them as automotive, biomedical, or broker
    set ih []
    set max-veiled 1
    set start-project? false
    set partners no-turtles
    set previous-partners no-turtles
    set max-partners 5
    set capabilities []                   ; create a null kene
    set abilities []
    set expertises []
    set open-access random-float 1        ; set randomly in the absence of empirical data
    set public-engagement random-float 1
    set gender-equality random-float 1
    set ethical-thinking gender-equality + 0.1    ;   ethical-thinking è legato a gender equality dall'inizio, ma poiché non dipende solo da gender ha una quota in più
    if ethical-thinking > 1 [ set ethical-thinking 1]  ; non può essere più di 1
    set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
    set open-access-publications 0        ; number of open access publications
  ]
  ;  make some of them large firms, with extra initial capital and extra max-partners
  ask n-of round ((big-firm-percent / 100) * nAM-tech) AM-techs [
    set capital initial-capital * 10
    set max-partners 15 ]
  let n_start_project random nAM-tech
  ask n-of n_start_project AM-techs [     ;randomly selects the start-project
    set start-project? true ]

end

to setup-AM-tech
  make-kene-AM-tech
  make-innovation-hypothesis
  make-advert
end

;firm AM-tech procedure  4 capabilities; 15 abilities
to make-kene-AM-tech
  if industry = 1 [
  ;capability capacity randomly chosen, but cannot be less than 2.
  set cap-capacity random 10 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 4, such that no number is repeated
  set capabilities n-of cap-capacity [1 2 3 4 7 10 11 12 13 16]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
    if i = 1 [ set abilities lput one-of [1 2 3 4 5 6 7 8 36] abilities]
    if i = 2 [ set abilities lput one-of [9 57] abilities]
    if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
    if i = 4 [ set abilities lput one-of [11 12 13 14 15 19 56 61] abilities]
    if i = 7 [ set abilities lput one-of (range 38 41) abilities]
    if i = 10 [ set abilities lput one-of [33 34 35 41] abilities]
    if i = 11 [ set abilities lput one-of (range 42 45) abilities]
    if i = 12 [ set abilities lput one-of [45 46 47 48 49 60] abilities]
    if i = 13 [ set abilities lput one-of [ 54 62 66] abilities]
    if i = 16 [ set abilities lput one-of [29 53 55 63 64 65] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput (random 10 + 1) expertises]
  ]

  if industry = 2 [
    set cap-capacity random 9 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 4, such that no number is repeated
  set capabilities n-of cap-capacity [1 2 3 4 7 10 11 12 13]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
    if i = 1 [ set abilities lput one-of [1 2 3 4 5 6 7 8 36] abilities]
    if i = 2 [ set abilities lput one-of [9 37] abilities]
    if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
    if i = 4 [ set abilities lput one-of [11 12 13 14 15 19 56] abilities]
    if i = 7 [ set abilities lput one-of [38 39] abilities]
    if i = 10 [ set abilities lput one-of [33 34 35 41] abilities]
    if i = 11 [ set abilities lput one-of (range 42 45) abilities]
    if i = 12 [ set abilities lput one-of (range 45 50) abilities]
    if i = 13 [ set abilities lput one-of [58 54 66] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput (random 10 + 1) expertises]
  ]

  if industry = 0 [
  ;capability capacity randomly chosen, but cannot be less than 2.
  set cap-capacity random 10 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 4, such that no number is repeated
  set capabilities n-of cap-capacity [1 2 3 4 7 10 11 12 13 16]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
    if i = 1 [ set abilities lput one-of [1 2 3 4 5 6 7 8 36] abilities]
    if i = 2 [ set abilities lput one-of [9 37 57] abilities]
    if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
    if i = 4 [ set abilities lput one-of [11 12 13 14 15 19 56 61] abilities]
    if i = 7 [ set abilities lput one-of (range 38 41) abilities]
    if i = 10 [ set abilities lput one-of [33 34 35 41] abilities]
    if i = 11 [ set abilities lput one-of (range 42 45) abilities]
    if i = 12 [ set abilities lput one-of [45 46 47 48 49 60] abilities]
    if i = 13 [ set abilities lput one-of [ 54 58 62 66] abilities]
    if i = 16 [ set abilities lput one-of [29 53 55 63 64 65] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput (random 10 + 1) expertises]
  ]
end

to initialise-Suppliers
  create-Suppliers nSupplier [
    set shape "truck"
    set size 3
    set color yellow
    setxy random-xcor random-ycor
    set initial-capital  100
    set capital initial-capital
    set industry random 3                 ;assigne to each of them as automotive, biomedical, or broker
    set ih []
    set max-veiled 1
    set start-project? false
    set partners no-turtles
    set previous-partners no-turtles
    set max-partners 5
    set capabilities []                         ; create a null kene
    set abilities []
    set expertises []
    set open-access random-float 1              ; set randomly in the absence of empirical data
    set public-engagement random-float 1
    set gender-equality random-float 1
    set ethical-thinking gender-equality + 0.1    ;   ethical-thinking è legato a gender equality dall'inizio, ma poiché non dipende solo da gender ha una quota in più
    if ethical-thinking > 1 [ set ethical-thinking 1]  ; non può essere più di 1
    set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
    set open-access-publications 0              ; number of open access publications
  ]
  ;  make some of them large firms, with extra initial capital
  ask n-of round ((big-firm-percent / 100) * nSupplier) Suppliers [
    set capital initial-capital * 10 ]
  ; randomly selects the start-project
  let n_start_project random nSupplier
  ask n-of n_start_project Suppliers [
    set start-project? true ]
end

to setup-Supplier
  make-kene-Suppliers
  make-innovation-hypothesis
  make-advert
end

;firm Suppliers procedure 4 capabilities; 10 abilities
to make-kene-Suppliers
  ;capability capacity randomly chosen; but cannot be less than 2.
  set cap-capacity random 6 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 4, such that no number is repeated
  set capabilities n-of cap-capacity [1 3 4 7 8 15]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  if industry = 1 or industry = 0
  [ foreach capabilities [i ->
    if i = 1 [ set abilities lput one-of [1 2 5 6 7 8] abilities]
    if i = 3 [ set abilities lput one-of [10 17 50 51 52] abilities]
    if i = 4 [ set abilities lput one-of [11 13 19 56] abilities]
    if i = 7 [ set abilities lput one-of (range 38 41) abilities]
    if i = 8 [ set abilities lput 18 abilities]
    if i = 15 [ set abilities lput one-of [9 16 37 57] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput (random 10 + 1) expertises]
  ]

    if industry = 2
   [ foreach capabilities [i ->
      if i = 1 [ set abilities lput one-of [1 2 5 6 7 8] abilities]
      if i = 3 [ set abilities lput one-of [10 17 50 51 52] abilities]
      if i = 4 [ set abilities lput one-of [11 13 19 56] abilities]
    if i = 7 [ set abilities lput one-of [38 39] abilities]
      if i = 8 [ set abilities lput 18 abilities]
      if i = 15 [ set abilities lput one-of [9 16 37] abilities]
      ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
      set expertises lput (random 10 + 1) expertises]
    ]
end




to initialise-Customers
  create-Customers nCustomer [
    set shape "person construction"
    set size 3
    set color brown
    setxy random-xcor random-ycor
    set initial-capital  100
    set capital initial-capital
    set industry random 2 + 1             ;assigne to each of them as automotive, biomedical (not broker)
    if industry = 1 [set shape "person doctor"]
    set ih []
    set max-veiled 1
    set start-project? false
    set partners no-turtles
    set previous-partners no-turtles
    set max-partners 5
    set capabilities []                       ; create a null kene
    set abilities []
    set expertises []
    set open-access random-float 1            ; set randomly in the absence of empirical data
    set public-engagement random-float 1
    set gender-equality random-float 1
    set ethical-thinking gender-equality + 0.1    ;   ethical-thinking è legato a gender equality dall'inizio, ma poiché non dipende solo da gender ha una quota in più
    if ethical-thinking > 1 [ set ethical-thinking 1]  ; non può essere più di 1
    set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
    set open-access-publications 0            ; number of open access publications
  ]
  ;  make some of them large firms, with extra initial capital
  ask n-of round ((big-firm-percent / 100) * nCustomer) Customers [
    set capital initial-capital * 10 ]
  ; randomly selects the start-project
  let n_start_project random nCustomer
  ask n-of n_start_project Customers [
    set start-project? true ]
end

to setup-Customer
  make-kene-Customers
  make-innovation-hypothesis
  make-advert
end

;firm Customer procedure 3 capabilities; 5 abilities
to make-kene-Customers
  ;capability capacity randomly chosen; but cannot be less than 2.
  if industry = 1
  [ set cap-capacity random 3 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 3, such that no number is repeated
  set capabilities n-of cap-capacity [4 6 14]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
    if i = 4 [ set abilities lput one-of [13 26] abilities]
    if i = 6 [ set abilities lput 27 abilities]
    if i = 14 [ set abilities lput one-of [24 25] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput random (10 + 1) expertises]
  ]

  if industry = 2
  [ set cap-capacity random 2 + 1
    if cap-capacity < 2 [ set cap-capacity 2 ]

    set capabilities n-of cap-capacity [4 14]
    set capabilities shuffle capabilities
    foreach capabilities [ i ->
      if i = 4 [ set abilities lput one-of [13 26] abilities]
      if i = 14 [ set abilities lput one-of [24 25] abilities]
      set expertises lput random ( 10 + 1) expertises]
  ]
end


to initialise-OEMs
  create-OEMs nOEM [
    set shape "factory"
    set size 3
    set color lime
    setxy random-xcor random-ycor
    set initial-capital  100
    set capital initial-capital
    set industry random 2 + 1             ;assigne to each of them as automotive, biomedical (not broker)
    set ih []
    set max-veiled 1
    set start-project? false
    set partners no-turtles
    set previous-partners no-turtles
    set max-partners 5
    set capabilities []                       ; create a null kene
    set abilities []
    set expertises []
    set open-access random-float 1              ; set randomly in the absence of empirical data
    set public-engagement random-float 1
    set gender-equality random-float 1
    set ethical-thinking gender-equality + 0.1    ;   ethical-thinking è legato a gender equality dall'inizio, ma poiché non dipende solo da gender ha una quota in più
    if ethical-thinking > 1 [ set ethical-thinking 1]  ; non può essere più di 1
    set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
    set open-access-publications 0              ; number of open access publications
  ]
  ;  make some of them large firms, with extra initial capital
  ask n-of round ((big-firm-percent / 100) * nOEM) OEMs [
    set capital initial-capital * 10 ]
  ; randomly selects the start-project
  let n_start_project random nOEM
  ask n-of n_start_project OEMs [
    set start-project? true ]
end

to setup-OEM
  make-kene-OEMs
  make-innovation-hypothesis
  make-advert
end

;firm Customer procedure 3 capabilities; 8 abilities
to make-kene-OEMs
  ;capability capacity randomly chosen; but cannot be less than 2.
  if industry = 1
  [ set cap-capacity random 10 + 1
  if cap-capacity < 2 [ set cap-capacity 2 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 3, such that no number is repeated
  set capabilities n-of cap-capacity [1 2 3 4 5 11 12 13 14 16]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
      if i = 1 [ set abilities lput one-of [1 2 5 8] abilities]
      if i = 2 [ set abilities lput 57 abilities]
      if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
      if i = 4 [ set abilities lput one-of [11 12 13 14 15 19 20 21 56 61] abilities]
      if i = 5 [ set abilities lput 30 abilities]
      if i = 11 [ set abilities lput one-of (range 42 45) abilities]
      if i = 12 [ set abilities lput one-of [45 46 47 48 49 60] abilities]
      if i = 13 [ set abilities lput one-of [54 58 62 66] abilities]
      if i = 14 [ set abilities lput 22 abilities]
      if i = 16 [ set abilities lput one-of [29 53 55 63 64 65] abilities]
      set expertises lput random (10 + 1) expertises]
  ]

 if industry = 2
 [ set cap-capacity random 6 + 1
    if cap-capacity < 2 [ set cap-capacity 2 ]

    set capabilities n-of cap-capacity [4 5 11 12 13 14]
    set capabilities shuffle capabilities
    foreach capabilities [i ->
      if i = 4 [ set abilities lput one-of [11 12 13 14 15 19 20 21 56 61] abilities]
      if i = 5 [ set abilities lput 23 abilities]
      if i = 11 [ set abilities lput one-of (range 42 45) abilities]
      if i = 12 [ set abilities lput one-of (range 45 50) abilities]
      if i = 13 [ set abilities lput 54 abilities]
      if i = 14 [ set abilities lput 22 abilities]
     ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
      if i = 11 or i = 12 [ set expertises lput random (4 + 1) expertises ]
      if i = 4 or i = 5 or i = 13 or i = 14 [set expertises lput (random 10 + 1) expertises]
  ] ]

end


to initialise-Research-insts
  create-Research-insts nResearch-inst [
    set shape "book"
    set size 3
    set color red
    setxy random-xcor random-ycor
    set dimension  100
    set capital dimension
    set industry random 3             ;research field
    set ih []
    set max-veiled 1
    set start-project? false
    set partners no-turtles
    set previous-partners no-turtles
    set max-partners 5
    set capabilities []                       ; create a null kene
    set abilities []
    set expertises []
    set open-access random-float 1            ; set randomly in the absence of empirical data
    set public-engagement random-float 1
    set gender-equality random-float 1
    set ethical-thinking gender-equality + 0.1    ;   ethical-thinking è legato a gender equality dall'inizio, ma poiché non dipende solo da gender ha una quota in più
    if ethical-thinking > 1 [ set ethical-thinking 1]  ; non può essere più di 1
    set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
    set open-access-publications 0           ; number of open access publications
  ]
  ;  make some of them large firms, with extra initial capital
  ask n-of round ((big-firm-percent / 100) * nResearch-inst) Research-insts [
    set capital dimension * 10 ]
  ; randomly selects the start-project
  let n_start_project random nResearch-inst
  ask n-of n_start_project Research-insts [
    set start-project? true ]
end

to setup-Research-inst
  make-kene-Research-insts
  make-innovation-hypothesis
  make-advert
end

;Research-insts procedure 10 capabilities; tot. abilities
to make-kene-Research-insts
  ;capability capacity randomly chosen; but cannot be less than 3.
  if industry = 1
  [ set cap-capacity random 10 + 1
  if cap-capacity < 3 [ set cap-capacity 3 ]

  ; fill the capability vector with capabilities.  These are integers
  ; between 1 and 3, such that no number is repeated
  set capabilities n-of cap-capacity [1 3 6 7 8 9 10 12 13 15]
  set capabilities shuffle capabilities
  ; fill the ability vector with abilities. These are integres and assigned
  foreach capabilities [i ->
      if i = 1 [ set abilities lput one-of [1 2 5 6 8 29 36] abilities]
      if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
      if i = 6 [ set abilities lput 27 abilities]
      if i = 7 [ set abilities lput one-of (range 38 41) abilities]
      if i = 8 [ set abilities lput one-of [29 31] abilities]
      if i = 9 [ set abilities lput 32 abilities]
      if i = 10 [ set abilities lput one-of [33 35] abilities]
      if i = 12 [ set abilities lput one-of [45 46 47 48 49 59] abilities]
      if i = 13 [ set abilities lput one-of [54 58 66 76] abilities]
      if i = 15 [ set abilities lput one-of [9 28 37] abilities]
    ; fill the expertise vector with expertise. These are integers randomly chosen between 1 and 10
    set expertises lput (random 10 + 1) expertises]
  ]

  if industry = 2
  [ set cap-capacity random 8 + 1
    if cap-capacity < 3 [ set cap-capacity 3 ]

    set capabilities n-of cap-capacity [1 3 7 8 9 10 12 15]
    set capabilities shuffle capabilities
    foreach capabilities [i ->
      if i = 1 [ set abilities lput one-of [1 2 5 6 8 36] abilities]
      if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
      if i = 7 [ set abilities lput one-of [38 39] abilities]
      if i = 8 [ set abilities lput 31 abilities]
      if i = 9 [ set abilities lput 32 abilities]
      if i = 10 [ set abilities lput one-of [33 35] abilities]
      if i = 12 [ set abilities lput one-of [45 46 47 48 49 59] abilities]
      if i = 15 [ set abilities lput one-of [9 28 37] abilities]
      set expertises lput (random 10 + 1) expertises]
  ]


  if industry = 0
  [ set cap-capacity random 10 + 1
    if cap-capacity < 3 [ set cap-capacity 3 ]

    set capabilities n-of cap-capacity [1 3 6 7 8 9 10 12 13 15]
    set capabilities shuffle capabilities
    foreach capabilities [i ->
      if i = 1 [ set abilities lput one-of [1 2 5 6 8 29 36] abilities]
      if i = 3 [ set abilities lput one-of [10 50 51 52] abilities]
      if i = 6 [ set abilities lput 27 abilities]
      if i = 7 [ set abilities lput one-of (range 38 41) abilities]
      if i = 8 [ set abilities lput one-of [29 31] abilities]
      if i = 9 [ set abilities lput 32 abilities]
      if i = 10 [ set abilities lput one-of [33 35] abilities]
      if i = 12 [ set abilities lput one-of [45 46 47 48 49 59] abilities]
      if i = 13 [ set abilities lput one-of [58 54 66 76] abilities]
      if i = 15 [ set abilities lput one-of [9 28 37] abilities]

      set expertises lput (random 10 + 1) expertises]
  ]

end

;INITIALIZE THE AGENT'S INNOVATION HYPOTHESIS
;turtles' procedure
; an innovation hypothesis is a vector of locations in the kene.  So, for example, an IH
; might be [1 3 4 7], meaning the second (counting from 0 as the first), fourth, fifth
; and eighth triple in the kene.  The IH cannot be longer than the length of the kene,
; not shorter than 2, but is of random length between these limits.
to make-innovation-hypothesis
  set ih []
  let location 0
  let kene-length length capabilities
  let ih-length one-of (range 2 (kene-length + 1))
  while [ ih-length > 0 ] [
    set location random kene-length
    if not member? location ih [
      set ih fput location ih
      set ih-length ih-length - 1
    ]
  ]
  ; reorder the elements of the innovation hypothesis in numeric ascending order
  set ih sort ih
end

; set up the firm's advert, which is the list of capabilities in its innovation
; hypothesis
;in this phase of the project, we explore the way of creating advertisement both in the way of SKIN and described in IAMRRI
;firm procedure
to make-advert
  set advert capabilities
  ;set advert map [ i -> item i capabilities ] ih  ; modify /length ih in procedure compatible,  length capabilities
end


to go
  tick
  IDEA-GENERATION-1
  IDEA-GENERATION-2
  IDEA-GENERATION-3
  GATE-NEXT-PHASE-2
  PRODUCT-DEVELOPMENT
  GATE-NEXT-PHASE-3
  move-partners
  move-networks
  do-incremental-research
  ask Networks [ask focal [set state state + 1]]
end


  ;;IDEA GENERATION-1
to IDEA-GENERATION-1
  ask turtles with [start-project? and state = 0 ] [
    make-innovation-hypothesis-veiled
    find-partners
    if count my-out-links  >= min-partners [
      create-net
      pay-cost-fine-tuning-idea]]
  set net-phase-1 count networks
end

;the agent aims competences that does not have.
;(in this phase we assume that the number of necessary and not available capabilities is equal to one.
;it will be calibrated in consequence of the empirical data)
; firm procedure
to make-innovation-hypothesis-veiled
  let veiled-capability  [one-of capabilities] of one-of other turtles
  if not member? veiled-capability capabilities and max-veiled > 0 [
    set advert sentence advert veiled-capability
    set max-veiled max-veiled - 1]
end

to find-partners
  let candidates no-turtles
  ;choose compatible agents
  ;ask other agents if I am compatible, if so I set them up as candidates
  set candidates turtles with [compatible? myself]
  if not any? candidates [stop]
 ;select exactly the number of partners I can afford
  if count partners < max-partners [
    set candidates up-to-n-of (max-partners - (count partners)) candidates
    set partners (turtle-set partners candidates)
    create-links-to partners
   ;ask the new partner to add me to the partners
      ask candidates [set partners (turtle-set myself partners)]]
end

;choice of compatible partners through a weighted average of the RRI values and capabilities of the
; potential partner. the weight given to the RRI values is set in the interface
;the potential partner with capabilities similar to mine and with a high  will have greater attractiveness;
to-report compatible? [possible-partner]
  let attractiveness 0
  ; (cannot partner with myself )
  if possible-partner = self  [ report false ]
  ; a possible partner cannot be an NGOs
  if member? self NGOs [report false]
  ;networks cannot partner
  if member? self Networks [report false]
  ; a possible partner cannot already be a partner of mine
  if member? self [partners] of possible-partner or member? possible-partner partners [report false]
  ; cannot have more than max-partners
  if count partners = max-partners [report false]
  set attractiveness ((length intersection advert [capabilities] of possible-partner / length capabilities) * (1 - RRI-attractiveness)
    + (mean [RRI-value] of possible-partner * RRI-attractiveness ))
  ;prefer agents from other breeds (exclude those of the same breed)
  if not member? possible-partner other breed    [set attractiveness attractiveness + 0.1]
  report attractiveness > attractiveness-threshold
end


;reports the set intersection of the lists a and b, treated as sets
to-report intersection [ set-a set-b ]
  let set-c []
  foreach set-a [ i -> if member? i set-b [ set set-c fput i set-c ] ]
  report set-c
end


; start-project's procedure
to create-net
  let focal-net  self
  let my-net-partners  ( turtle-set self  [partners] of self)
  hatch-Networks 1 [setxy (- max-pxcor) (- one-of (range (1 / 2 * max-pycor + 1 )  (max-pycor )))
    set size 2
    set start-project? start-project? = false
    set focal focal-net
    set net-partners my-net-partners
    set who-net-partners  [who] of net-partners
    set net-dimension  count my-net-partners
    set phase 1
    make-RRI
    set RRI-value []
    set partners no-turtles
    request-contribution-1
    set invested-capital initial-capital
    set open-access-publications 0


  ]
end

;pay the contribution fee
to request-contribution-1
  let partners-wealth sum [capital] of net-partners
  ask net-partners [
    let contribution-1 (initial-capital * (capital / partners-wealth))
    set capital capital - contribution-1]

end

to make-RRI
  set open-access mean [open-access] of net-partners
  set gender-equality mean [gender-equality] of net-partners
  set ethical-thinking  mean [ethical-thinking] of net-partners
  set public-engagement mean [public-engagement] of net-partners
  set RRI-net (list open-access public-engagement ethical-thinking gender-equality)
end


;pay for research partners and refing idea IH. The cost depends on partners' number and refing cost
to pay-cost-fine-tuning-idea
  pay-tax (refining-IH-cost * count partners)
end


;general procedure to pay tax
to pay-tax [ammount]
  set capital capital - ammount
end


;; IDEA-GENERATION-2
to IDEA-GENERATION-2
  ask Networks with [[state] of focal = 1] [
    find-ngo-partners
    update-RRI
    make-RRI
  ]
 end


to find-ngo-partners
ask Networks [
    let a mean RRI-net
    let o [who] of focal
    let d NGOs with [who != o]
    let c d with [ [attendance] of self <= a]
    let g count c
    let f count net-partners with [member? self NGOs]
    if focal = NGOs and f < 2 [
        if g = 0 [dissolve-network]
      if g >= 1 [
        set partners (turtle-set partners one-of c )]]
    if focal != NGOs and g = 0 and f = 1 [dissolve-network]
    if focal != NGOs and g = 1 and f = 0 [update-RRI]
    if focal != NGOs and g >= 1 and f = 1 [
    set partners (turtle-set partners one-of c)]
    if focal != NGOs and g > 1 and f < 2 [
     set partners (turtle-set partners n-of 2 c)]
;    if focal != NGOs and g >= 1 and f < 2 [
;          set partners (turtle-set partners n-of (2 - f) c)]
;        if f = 0 [
;          set partners (turtle-set partners n-of 2 c)]
;        set color pink
;          set size size + 3

]

end

;to contribute-funding-ngo
;  ask Networks [
;    let a count net-partners with [member? self NGOs]
;    let b mean RRI-net
;    if a = 2 [
;      ask net-partners [
;        if b < 0.4 [set capital capital + 10 ]
;        if (b > 0.4) and (b < 0.7) [set capital capital + 30]
;        if (b > 0.7) [ set capital capital + 50]
; ]]
;
;end

;network's partners procedure
to update-RRI
  if any? net-partners with [member? self NGOs] [
    ask net-partners [
      if self != NGOs  [
      set open-access open-access + 0.02
      set public-engagement public-engagement + 0.05 ]]
  ]

   ask net-partners[
    ;let RRI-network [RRI-net] of myself
    let difference (map - [RRI-net] of myself RRI-value)
    let project count Networks with [member? myself net-partners]
    foreach difference [ i ->
      if 0 = (position i difference) and open-access <= 1 [
        if (i < 0.3) and (i > 0) [set open-access (open-access + 0.2 / project) ]
        if (i > 0.3) and (i < 0.7) [set open-access (open-access + 0.14 / project)]
        if (i > 0.7) [set open-access (open-access + 0.07 / project)]]
      if 1 = (position i difference) and public-engagement <= 1 [
        if (i < 0.3) and (i > 0) [set public-engagement (public-engagement + 0.2 / project)]
        if (i > 0.3) and (i < 0.7) [set public-engagement (public-engagement + 0.14 / project)]
        if (i > 0.7) [set public-engagement (public-engagement + 0.07 / project)]]
      if 2 = (position i difference) and gender-equality <= 1 [
        if (i < 0.3) and (i > 0) [
          set gender-equality (gender-equality + 0.2 / project)
          set ethical-thinking (ethical-thinking + 0.1 / project)]
        if (i > 0.3) and ( i < 0.7) [
          set gender-equality (gender-equality + 0.14 / project)
          set ethical-thinking (ethical-thinking + 0.07 / project)]
        if (i > 0.7) [
          set gender-equality (gender-equality + 0.07 / project)
          set ethical-thinking (ethical-thinking + 0.04 / project)]]
    ]
   set RRI-value  (list open-access public-engagement ethical-thinking gender-equality)
    foreach RRI-value [i -> if i >= 1 [set i 1]]
  ]
end

;;IDEA-GENERATION-3
to IDEA-GENERATION-3
  ask Networks with [[state] of focal = 2]
  [ask net-partners [learn-from-partners]]
end

;firm procedure
to learn-from-partners
  ask partners [ merge-capabilities myself ]
  make-innovation-hypothesis
end

;firm procedure
to merge-capabilities [ other-firm ]
  add-capabilities other-firm
  ask other-firm [ add-capabilities myself ]
end

; for each capability in the other's innovation hypothesis, if it is new to me,
; add it (and its ability) to my kene (if I have sufficient capital), and make
; the expertise level 1 less. For each capability that is not new, if the other's
; expertise level is greater than mine, adopt its ability and expertise level,
; otherwise do nothing.

;firm procedure
to add-capabilities [ other-firm ]
  let my-position 0
  foreach [ih] of other-firm [ i ->
    let capability item i [capabilities] of other-firm
    ifelse member? capability capabilities [
      ;  capability already known to me
      set my-position position capability capabilities
      if item my-position expertises < item i [expertises] of other-firm [
        set expertises replace-item my-position expertises item i [expertises] of other-firm
        set abilities replace-item my-position abilities item i [abilities] of other-firm
      ]
    ]
    [
      ; capability is new to me; adopt it if I have 'room'
      if (length capabilities) < cap-capacity [
        set capabilities sentence capabilities capability
        set abilities sentence abilities item i [abilities] of other-firm
        let other-expertise (item i [expertises] of other-firm) - 1
        ; if other-expertise is 1, it is immediately forgotten by adjust-expertise
        if other-expertise < 2 [set other-expertise 2 ]
        set expertises sentence expertises other-expertise
      ]
    ]
  ]
end


;;GATE-NEXT-PHASE-2
to GATE-NEXT-PHASE-2
  ask Networks with [[state] of focal = 3] [
  make-quality
  next-phase-2?
  set net-gate-phase-2 net-gate-phase-2 + 1]
  if any? networks with [phase = 2] [
    set %survived-1 (net-phase-2 / net-gate-phase-2) * 100]

end


; the quality of a network's product is computed from the abilities and expertise in its
; innovation hypothesis: it is the sum (modulo 10) of the product of the abilities and
; (1 - e to the power of the corresponding expertise level)
;firm procedure
to make-quality
  set quality sum (map [ i -> (item i abilities) * (1 - exp (- (item i expertises))) ] ih)  mod 10
end

;if the idea overcomes these thresholds, the network can switch to next phase of product
;development, and a specific ‘rewarding mechanism’ is introduced for the successful network,
;otherwise the network is dissolved
;network procedure
to next-phase-2?
  ifelse ethical-thinking > regulator [
    set phase 2
    set net-phase-2 net-phase-2 + 1
    let member-net net-partners
    if total-funding-amount > funding [
    if mean RRI-net > funding-RRI and quality > funding-quality
    ;the funding received increase the invested capital
    ;;;set capital capital + (funds-amount / count networks) / count member-net
    [set invested-capital invested-capital + funding
     ;decrease funding allocated by funding organizations
        set total-funding-amount total-funding-amount - funding]]]
    [dissolve-network]

end


;network procedure
to dissolve-network
   let member-net net-partners
  ask net-partners [
    ;unhook each member from the network and kill the network agent
    set partners partners with [not member? self member-net]
    ;set previous-partners member-net]
  ]
  ask focal [ask my-out-links [die] set start-project? false]
  die
end


;;PRODUCT DEVELOPMENT
to PRODUCT-DEVELOPMENT
  ask Networks with [[state] of focal > 4 and [state] of focal < 16][
    if [state] of focal = 5 [less-partner?
      ask focal [find-partners]]
    make-quality
    publish-open-access
    if [state] of focal = 7 [update-RRI]
    make-RRI
    adjust-expertise
  ]

end


 ;expel partners who cannot afford the cost of ethical values
to less-partner?
  let RRI-value-net mean RRI-net
  ;greater is RRI value of my network, minor will be the cost to support ethical value cost
  let cost-for-RRI (RRI-cost * (1 - RRI-value-net ))
  let member-net net-partners
 ask net-partners
  [ifelse capital < cost-for-RRI [
    ; dissolve this round's partnerships, but remember the partners for the future
    if previous-partners != 0 [
    set previous-partners (turtle-set previous-partners partners)
    ;leave partners of this network
    set partners partners with [not member? self member-net]
    ask other member-net [set partners partners with [self != myself]]
    ]]
   ;pay the second contribution and updates the network's invested capital
    [set capital (capital - cost-for-RRI)]]
  set net-partners net-partners with [capital > cost-for-RRI]
  set net-dimension count net-partners
  ;dissolve the net if it does not have the min number of partners
  if net-dimension < min-partners [dissolve-network ]
  set invested-capital invested-capital + (cost-for-RRI * net-dimension)
end


; If the agent can afford to publish open access, the agent will then weigh open access orientation and will decide on whether to publish or not.
;While the weight has a strong effect on this decision, there is also an element of randomness to the decision, representing other factors
;influencing the decision maker, modelled by Bernoulli variable. If the decision is positive, the publication takes place, and the agent pays the open access fee.
to publish-open-access
  if [state] of focal = 14 [
  ask net-partners[
    let budget-for-publish 0.18 * initial-capital
    if (random-bernoulli open-access) and (capital > budget-for-publish) and (open-access > RRI-open-access-threshold) [
      set open-access-publications (open-access-publications + 1)
      set capital capital - budget-for-publish
      set open-access open-access + 0.07 ; if the agent make an open access publications its RRI value increase
      if open-access > 1 [set open-access 1]
      ask Networks with [member? myself net-partners] [set open-access-publications open-access-publications + 1]
        ]
  ]]
end

;Bernoulli distribution
;We can sample from a Bernoulli distribution by
;sampling from a continuous uniform distribution on
;the interval [0, 1). If the sampled value X < p, then
;the value of the Bernoulli variable is success; otherwise,
;it’s unsuccess. Essentially, we’re flipping a weighted coin.
to-report random-bernoulli [probability-true]
  report random-float 1.0 < probability-true
end


; raise the expertise level by one (up to a maximum of 10) for capabilities that
; are used in the innovation, and decrease by one for capabilities that are not.
; If an expertise level has dropped to zero, the capability is forgotten.

;firm procedure
to adjust-expertise
  if [state] of focal = 15 [
  let location 0
  while [ location < length capabilities ] [
    let expertise item location expertises
    ifelse member? location ih
      [ ; capability has been used - increase expertise if possible
        if expertise < 10 [ set expertises replace-item location expertises (expertise + 1) ]
    ]
    [ ; capability has not been used - decrease expertise and drop capability if expertise has fallen to zero
      ifelse expertise > 0
      [ set expertises replace-item location expertises (expertise - 1) ]
      [ forget-capability location set location location - 1]
    ]
    set location location + 1
  ]]
end
; remove the capability, ability, expertise at the given location of the kene.
; Warning; all hell will break loose if the capability that is being forgotten is included
; in the innovation hypothesis (but no test is done to check this).
; Although the keen is changed, the innovation hypothesis and the product are not (since
; the forgotten capability is not in the ih, this doesn't matter)

;firm procedure
to forget-capability [location ]
  set capabilities remove-item location capabilities
  set abilities remove-item location abilities
  set expertises remove-item location expertises
  adjust-ih location
end

; reduce the values (which are indices into the kene) in the innovation hypothesis to
; account for the removal of a capability.  Reduce all indices above 'location' by one

;firm procedure
to adjust-ih [ location ]
  let elem 0
  let i 0
  while [ i < length ih ] [
    set elem item i ih
    if elem > location [ set ih replace-item i ih (elem - 1 ) ]
    set i i + 1
  ]
end

;;GATE-NEXT-PHASE
to GATE-NEXT-PHASE-3
  ask Networks with [[state] of focal = 16][
  make-quality
  set net-gate-phase-3 net-gate-phase-3 + 1
  next-phase-3?]
  if any? networks with [phase = 3][set %survived-2 (net-phase-3 / net-gate-phase-3) * 100]
end

to next-phase-3?
  ifelse ethical-thinking < regulator or quality < standard-organization
  [dissolve-network]
  [set phase 3
   set net-phase-3 net-phase-3 + 1
   make-start-up]
end

;;START-UP
;network procedure
to make-start-up
  ifelse invested-capital > initial-capital and mean RRI-net > RRI-start-up-trigger
   [ask focal [hatch 1 [
      set shape "box"
      set size 3
      set capital initial-capital
      ;start-ups inherit a value of expertise less than one
      foreach expertises [i -> set i  i - 1]] ]
      set invested-capital invested-capital - initial-capital
      ;start-ups can receive funding
      let member-net net-partners
      ;the RRI threshold for funding start-ups is higher than that for networks
      if mean RRI-net > funding-RRI * 1.1 and quality > funding-quality
      ;the funding received is divided equally to all the network members as in SKIN
      [ask net-partners [set capital capital + (funding / count networks) / count member-net]]
  ]
  [stop]
end

;;RESERACH

;INCREMENTAL-RESEARCH
;Agents who are not involved in any network try to increase their attractiveness
;by investigating a new capability of their kene and inserting it in the ih and in advertisement.
;The ability is chosen randomly among those eligible with the new capability (to be implemented).
;In the absence of empirical data, we assume that the time needed to research a new C is three months.
to do-incremental-research
  if ticks mod 3 = 0 [
  ask turtles with [ count partners = 0 and not member? self networks and length ih < cap-capacity] [
    ;select unused capabilities
    let new-capabilities filter [i -> not member? i advert] capabilities
    if not empty? new-capabilities [
    let new-capability  one-of new-capabilities
    set ih se ih position new-capability capabilities
    set ih sort ih
    make-advert
    ;there is a cost to doing research
    pay-tax incr-research-tax
  ]]]
end



to layout-turtles
  if layout = "spring" [
    let factor sqrt count turtles
    if factor = 0 [ set factor 1 ]
    layout-spring turtles links (0 / factor) (5 / factor) (1 / factor)
  ]
  if layout = "circle" [
    ask AM-techs [ setxy 0 2 / 3 * max-pycor
      fd 20  ]
    ask OEMs [ setxy -2 / 3 * max-pxcor 1 / 6 * max-pycor
      fd 20 ]
    ask Suppliers [ setxy 2 / 3 * max-pxcor  1 / 6 * max-pycor
      fd 20 ]
    ask Customers [ setxy -1 / 2 * max-pxcor -1 / 2 * max-pycor
      fd 20 ]
    ask Research-insts [ setxy (1 / 2) * max-pxcor -1 / 2 * max-pycor
      fd 20 ]

  ]
  if layout = " UNINA"[
    ask AM-techs [ setxy 0 3 / 4 * max-pycor
      fd 10  ]
    ask OEMs [ setxy  -5 / 8 * max-pxcor 3 / 8 * max-pycor
      fd 10 ]
    ask Suppliers [ setxy 5 / 8 * max-pxcor  3 / 8 * max-pycor
      fd 10 ]
    ask Customers [ setxy -4 / 7 * max-pxcor -1 / 7 * max-pycor
      fd 10 ]
    ask Research-insts [ setxy 4 / 7 * max-pxcor -1 / 7 * max-pycor
      fd 10 ]
    ask NGOs [ setxy 0 -3 / 12 * max-pycor
      fd 10 ]
    ask patches with [pycor < -1 / 2 * max-pycor][
      set pcolor 94
      if pxcor > -70 [set pcolor 96]   ; patches che cambiano con il funding
      ;if pxcor > -70 + ( funds-amount / 40)  [set pcolor 25]                    ; 3 months; 10 patches
      if pxcor > -32  [set pcolor 97]                     ; 12 months; 31 patches
      ask patch -70 -60 [set plabel "Idea Gen" set plabel-color 0 ]
      ask patch -44 -60 [set plabel "Product Development" set plabel-color 0]
      ask patch 23 -60 [set plabel "Market Diffusion" set plabel-color 0]
    ]
    ask patch -66 -38 [set plabel "NETWORKS"]


  ]

  display
end
to move-partners
ask turtles[
    if start-project? = true [ask my-out-links [ask other-end [face other-end fd 1]]]]
end
to move-networks
  if layout = " UNINA"[
    ask Networks [
      if [xcor] of self <= 79[
        let r xcor + 3
        ifelse r < max-pxcor[setxy r ycor]
        [ setxy max-pxcor ycor]]]]
end
@#$#@#$#@
GRAPHICS-WINDOW
402
10
1120
729
-1
-1
4.41
1
10
1
1
1
0
0
0
1
-80
80
-80
80
0
0
1
month
30.0

BUTTON
250
70
305
103
NIL
setup\n
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
250
225
305
258
NIL
go\n
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
18
81
190
114
nAM-tech
nAM-tech
0
300
200.0
1
1
NIL
HORIZONTAL

SLIDER
18
120
190
153
nSupplier
nSupplier
0
300
200.0
1
1
NIL
HORIZONTAL

SLIDER
18
158
190
191
nResearch-inst
nResearch-inst
0
300
200.0
1
1
NIL
HORIZONTAL

SLIDER
18
196
190
229
nOEM
nOEM
0
300
200.0
1
1
NIL
HORIZONTAL

TEXTBOX
16
260
383
303
____________________________________________________________
11
0.0
0

TEXTBOX
16
266
399
294
____________________________________________________________
11
0.0
1

SLIDER
17
233
189
266
nCustomer
nCustomer
0
300
200.0
1
1
NIL
HORIZONTAL

SLIDER
200
345
373
378
RRI-attractiveness
RRI-attractiveness
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
15
355
187
388
standard-organization
standard-organization
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
15
318
187
351
regulator
regulator
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
16
392
188
425
funding
funding
0
200
50.0
50
1
NIL
HORIZONTAL

TEXTBOX
22
12
172
40
1) Insert the number of agents for each breed.
11
0.0
1

BUTTON
201
183
371
216
NIL
layout-turtles
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
201
136
371
181
layout
layout
"spring" "circle" "radial" "tutte" " UNINA"
4

TEXTBOX
17
286
167
312
2) Select environmental variables
11
0.0
1

TEXTBOX
202
288
352
306
3) Select firm's variable\n
11
0.0
1

TEXTBOX
301
310
451
328
NIL
11
0.0
1

TEXTBOX
194
63
216
665
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|
11
0.0
1

TEXTBOX
385
65
400
667
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|
11
0.0
1

TEXTBOX
-7
246
143
264
NIL
11
0.0
1

TEXTBOX
13
570
386
668
\n\n\n\n\n\n______________________________________________________________
11
0.0
1

TEXTBOX
205
115
355
133
5) Select the layout of turtles
11
0.0
1

TEXTBOX
10
50
25
680
|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n\n
11
0.0
1

TEXTBOX
205
50
355
68
4) Initialise the world and Go
11
0.0
1

TEXTBOX
20
490
190
518
___________________________
11
0.0
1

SLIDER
201
306
373
339
big-firm-percent
big-firm-percent
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
199
383
373
416
attractiveness-threshold
attractiveness-threshold
0
1
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
200
591
375
624
economic-threshold
economic-threshold
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
199
629
374
662
RRI-open-access-threshold
RRI-open-access-threshold
0
1
0.5
0.1
1
NIL
HORIZONTAL

TEXTBOX
203
575
353
593
publish-open-access
11
0.0
1

MONITOR
1390
125
1510
170
num. open-access pub
sum [open-access-publications] of networks
17
1
11

MONITOR
1130
57
1242
102
Networks Phase 1
count networks with [phase = 1]
17
1
11

SLIDER
16
428
188
461
funding-RRI
funding-RRI
0
1
50.0
0.1
1
NIL
HORIZONTAL

SLIDER
16
464
188
497
funding-quality
funding-quality
0
10
5.0
1
1
NIL
HORIZONTAL

MONITOR
1253
57
1359
102
Network Phase 2
count networks with [phase = 2]
17
1
11

MONITOR
1372
57
1478
102
Network Phase 3
count networks with [phase = 3]
17
1
11

PLOT
1130
535
1330
685
Average capital of networks
time
capital
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if any? networks [plot sum [invested-capital] of networks / count networks]"

TEXTBOX
1135
515
1315
546
ECONOMIC PERFORMANCE
13
0.0
1

TEXTBOX
1130
290
1320
308
 STRATEGIC PERFORMANCE
13
0.0
1

PLOT
1130
310
1330
460
Mean network size
time
NIL
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if any? networks [plot sum [net-dimension] of networks / count networks]"

TEXTBOX
1130
105
1280
123
SOCIETAL PERFORMANCE
13
0.0
1

PLOT
1130
125
1385
275
Average RRI value in network
time
Average RRI
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"open-access" 1.0 0 -13345367 true "" "if any? networks [plot mean [open-access] of networks]"
"ethical-thinking" 1.0 0 -2674135 true "" "if any? networks [plot mean [ethical-thinking] of networks]"
"public-engag." 1.0 0 -13840069 true "" "if any? networks [plot mean [public-engagement] of networks]"
"gender-equality" 1.0 0 -2064490 true "" "if any? networks [plot mean [gender-equality] of networks]"

MONITOR
1130
465
1230
510
Mean partnerships
count turtles with [any? my-links] / count turtles with [not member? self networks]
5
1
11

PLOT
1335
310
1495
460
Agents in networks
NIL
NIL
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"tot" 1.0 0 -16777216 true "" "if any? networks [plot (count turtles with [any? my-links])]"

MONITOR
1238
465
1318
510
NIL
net-phase-1
17
1
11

MONITOR
1325
465
1407
510
NIL
%survived-1
17
1
11

MONITOR
1415
465
1497
510
NIL
%survived-2
17
1
11

SLIDER
18
508
190
541
RRI-cost
RRI-cost
0
90
30.0
1
1
NIL
HORIZONTAL

MONITOR
1253
10
1359
55
Networks
count Networks
17
1
11

PLOT
1500
310
1665
460
percentage agent in networks
NIL
NIL
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if any? networks [plot (count turtles with [any? my-links] / (count turtles - count networks))]"

SLIDER
201
539
373
572
RRI-start-up-trigger
RRI-start-up-trigger
0
1
0.5
0.1
1
NIL
HORIZONTAL

TEXTBOX
206
522
356
540
start-up
11
0.0
1

MONITOR
1504
465
1594
510
start-up
count turtles with [shape = \"box\"]
17
1
11

MONITOR
1516
664
1886
709
NIL
mean (map [i -> length i][capabilities] of turtles with [any? links])
17
1
11

SLIDER
18
44
190
77
nNGO
nNGO
0
400
200.0
10
1
NIL
HORIZONTAL

SLIDER
200
418
372
451
big-ngo-percent
big-ngo-percent
0
30
5.0
1
1
NIL
HORIZONTAL

SLIDER
203
485
375
518
ngo-attendance
ngo-attendance
0
1
0.5
0.1
1
NIL
HORIZONTAL

TEXTBOX
208
468
358
486
NGO
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

I AM RRI SKIN (WEBS OF INNOVATION VALUE CHAINS OF ADDITIVE MANUFACTURING UNDER CONSIDERATION OF RRI) is an agent-based-model of webs of innovation value chains (IVCs), in the context of additive manufacturing (AM), to identify openings for doing responsible research and innovation (RRI). As an extension of the SKIN model, it reproduces at its core the framework of knowledge. 
It mainly focuses on the study of innovation value chains (IVCs), webs of IVCs and openings for responsible research and innovation (RRI). The proposed model incorporates complexity, covering various stages of innovation development through IVCs. 
The development of the innovation process goes through phases in which the capabilities (large domains of knowledge) and the abilities (applications in these domains) needed for an idea to be further developed are not well defined, it is therefore essential the cooperation among agents and the creation of networks of IVCs. 
Moreover, unlike SKIN, the innovation process develops through different ticks and is not obtained just in one tick. Each phase covers a defined number of ticks, which is the result of various WPs of the project. 
The implemented phases are two: idea generation (3 ticks) and product development (12 ticks). This choice derives from the study of use cases and bases on the following assumption: 1 ticks = 1 month. Additionally, the decisions and the behavior of the agents are not only price-related and cost-related, but time-related and RRI-related.
Each agent is equipped with three RRI state variables, representing RRI inclinations (open access, public engagement, ethical thinking) that profoundly influence the decision-making process.
Other relatively minor extensions have been introduced to adapt the model to automotive and medical cases. A double industry model has been built, in which five different types of agents’ breeds  (a particular typology of agentset, endowed with particular variables) interact between them also participating to more network simultaneously.  
The five types of agents’ breeds are: AM-tech, Suppliers, Customers, OEMs, Research-inst. Other agents like the funding organizations and the standard organizations are modeled like aggregate entities (in this version of the model, funding organizations and standard organizations are environmental-global variables). 


## HOW IT WORKS

AGENT’S INITIALIZATION
Each agent has an equal amount of resources available to all, but the model supports the setting of a slider with which a precise percentage of large agents is created; this percentage is equal for each breed. 
Agents are assigned to one of the two industries (automotive or medical) and one of the five breeds. Some are chosen as broker agents, those who represent a potential link between the two industries. 
They are fitted with three pseudo-random RRI-related variables and a Kene. These latter are assigned taking into account the type of agent and its financial resources. 
Therefore capabilities, abilities and expertise (C, A, E) have a precise characterization, coherent with the empirical reality. At this point all agents can produce an innovation hypothesis (IH), but only a fraction of them, defined focal agents, produces a sustainable and perfectible one. 
The other agents can support this refining process or alternatively do research by improving and increasing their "knowledge capital", in order to increase the chances of being chosen as partners by a focal agent in the next ticks. 
Once the IH is created, the agents produce an advertisement containing all the C's of their Kene and readable by other organizations. 
Through the advertisement, the focal can select partners in order to improve the quality of the idea and in order to ensure that all the necessary skills for the development of the idea are possessed within the network.

IDEA GENERATION 1                                               
In the first phase of idea generation, which     lasts 1 tick (1 month = 1 tick), the agent-start-project (the focal agent) begins the search for partners necessary for the development of its idea. 
The selection of potential partners is not done by looking only at past experience, but all agents with appropriate C's are considered. 
One of the main reasons why a focal decides to start an IVC, is that it doesn't have all the Cs needed to develop its idea and some of them are still unknown. 
The innovation idea (IH) is modeled in SKIN as a vector. Its values consist of the positions within the Kene of the Cs used to develop the idea. 
In IAMRRI, as mentioned, not all Cs are available to the focal, but are even fuzzy and undefined. Therefore, the IH vector will consist of elements of its own Kene and elements yet to be "unraveled". Thus, the agents involved in the IVC are also likely to modify the nature of the idea. The above C's not only influence the IH, but also the advertisement.
As mentioned, advertisement serves to make one's own Cs readable to other agents. In addition, focal agents also use it to show the Cs they do not own and that they are looking for.
The potential partners of the IVC with a greater chance of being selected are those who possess the same Cs as the focal, but who belong to different breeds. In this way, two hypotheses that emerged in the various WPs and from the analysis of empirical data are supported: 1) the heterogeneity of the agents involved in IVC and 2) the need to search for complementary capabilities (e.g., an AM-tech with C=AM material will select a Customer with C=AM-material). Therefore, the intersection of the advertisement of the focal with that of the potential partner is assessed first. 
Another fundamental variable to be taken into consideration when searching for partners is their RRI inclinations, modeled as the weighted average of RRI values. The hypothesis at the basis of this computational choice depends on the evidence that a potential partner with high RRI values will be more visible to other agents and to the focal.
These two parameters, intersection between advertisement and RRI values of the potential partner, are evaluated by focal through the weighted average. The weight (RRI-threshold) given to the RRI values, and consequently that given to the intersection of the advertisement (expressed as 1 - RRI-threshold) is set through a slider in the interface. The result of this weighted average acts as a discriminator between potential partners: those who exceed a certain attractiveness-threshold are added.
The financial resources, in addition to influencing the size of the Kene of an agent, also condition the size and the composition of the network. 
Once the minimum number of partners has been reached, the focal can create the network/IVC by sustaining a cost relative to the refining of the idea.
The members of the IVC will be asked to pay a share of contributions to constitute the common fund (investment-capital).
At this point, the RRI values of each member can be assessed and then averaged. This average is used to model the RRI value of the network agent and will be necessary for subsequent mechanisms of interaction with partners and exogenous agents.

IDEA GENERATION 2
The second subphase is entirely dedicated to the mechanisms of RRI updating within the network or IVC.
At this point, the first mechanism of spreading RRI values can be realized.
Each agent involved in an IVC or in a network evaluates the difference between its own RRI variables and those of the network, which is the result of the weighted average of the RRI variables of the members.
In the case where the RRI values of the network are greater than its own, the agent must adapt, increasing its RRI values. This is also due to the fact that the members of a collective organization must better conform to the collective values.
The updating mechanism uses a step function to better represent the agent's inertia to change. The greater the distance between one's own RRI values and those of the network, the lower the RRI increment and thus the willingness to conform to the collective values.
IDEA GENERATION 3
At this point, once the network has been created and the RRI values of the members have been updated, the learning and diffusion of knowledge among the partners takes place.
The same mechanism as in SKIN is used: the agent who has enough resources to add new Capabilities compares its knowledge with that used by the partners in their Innovation Hypothesis. 
If the agent does not have the Capability present in the partner's Innovation Hypothesis, it adds this Capability and the relative Ability to its own kene with a level of Expertise lower of 1 unit.
While, if the Capability taken into consideration is already available in the agent's Kene, it is necessary to compare the levels of expertise: if the level of expertise of the partner is higher, the level of expertise and the ability of the latter is adopted, otherwise the Kene remains unchanged.

GATE NEXT PHASE 2
The points of connection between one phase and another, called gate-next-phase, are of crucial importance. 
They constitute the filter and sorting of the networks or IVCs that are about to pass into the next and consequential phase.
The selective capacity of the filter is modifiable by the user in the interface.
In this transition phase the networks are screened through the evaluation of three characteristics: the quality of the idea of innovation, the inclination to ethical thinking and the value of the RRI variables.
The quality is modeled as in SKIN: we consider the abilities and relative levels of expertise for each triple within the Innovation Hypothesis (the idea); we make the product and finally normalize the result.
The verification of the inclination of the networks to ethical thinking is carried out by the regulatory bodies. In addition, having met the requirements imposed by the regulatory bodies, they can access funds made available by funding organizations, which assess their quality and RRI inclination.
These organizations are modeled as environmental and exogenous variables. 
Using the mechanism of welfare and grant funding from local, national and EU bodies, networks receive funding if the quality of their idea meets the level imposed by the funding organizations.  At the beginning of the simulation the 'total' amount of funding for innovative projects of high quality and high RRI inclination is set. This capital allocated by the funding organizations, obviously, is reduced every time a network receives funding. Therefore, networks that have taken the longest to develop and conclude the first phase of the innovation process (IAMRRI takes into account the inter-agent variability in the duration of the phases) may not receive valuable funding because of their worse timing.
Networks that do not achieve the level of ethical-thinking mandated by regulatory bodies dissolve: network members terminate internal partnerships but keep the memory of them; the network agent disappears from the simulation environment.

PRODUCT DEVELOPMENT
Networks or IVCs that pass the first next-gate-phase can start the product development phase.
This phase lasts longer than the first, taking a minimum of 12 ticks (12 months).
At the beginning of this phase, the network agent may expel members who do not have adequate financial resources to meet the costs of promoting ethical values.
An agent involved in a network or IVC could parasitically exploit the resources provided by the network. Therefore, the greater the network's availability of resources to support ethical values, the lower the expense faced by members.
Again, expelled members disrupt internal partnerships, but preserve the memory of them.
Promoting ethical values, from the productive perspective of the individual member, represents an investment. However, this investment is tracked through the capital invested within the network. 
Agents involved in a network or IVC may decide whether to make open access publications, following the process of learning, development and cooperation with partners.
Members assess their own RRI inclinations and financial resources. Once the thresholds are met, it is necessary to consider a further element of randomness that serves to model some aspects of uncertainty and aleatory nature of the process. 
This element of randomness has been modeled through a Bernoullian variable with parameter p equal to the open-access value of the agent. Obviously, each open access publication must absorb economic resources.
At the end of the second phase of the innovation process the updating-RRI mechanism is reiterated together with the adjust-expertise mechanism (borrowed from SKIN).

GATE-NEXT-PHASE-3
Networks that have gone through the entire second phase must face the second round of selection: regulators once again assess the average ethical-thinking value, while standard organizations assess the qualitative specifications of the innovation idea.
Networks or IVCs that successfully pass this stage can create ethical start-ups that operate in the marketplace; alternatively, they disappear.

START-UP
The requisites for the network to create an ethical start-up are a capital quota necessary to support the start-up phase and a sufficiently high average value of the RRIs.
The start-up inherits the characteristics of the focal such as: innovation hypothesis, breed, Kene.
However, the kene is not totally cloned, but undergoes adjustments due to the lower competence and familiarity of the start-up: the levels of expertise are decreased by one.
At this point the start-ups are evaluated by the funding bodies and have the possibility to receive a credit based on the level of quality of the innovation idea. This allocation, unlike the first one, is distributed among the founding members of the start-up.

INCREMENTAL-RESEARCH
Agents that are not involved in any network or IVC seek to increase their attractiveness by acquiring new knowledge domains.
Obviously, the agent must be provided with sufficient economic resources to deal with the search process and to add a new Capability within its Kene.
The Capabilities sought in this phase are part of the set of knowledge that characterize the agent’s typology (called "breed" in Netlogo language).
For the period in which an agent carries out research there is a minimum duration too (3 ticks = 3 months). 

OUTPUTS
The outputs are divided into three macro-areas of impact: social, economic and strategic.
The economic performance of the system is analyzed through the continuous evaluation of the average capital of the networks that make up the system.
The strategic performance is evaluated through several indices: 
•	the number of start-ups created
•	the average size of the networks
•	the number of agents involved in the networks
•	Percentage of agents involved
•	The percentage of surviving agents for each phase.
The result in social terms is estimated through a graph that expresses the time trend of the average value of RRI values, for each RRI variable identified. Thus, the increase, decrease, and periods of greatest spread of RRI values are observed.
Another proxy used is the number of open access publications that were made during the simulation.
Obviously, at each time point in the simulation, the number of networks/IVCs relative to each phase and the total number of networks is provided.


## HOW TO USE IT

The interface of IAMRRI allows an easy use and an easy understanding of the mechanisms and results of the simulations.
The sliders, on the left side of the interface, have been divided in a modular and sequential way in order to guide the user.
In the first block the user can choose the number of actors involved for each breed.
In the second block, the user must set the values of some exogenous and environmental variables, including those related to funding bodies and standard organizations.
In the third one, the experimenter can choose some endogenous characteristics of the agent, especially related to the aspects connected to the RRI values that influence the interaction mechanisms.
Finally, before starting the simulation, one can decide to adopt a particular layout to visualize the collective behavior of the agents. For example, the UNINA layout allows to visualize the links between the focal agent and its partners, while the created networks/IVCs occupy the lower part of the environment in which the agents move. It can be seen how the networks traverse the various stages of different lengths and which networks have a time advantage over the others.
The right part of the interface is occupied by several diagrams and monitors that describe the various outputs divided by impact area.


## CREDITS AND REFERENCES
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

book
false
0
Polygon -7500403 true true 30 195 150 255 270 135 150 75
Polygon -7500403 true true 30 135 150 195 270 75 150 15
Polygon -7500403 true true 30 135 30 195 90 150
Polygon -1 true false 39 139 39 184 151 239 156 199
Polygon -1 true false 151 239 254 135 254 90 151 197
Line -7500403 true 150 196 150 247
Line -7500403 true 43 159 138 207
Line -7500403 true 43 174 138 222
Line -7500403 true 153 206 248 113
Line -7500403 true 153 221 248 128
Polygon -1 true false 159 52 144 67 204 97 219 82

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

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

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

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

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

gear
false
0
Circle -13345367 true false 32 164 108
Circle -13345367 true false 128 38 134
Circle -13345367 true false 39 69 42
Rectangle -13345367 true false 105 83 283 115
Rectangle -13345367 true false 176 18 208 196
Polygon -13345367 true false 240 32 265 56 146 178 120 152 240 32
Polygon -13345367 true false 120 60 146 36 266 154 240 180 120 60
Circle -11221820 true false 140 51 108
Circle -13345367 true false 181 93 24
Rectangle -13345367 true false 13 204 162 232
Rectangle -13345367 true false 70 140 98 289
Polygon -13345367 true false 121 157 141 177 35 273 19 255 121 158
Polygon -13345367 true false 25 171 44 150 145 258 127 274 27 170
Circle -11221820 true false 47 180 78
Circle -13345367 true false 75 209 20
Polygon -13345367 true false 81 109 75 115 38 71 45 65 81 109
Polygon -13345367 true false 79 68 84 74 38 111 32 104 79 67
Rectangle -13345367 true false 32 84 88 93
Rectangle -13345367 true false 55 61 64 117
Circle -11221820 true false 46 75 28
Circle -13345367 true false 56 85 8

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

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person doctor
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13345367 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -7500403 true true 105 90 60 195 90 210 135 105
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 114 156 120 195 90 270 210 270 180 195 186 155 210 210 240 195 195 90 165 90 150 150 135 90
Line -16777216 false 150 148 150 270
Line -16777216 false 196 90 151 149
Line -16777216 false 104 90 149 149
Circle -1 true false 180 0 30
Line -16777216 false 180 15 120 15
Line -16777216 false 150 195 165 195
Line -16777216 false 150 240 165 240
Line -16777216 false 150 150 165 150

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
<experiments>
  <experiment name="experiment" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>net-phase-1</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nNGO">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.2"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-ngo-percent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ngo-attendance">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="validation1" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean [length remove-duplicates [breed] of net-partners / net-dimension] of networks</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.2"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nNGO">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-ngo-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ngo-attendance">
      <value value="0.3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="validation1.1" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean [length remove-duplicates [breed] of net-partners / net-dimension] of networks</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="RRI-attractiveness" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="validation2" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean (map [i -&gt; length i][capabilities] of turtles with [any? links])</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.2"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nNGO">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-ngo-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ngo-attendance">
      <value value="0.3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="verification2" repetitions="300" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean [ethical-thinking] of networks</metric>
    <metric>mean [public-engagement] of networks</metric>
    <metric>mean [open-access] of networks</metric>
    <metric>mean [gender-equality] of networks</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nNGO">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ngo-attendance">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-ngo-percent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="verification2agetnt" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>count networks</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>net-phase-1</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.2"/>
      <value value="0.7"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="validation2tutteC" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean (map [i -&gt; length i][capabilities] of turtles with [any? links])</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.2"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="validation2.1arw2011" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean  ([sqrt sum(map * abilities expertises )] of turtles with [any? my-links])</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.2"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="validation2-dimension networks" repetitions="300" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>mean (map [i -&gt; length i][capabilities] of turtles with [any? links])</metric>
    <metric>mean [net-dimension] of networks</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.2"/>
      <value value="0.5"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment3" repetitions="300" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 30</exitCondition>
    <metric>sum [capital] of turtles with [any? links] / count turtles with [any? links]</metric>
    <metric>count turtles with [any? my-links]</metric>
    <metric>sum [invested-capital] of networks / count networks</metric>
    <enumeratedValueSet variable="nCustomer">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nNGO">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attractiveness-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="standard-organization">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nResearch-inst">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-open-access-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nSupplier">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-attractiveness">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="regulator">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-cost">
      <value value="30"/>
      <value value="50"/>
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ngo-attendance">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-ngo-percent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="economic-threshold">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nOEM">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-RRI">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="layout">
      <value value="&quot; UNINA&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="big-firm-percent">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RRI-start-up-trigger">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nAM-tech">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding-quality">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="funding">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
