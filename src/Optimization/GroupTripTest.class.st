Class {
	#name : #GroupTripTest,
	#superclass : #TestCase,
	#instVars : [
		'groupTrip'
	],
	#category : #'Optimization-Tests'
}

{ #category : #initialization }
GroupTripTest >> setUp [
	"comment stating purpose of message"

	groupTrip := GroupTrip data.

]

{ #category : #tests }
GroupTripTest >> testEarliestDepartureTime [
	"comment stating purpose of message"

	self assert: groupTrip earliestDepartureTime equals: (Time fromString: '6:19')
]

{ #category : #tests }
GroupTripTest >> testIndexOfaTrip [
	| flight2 flight3 trip1 |
	trip1 := Trip new.
	flight2 := Flight
		origin: 'CAK'
		destination: 'LGA'
		departureTime: (Time fromString: '9:15')
		arrivalTime: (Time fromString: '12:14')
		price: 247.
	flight3 := Flight
		origin: 'LGA'
		destination: 'CAK'
		departureTime: (Time fromString: '15:50')
		arrivalTime: (Time fromString: '18:45')
		price: 243.
	trip1 client: 'Zooey'.
	trip1 flights add: flight2.
	trip1 flights add: flight3.
	self assert: (groupTrip indexOfaTrip: trip1) equals: 3
]

{ #category : #tests }
GroupTripTest >> testLatestArrivalTime [
	"comment stating purpose of message"

	self assert: groupTrip latestArrivalTime equals: (Time fromString: '18:11')
]

{ #category : #tests }
GroupTripTest >> testMutate [
	"comment stating purpose of message"

	| mutate |
	mutate := groupTrip mutate. "NB peut renvoyer le meme objet!"
	self
		assert:
			((groupTrip trips collect: #asString)
				intersection: (groupTrip mutate trips collect: #asString)) size
		equals: groupTrip trips size - 1 
]

{ #category : #tests }
GroupTripTest >> testNeighborOfInDirectionForFlight [
	"comment stating purpose of message"

	| myDepartureFlight myReturnFlight |
	myDepartureFlight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '12:34')
		arrivalTime: (Time fromString: '15:02')
		price: 109.
	myReturnFlight := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '12:08')
		arrivalTime: (Time fromString: '14:05')
		price: 142.
	self
		assert:
			(groupTrip neighborOf: groupTrip trips first inDirection: 1 forFlight: 1) trips first
				flights first
		equals: myDepartureFlight nextFlight.
	self
		assert:
			(groupTrip neighborOf: groupTrip trips first inDirection: 1 forFlight: 2) trips first
				flights second
		equals: myReturnFlight nextFlight.
	self
		assert:
			(groupTrip neighborOf: groupTrip trips first inDirection: 0 forFlight: 1) trips first
				flights first
		equals: myDepartureFlight previousFlight .
	self
		assert:
			(groupTrip neighborOf: groupTrip trips first inDirection: 0 forFlight: 2) trips first
				flights second
		equals: myReturnFlight previousFlight 
]

{ #category : #tests }
GroupTripTest >> testScheduleCost [
	"comment stating purpose of message"

	self assert: groupTrip scheduleCost equals: 5583 "5285 to be verified"
]

{ #category : #tests }
GroupTripTest >> testTotalPrice [
	"comment stating purpose of message"

	self assert: groupTrip totalPrice equals: 2559	
]

{ #category : #tests }
GroupTripTest >> testTotalWait [
	"comment stating purpose of message"

	self assert: groupTrip totalWait equals: 3024	
]
