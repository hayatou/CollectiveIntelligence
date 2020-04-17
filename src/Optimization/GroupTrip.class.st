Class {
	#name : #GroupTrip,
	#superclass : #Object,
	#instVars : [
		'destination',
		'trips'
	],
	#category : #Optimization
}

{ #category : #accessing }
GroupTrip class >> data [
	| flights trip trip1 trip2 trip3 trip4 trip5 gtrip |
	trip := Trip new.
	trip1 := Trip new.
	trip2 := Trip new.
	trip3 := Trip new.
	trip4 := Trip new.
	trip5 := Trip new.
	flights := Flight   allFlights.
	trip client: 'Seymour'.
	trip flights add: (flights at: 70).
	trip flights add: (flights at: 69).
	trip1 client: 'Franny'.
	trip1 flights add: (flights at: 90).
	trip1 flights add: (flights at: 85).
	trip2 client: 'Zooey'.
	trip2 flights add: (flights at: 106).
	trip2 flights add: (flights at: 113).
	trip3 client: 'Walt'.
	trip3 flights add: (flights at: 54).
	trip3 flights add: (flights at: 51).
	trip4 client: 'Buddy'.
	trip4 flights add: (flights at: 32).
	trip4 flights add: (flights at: 33).
	trip5 client: 'Les'.
	trip5 flights add: (flights at: 14).
	trip5 flights add: (flights at: 1).
	gtrip := GroupTrip new.
	gtrip trips add: trip.
	gtrip trips add: trip1.
	gtrip trips add: trip2.
	gtrip trips add: trip3.
	gtrip trips add: trip4.
	gtrip trips add: trip5.
	^ gtrip
]

{ #category : #accessing }
GroupTrip class >> data1 [
	| flights trip trip1 trip2 trip3 trip4 trip5 gtrip |
	trip := Trip new.
	trip1 := Trip new.
	trip2 := Trip new.
	trip3 := Trip new.
	trip4 := Trip new.
	trip5 := Trip new.
	flights := Flight allFlights.
	trip client: 'Seymour'.
	trip flights add: (flights at: 72).
	trip flights add: (flights at: 67).
	trip1 client: 'Franny'.
	trip1 flights add: (flights at: 92).
	trip1 flights add: (flights at: 87).
	trip2 client: 'Zooey'.
	trip2 flights add: (flights at: 104).
	trip2 flights add: (flights at: 113).
	trip3 client: 'Walt'.
	trip3 flights add: (flights at: 54).
	trip3 flights add: (flights at: 53).
	trip4 client: 'Buddy'.
	trip4 flights add: (flights at: 34).
	trip4 flights add: (flights at: 33).
	trip5 client: 'Les'.
	trip5 flights add: (flights at: 12).
	trip5 flights add: (flights at: 1).
	gtrip := GroupTrip new.
	gtrip trips add: trip.
	gtrip trips add: trip1.
	gtrip trips add: trip2.
	gtrip trips add: trip3.
	gtrip trips add: trip4.
	gtrip trips add: trip5.
	^ gtrip
]

{ #category : #'as yet unclassified' }
GroupTrip class >> randomGroupTrip [
	"comment stating purpose of message"

	| sol |
	sol := GroupTrip new.
	sol destination: Optimization  destination.
	Optimization peoples
		do: [ :e | 
			| trip |
			trip := Trip tripFor: e first.
			sol addTrip: trip ].
	^ sol
]

{ #category : #accessing }
GroupTrip >> addTrip: anObject [
	trips add: anObject
]

{ #category : #converting }
GroupTrip >> asString [
	"comment stating purpose of message"
	|str|
	str := ''.
self trips do: [ :e |
	str:=str,e asString , String cr ].
^str
]

{ #category : #'as yet unclassified' }
GroupTrip >> crossOver: aGroupTrip [
"Take some of my trips an some trips in aGroupTrip to do new solution"
	| i nGTrip myTrips yourTrips newTrips size |
	size := self trips size.
	i := (1 to: size - 1) atRandom.
	myTrips := self trips postCopyFrom: 1 to: i.
	yourTrips := aGroupTrip trips postCopyFrom: i + 1 to: size.
	newTrips := myTrips
		addAll: yourTrips;
		yourself.
	nGTrip := GroupTrip new.
	nGTrip destination: self destination.
	nGTrip trips: newTrips.
	^ nGTrip
]

{ #category : #accessing }
GroupTrip >> destination [
	^ destination
]

{ #category : #accessing }
GroupTrip >> destination: anObject [
	destination := anObject
]

{ #category : #'as yet unclassified' }
GroupTrip >> earliestDepartureTime [
	"give the flight time of the first person to leave"

	| earliestDeparture |
	earliestDeparture := self trips first returnFlightDepartureTime.
	self trips
		do: [ :t | 
			t returnFlightDepartureTime < earliestDeparture
				ifTrue: [ earliestDeparture := t returnFlightDepartureTime ] ].
	^ earliestDeparture	
]

{ #category : #accessing }
GroupTrip >> indexOfaTrip: aTrip [
	"give the index of the given trip in my trips else return 0"

	^ self trips indexOf: aTrip

]

{ #category : #initialization }
GroupTrip >> initialize [
	super initialize.
	destination := 'LGA'.
	trips := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GroupTrip >> latestArrivalTime [
	| latestArrival |
	latestArrival := self trips first outboundFlightArrivalTime.
	self trips
		do: [ :t | 
			t outboundFlightArrivalTime > latestArrival
				ifTrue: [ latestArrival := t outboundFlightArrivalTime ] ].
	^ latestArrival	
]

{ #category : #accessing }
GroupTrip >> mutate [
	"select and mutate a random trip in my trips"

	| nGTrip nTrip i |
	i := Random new nextInt: self trips size.
	nGTrip := self deepCopy.
	nTrip := (self trips at: i) mutate: (Random new nextInt: 2).
	nGTrip trips
		at: i put: nTrip;
		yourself.
	^ nGTrip
]

{ #category : #'as yet unclassified' }
GroupTrip >> neighbor: aTrip [
	| neighb ngTrip tr|
	neighb := Trip tripFor: aTrip client.
	tr := OrderedCollection withAll: self trips.
	tr remove: aTrip.
	tr
		add: neighb beforeIndex: (self indexOfaTrip: aTrip);
		yourself.
	ngTrip := GroupTrip new.
	ngTrip trips: tr.
	^ ngTrip
]

{ #category : #'as yet unclassified' }
GroupTrip >> neighborOf: aTrip inDirection: aDirection forFlight: aFlight [
"return a trip where the departureFlight or returnFlight was changed accordingly to aFlight. An aDirection is used to chose the next or the previous flight"
	|  neighb ngTrip tr |
	aFlight = 1
		ifTrue: [ aDirection = 1
				ifTrue: [ neighb := aTrip nextDepartureFlightTrip ]
				ifFalse: [ neighb := aTrip previousDepartureFlightTrip ] ]
		ifFalse: [ aDirection = 1
				ifTrue: [ neighb := aTrip nextReturnFlightTrip ]
				ifFalse: [ neighb := aTrip previousReturnFlightTrip ] ].
	tr := OrderedCollection withAll: self trips.
	tr remove: aTrip.
	tr
		add: neighb beforeIndex: (self indexOfaTrip: aTrip);
		yourself.
	ngTrip := GroupTrip new.
	ngTrip trips: tr.
	^ ngTrip
]

{ #category : #'as yet unclassified' }
GroupTrip >> neighbors [
	| neighbors |
	neighbors := OrderedCollection new.
	self trips do: [ :e | neighbors add: (self neighbor: e) ].
	^ neighbors
]

{ #category : #'as yet unclassified' }
GroupTrip >> neighbors: aGroupTrip [
	| neighbors |
	neighbors := OrderedCollection new.
	aGroupTrip trips do: [ :e | neighbors add: (self neighbor: e) ].
	^ neighbors
]

{ #category : #'as yet unclassified' }
GroupTrip >> scheduleCost [
	"comment stating purpose of message"

	^ self totalPrice asInteger	+ self totalWait asInteger
]

{ #category : #accessing }
GroupTrip >> totalPrice [

	^ (self trips collect: #price) sum
]

{ #category : #accessing }
GroupTrip >> totalWait [
	| totalWait   latestarrival earliestdep |
	latestarrival := self latestArrivalTime.
	earliestdep := self earliestDepartureTime.
	totalWait := 0.
	(self trips collect: #outboundFlightArrivalTime)
		do: [ :e | 
			| waitingTime minutesTowait |
			waitingTime := latestarrival subtractTime: e.
			minutesTowait := waitingTime hours * 60 + waitingTime minutes.
			totalWait := totalWait + minutesTowait ].
	(self trips collect: #returnFlightDepartureTime)
		do: [ :r | 
			| waitingTime minutesTowait |
			waitingTime := r subtractTime: earliestdep.
			minutesTowait := waitingTime hours * 60 + waitingTime minutes.
			totalWait := totalWait + minutesTowait ].
	^ totalWait
]

{ #category : #accessing }
GroupTrip >> trips [
	^ trips
]

{ #category : #accessing }
GroupTrip >> trips: anObject [
	trips := anObject
]
