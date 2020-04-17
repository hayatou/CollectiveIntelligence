Class {
	#name : #Trip,
	#superclass : #Object,
	#instVars : [
		'client',
		'flights'
	],
	#category : #Optimization
}

{ #category : #'as yet unclassified' }
Trip class >> tripFor: aPerson [
	| trip person origin outboundF returnF |
	trip := Trip new.
	trip client: aPerson.
	person := Optimization peoples detect: [ :e | e first = aPerson ].
	origin := person second.
	outboundF := Flight flightsFrom: origin to: Optimization destination.
	returnF := Flight flightsFrom: Optimization destination to: origin.
	trip client: person first.
	trip addFlights: outboundF atRandom.
	trip addFlights: returnF atRandom.
	[ trip isValid ]
		whileFalse: [ trip flights: OrderedCollection new.
			trip addFlights: outboundF atRandom.
			trip addFlights: returnF atRandom ].
	^ trip
]

{ #category : #comparing }
Trip >> = aTrip [
	^ self client asString = aTrip client asString and: (self flights collect: #asString) = (aTrip flights collect: #asString)
]

{ #category : #accessing }
Trip >> addFlights: anObject [
	self flights add: anObject
]

{ #category : #accessing }
Trip >> asString [
	| str |
	str := self client asString , '   ' , self flights first origin asString , '	'.
	self flights
		do: [ :e | 
			str := str , e departureTime asString , '-' , e arrivalTime asString , '	' , e myCurrency
				, e price asString , '	' ].
	^ str
]

{ #category : #accessing }
Trip >> client [
	^ client
]

{ #category : #accessing }
Trip >> client: anObject [
	client := anObject
]

{ #category : #accessing }
Trip >> flights [
	^ flights
]

{ #category : #accessing }
Trip >> flights: anObject [
	flights := anObject
]

{ #category : #initialization }
Trip >> initialize [
	super initialize.
	client := nil.
	flights := OrderedCollection  new
]

{ #category : #testing }
Trip >> isValid [
	^ self flights first arrivalTime < self flights second departureTime
]

{ #category : #'as yet unclassified' }
Trip >> mutate: aFlight [
	"if aFlight=1 the outbound flight will be change at random else the return flight"

	| trip outboundF returnF |
	trip := self deepCopy.
	outboundF := Flight flightsFrom: self flights first origin to: Optimization destination.
	returnF := Flight flightsFrom: Optimization destination to: self flights first origin.
	aFlight = 1
		ifTrue: [ trip flights removeFirst.
			trip flights addFirst:  outboundF atRandom.
			 ]
		ifFalse: [ trip flights removeAt: 2.
			trip  addFlights:  returnF  atRandom ].
	
	
	^ trip
]

{ #category : #'as yet unclassified' }
Trip >> nextDepartureFlightTrip [
"create a new trip where the departure flight was changed to next"
	| nextF result |
	result := self deepCopy.
	nextF := result flights first nextFlight.
	result flights removeFirst.
	result flights addFirst: nextF.
	^ result
]

{ #category : #'as yet unclassified' }
Trip >> nextReturnFlightTrip [
"create a new trip where the return  flight was changed to next"

	| nextF result |
	result := self deepCopy.
	nextF := result flights second nextFlight.
	result flights removeAt: 2.
	result flights add: nextF.
	^ result
]

{ #category : #'as yet unclassified' }
Trip >> outBoundFlightDuration [
	^ self flights first arrivalTime  subtractTime: self flights first departureTime 
]

{ #category : #'as yet unclassified' }
Trip >> outboundFlightArrivalTime [
^ self flights first arrivalTime 
]

{ #category : #'as yet unclassified' }
Trip >> outboundFlightDepartureTime [
	^ self flights first departureTime 
]

{ #category : #'as yet unclassified' }
Trip >> previousDepartureFlightTrip [
"create a new trip where the departure flight was changed to the previous one"

	| nextF result |
	result := self deepCopy.
	nextF := result flights first changeToPrevious.
	result flights removeFirst.
	result flights addFirst: nextF.
	^ result
]

{ #category : #'as yet unclassified' }
Trip >> previousReturnFlightTrip [
"create a new trip where the return flight was changed to the previous one"

	| nextF result |
	result := self deepCopy.
	nextF := result flights second changeToPrevious.
	result flights removeAt: 2.
	result flights add: nextF.
	^ result
]

{ #category : #accessing }
Trip >> price [
^ ((self flights collect: #price) collect: #asInteger) sum.
	
]

{ #category : #'as yet unclassified' }
Trip >> returnFlightArrivalTime [
	^ self flights last arrivalTime
]

{ #category : #'as yet unclassified' }
Trip >> returnFlightDepartureTime [
	^ self flights last departureTime 
]

{ #category : #'as yet unclassified' }
Trip >> returnFlightDuration [
	^ self flights second arrivalTime  subtractTime: self flights second departureTime 
]

{ #category : #'as yet unclassified' }
Trip >> travelDuration [
	^ self outBoundFlightDuration addTime: self returnFlightDuration
	
]
