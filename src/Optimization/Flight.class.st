Class {
	#name : #Flight,
	#superclass : #Object,
	#instVars : [
		'origin',
		'destination',
		'departureTime',
		'arrivalTime',
		'price',
		'date'
	],
	#category : #Optimization
}

{ #category : #'as yet unclassified' }
Flight class >> allFlights [
	"comment stating purpose of message"

	^ Flight  flightsListFromFile: 'schedule.txt'
]

{ #category : #'as yet unclassified' }
Flight class >> allFlightsSorted [
	"comment stating purpose of message"

	^ self allFlights 
		sorted: [ :first :second | first departureTime <= second departureTime ]
]

{ #category : #'as yet unclassified' }
Flight class >> flightFromString: aString [
	| elts |
	elts := aString substrings: ','.
	^ Flight
		origin: elts first
		destination: elts second
		departureTime: elts third
		arrivalTime: elts fourth
		price: elts fifth
]

{ #category : #'as yet unclassified' }
Flight class >> flightsFrom: anOrigin to: aDestination [
	"comment stating purpose of message"

	| result |
	result := OrderedCollection
		withAll: ((Flight sortedFlightsFrom: anOrigin) select: [ :e | e destination = aDestination ]).
	^ result

]

{ #category : #'as yet unclassified' }
Flight class >> flightsListFromFile: aFileName [
	| file result |
	result := OrderedCollection new.
	file := FileStream fileNamed: aFileName.
	[ file atEnd ]
		whileFalse: [ | line |
			line := file nextLine.
			result add: (Flight  flightFromString: line) ].
	^ result
]

{ #category : #'as yet unclassified' }
Flight class >> origin: anOrigin destination: aDestination departureTime: dTime arrivalTime: aTime price: aPrice [
	"comment stating purpose of message"

	| flight |
	flight := Flight new.
	flight
		origin: anOrigin;
		destination: aDestination;
		departureTime: (Time fromString: dTime asString);
		arrivalTime: (Time fromString: aTime asString);
		price: aPrice.
	^ flight
]

{ #category : #'as yet unclassified' }
Flight class >> sortedFlightsFrom: anOrigin [
	"comment stating purpose of message"

	^ (self allFlights select: [ :e | e origin = anOrigin ])
		sorted: [ :first :second | first departureTime <= second departureTime ]
]

{ #category : #'as yet unclassified' }
Flight class >> sortedFlightsFrom: anOrigin to: aDestination [
	"comment stating purpose of message"

	
	^ (self flightsFrom: anOrigin to: aDestination)
		sorted: [ :first :second | first departureTime <= second departureTime ]
]

{ #category : #'as yet unclassified' }
Flight class >> sortedFlightsTo: aDestination [
	"comment stating purpose of message"

	^ (self allFlights 
		select: [ :e | e destination = aDestination ])
		sorted: [ :first :second | first departureTime <= second departureTime ]
]

{ #category : #comparing }
Flight >> <= aFlight [
	"compare two flights"

	^ self origin = aFlight origin
		and:
			(self destination = aFlight destination and: self departureTime <= aFlight departureTime)
]

{ #category : #comparing }
Flight >> = aFlight [
	"compare two flights"

	^ self origin asString = aFlight origin asString 
		and:
			(self destination asString = aFlight destination asString 
				and:
					(self departureTime asString = aFlight departureTime asString 
						and: (self arrivalTime asString = aFlight arrivalTime asString and: self price asString  = aFlight price asString )))
]

{ #category : #accessing }
Flight >> arrivalTime [
	^ arrivalTime
]

{ #category : #accessing }
Flight >> arrivalTime: anObject [
	arrivalTime := anObject
]

{ #category : #printing }
Flight >> asString [
	^ self origin asString , ',' , self destination asString , ','
		, self departureTime asString , ',' , self arrivalTime asString , ','
		, self myCurrency, self price asString
]

{ #category : #'as yet unclassified' }
Flight >> changeToPrevious [
	| flights ind nextF |

	flights := Flight sortedFlightsFrom: self origin to: self destination.
	ind := flights indexOf: self.
	ind > 1
		ifTrue: [ ind := ind - 1 ].
	nextF := flights at: ind.

	self
		origin: nextF origin;
		destination: nextF destination;
		departureTime: nextF departureTime;
		arrivalTime: nextF arrivalTime;
		price: nextF price
]

{ #category : #accessing }
Flight >> date [
	^ date
]

{ #category : #accessing }
Flight >> date: anObject [
	date := anObject
]

{ #category : #accessing }
Flight >> departureTime [
	^ departureTime
]

{ #category : #accessing }
Flight >> departureTime: anObject [
	departureTime := anObject
]

{ #category : #accessing }
Flight >> destination [
	^ destination
]

{ #category : #accessing }
Flight >> destination: anObject [
	destination := anObject
]

{ #category : #'instance creation' }
Flight >> from: aPlace [
	"true if my origin is aPlace"

	^ self origin = aPlace
]

{ #category : #initialization }
Flight >> initialize [

	super initialize.

	arrivalTime := nil.
	date := nil.
	departureTime := nil.
	destination := nil.
	origin := nil.
	price := nil.
]

{ #category : #'as yet unclassified' }
Flight >> myCurrency [
"currency symbol"
	^ '$'
]

{ #category : #'as yet unclassified' }
Flight >> nextFlight [
	| flights ind nextF |

	flights := Flight sortedFlightsFrom: self origin to: self destination.
	ind := flights indexOf: self.
	ind < flights size
		ifTrue: [ ind := ind + 1 ].
	nextF := flights at: ind.	
	^ nextF
]

{ #category : #accessing }
Flight >> origin [
	^ origin
]

{ #category : #accessing }
Flight >> origin: anObject [
	origin := anObject
]

{ #category : #'as yet unclassified' }
Flight >> previousFlight [
	| flights ind prevF |

	flights := Flight sortedFlightsFrom: self origin to: self destination.
	ind := flights indexOf: self.
	ind > 1
		ifTrue: [ ind := ind - 1 ].
	prevF := flights at: ind.

	^ prevF
]

{ #category : #accessing }
Flight >> price [
	^ price
]

{ #category : #accessing }
Flight >> price: anObject [
	price := anObject
]

{ #category : #printing }
Flight >> printOn: aStream [

aStream nextPutAll: self asString.
]

{ #category : #'instance creation' }
Flight >> to: aPlace [
	"true if my destination is aPlace"

	^ self destination = aPlace
]
