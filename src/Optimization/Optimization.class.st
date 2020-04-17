Class {
	#name : #Optimization,
	#superclass : #Object,
	#category : #Optimization
}

{ #category : #accessing }
Optimization class >> annealingCooler [
	^ 0.95
]

{ #category : #accessing }
Optimization class >> annealingOptimize [
	| temp cool sol |
	temp := self annealingTemperature.
	cool := self annealingCooler.
	sol := GroupTrip randomGroupTrip.
	[ temp > 0.1 ]
		whileTrue: [ | tripInd direction newsol chosenFlight newCost cost prob |
			tripInd := Random new nextInt: sol trips size.
			direction := (Array with: 1 with: -1) at: (Random new nextInt: 2).
			chosenFlight := (Array with: 1 with: -1) at: (Random new nextInt: 2).
			newsol := sol
				neighborOf: (sol trips at: tripInd)
				inDirection: direction
				forFlight: chosenFlight.
			cost := sol scheduleCost.
			newCost := newsol scheduleCost.
			prob := ((newCost negated - cost) / temp) exp.
			(newCost < cost or: Random new next < prob)
				ifTrue: [ sol := newsol ].
			temp := temp * cool ].
		^ sol
]

{ #category : #accessing }
Optimization class >> annealingTemperature [
	^ 1000
]

{ #category : #accessing }
Optimization class >> destination [
^'LGA'
]

{ #category : #'as yet unclassified' }
Optimization class >> geneticElite [
	^ 0.2
]

{ #category : #'as yet unclassified' }
Optimization class >> geneticInitialPopulation [
	| pop |
	pop := OrderedCollection new.
	1 to: self geneticPopSize do: [ :e | pop add: GroupTrip randomGroupTrip ].
	^ pop sorted: [ :first :second | first scheduleCost  <= second scheduleCost  ]
]

{ #category : #'as yet unclassified' }
Optimization class >> geneticMaxIter [
	^ 1000
]

{ #category : #'as yet unclassified' }
Optimization class >> geneticMutProb [
	^ 0.2
]

{ #category : #'as yet unclassified' }
Optimization class >> geneticOptimization [
	| pop elite |
	pop := self geneticInitialPopulation.
	elite := pop first: (self geneticPopSize * self geneticElite) asInteger.
	(1 to: self geneticMaxIter)
		do: [ :e | 
			| newPop |
			newPop := OrderedCollection new.
			newPop addAll: elite.
			[ newPop size < self geneticPopSize ]
				whileTrue: [ Random new next < self geneticMutProb
						ifTrue: [ newPop add: elite atRandom mutate.
					 ]
						ifFalse: [ | a b |
							a := elite atRandom deepCopy.
							b := elite atRandom deepCopy.
							newPop add: (a crossOver: b).
							] ].
			pop := newPop sorted: [ :first :second | first scheduleCost <= second scheduleCost ].
			elite := pop first: (self geneticPopSize * self geneticElite) asInteger ].
	^ pop first
]

{ #category : #'as yet unclassified' }
Optimization class >> geneticPopSize [
	^ 50
]

{ #category : #'as yet unclassified' }
Optimization class >> hillClimbOptimize [
	"comment stating purpose of message"

	| cost sameCost sol |
	sol := GroupTrip randomGroupTrip.
	cost := sol scheduleCost.
	sameCost := 1.
	[ sameCost = self maxHillClimbing ]
		whileFalse: [ | neighbors |
			neighbors := sol neighbors.
			neighbors
				do: [ :e | 
					e scheduleCost < cost
						ifTrue: [ cost := e scheduleCost.
														sol := e ].
					e scheduleCost = cost
						ifTrue: [ sameCost := sameCost + 1 ] ] ].
	^ sol
]

{ #category : #accessing }
Optimization class >> maxHillClimbing [
^2
]

{ #category : #'as yet unclassified' }
Optimization class >> peoples [
	^ OrderedCollection
		with: (OrderedCollection with: 'Seymour' with: 'BOS')
		with: (OrderedCollection with: 'Franny' with: 'DAL')
		with: (OrderedCollection with: 'Zooey' with: 'CAK')
		with: (OrderedCollection with: 'Walt' with: 'MIA')
		with: (OrderedCollection with: 'Buddy' with: 'ORD')
		with: (OrderedCollection with: 'Les' with: 'OMA')
]

{ #category : #'as yet unclassified' }
Optimization class >> randomOptimize [
	"comment stating purpose of message"

	| best sol |
	best := 99999999999.
	(1 to: 100)
		do: [ :e | 
			| randomSol |
			randomSol := GroupTrip  randomGroupTrip.
			randomSol scheduleCost < best
				ifTrue: [ best := randomSol scheduleCost.
					sol := randomSol ] ].
	^ sol
]
