Class {
	#name : #FlightTest,
	#superclass : #TestCase,
	#instVars : [
		'flight'
	],
	#category : #'Optimization-Tests'
}

{ #category : #initialization }
FlightTest >> setUp [
	"comment stating purpose of message"

	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '08:04')
		arrivalTime: (Time fromString: '10:11')
		price: 95.
]

{ #category : #tests }
FlightTest >> testArrivalTime [
	"comment stating purpose of message"

	self assert: flight arrivalTime equals: (Time fromString: '10:11')
]

{ #category : #tests }
FlightTest >> testChangeToPrevious [
	"comment stating purpose of message"

	| flight1 |
	flight1 := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '06:17')
		arrivalTime: (Time fromString: '08:26')
		price: 89.
	self assert: flight changeToPrevious asString equals: flight1 asString 
]

{ #category : #tests }
FlightTest >> testDepartureTime [
	"comment stating purpose of message"

	self assert: flight departureTime equals: (Time fromString: '08:04').
	
]

{ #category : #tests }
FlightTest >> testEqual [
	"comment stating purpose of message"

	| flight1 |
	flight1 := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '08:04')
		arrivalTime: (Time fromString: '10:11')
		price: 95.
	self assert: flight = flight1.
	self assert: flight equals: flight1.
	flight1 price: 129.
	self deny: flight = flight1
]

{ #category : #tests }
FlightTest >> testNextFlight [
	"comment stating purpose of message"

	| flight1 |
	flight1 := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '09:45')
		arrivalTime: (Time fromString: '11:50')
		price: 172.
	self assert: flight nextFlight asString equals: flight1 asString
]

{ #category : #tests }
FlightTest >> testPreviousFlight [
	"comment stating purpose of message"

	| flight1 |
	flight1 := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '06:17')
		arrivalTime: (Time fromString: '08:26')
		price: 89.
	self assert: flight previousFlight  asString equals: flight1 asString
]
