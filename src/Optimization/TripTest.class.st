Class {
	#name : #TripTest,
	#superclass : #TestCase,
	#instVars : [
		'trip'
	],
	#category : #'Optimization-Tests'
}

{ #category : #initialization }
TripTest >> setUp [
	"comment stating purpose of message"

	| flight flight1 |
	trip := Trip new.
	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '08:04')
		arrivalTime: (Time fromString: '10:11')
		price: 95.
	flight1 := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '08:23')
		arrivalTime: (Time fromString: '10:28')
		price: 149.
	trip client: 'Seymour'.
	trip flights add: flight.
	trip flights add: flight1
]

{ #category : #tests }
TripTest >> testEqual [
	| flight flight1 trip1 |
	trip1 := Trip new.
	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '08:04')
		arrivalTime: (Time fromString: '10:11')
		price: 95.
	flight1 := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '08:23')
		arrivalTime: (Time fromString: '10:28')
		price: 149.
	trip1 client: 'Seymour'.
	trip1 flights add: flight.
	trip1 flights add: flight1.
	self assert: trip equals: trip1.
	trip1 client: 'Joe'.
	self deny: trip = trip1
]

{ #category : #tests }
TripTest >> testNextDepartureFlightTrip [
	| flight flight1 trip1 |
	trip1 := Trip new.
	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '09:45')
		arrivalTime: (Time fromString: '11:50')
		price: 172.
	flight1 := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '08:23')
		arrivalTime: (Time fromString: '10:28')
		price: 149.
	trip1 client: 'Seymour'.
	trip1 flights add: flight.
	trip1 flights add: flight1.
	self assert: trip nextDepartureFlightTrip asString equals: trip1 asString
]

{ #category : #tests }
TripTest >> testNextReturnFlightTrip [
	| flight flight1 trip1 |
	trip1 := Trip new.
	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '08:04')
		arrivalTime: (Time fromString: '10:11')
		price: 95.
	flight1 := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '09:58')
		arrivalTime: (Time fromString: '11:18')
		price: 130.
	trip1 client: 'Seymour'.
	trip1 flights add: flight.
	trip1 flights add: flight1.
	self assert: trip nextReturnFlightTrip  asString equals: trip1 asString
]

{ #category : #tests }
TripTest >> testOutBoundFlightDuration [
	self assert: trip outBoundFlightDuration equals: (Time fromString: '02:07')
]

{ #category : #tests }
TripTest >> testOutboundFlightArrivalTime [
	self assert: trip outboundFlightArrivalTime  equals: (Time fromString: '10:11')
]

{ #category : #tests }
TripTest >> testOutboundFlightDepartureTime [
	self assert: trip outboundFlightDepartureTime equals: (Time fromString: '08:04')
]

{ #category : #tests }
TripTest >> testPreviousDepartureFlightTrip [
	| flight flight1 trip1 |
	trip1 := Trip new.
	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '06:17')
		arrivalTime: (Time fromString: '08:26')
		price: 89.
	flight1 := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '08:23')
		arrivalTime: (Time fromString: '10:28')
		price: 149.
	trip1 client: 'Seymour'.
	trip1 flights add: flight.
	trip1 flights add: flight1.
	self assert: trip previousDepartureFlightTrip asString equals: trip1 asString 
]

{ #category : #tests }
TripTest >> testPreviousReturnFlightTrip [
	| flight flight1 trip1 |
	trip1 := Trip new.
	flight := Flight
		origin: 'BOS'
		destination: 'LGA'
		departureTime: (Time fromString: '08:04')
		arrivalTime: (Time fromString: '10:11')
		price: 95.
	flight1 := Flight
		origin: 'LGA'
		destination: 'BOS'
		departureTime: (Time fromString: '06:39')
		arrivalTime: (Time fromString: '08:09')
		price: 86.
	trip1 client: 'Seymour'.
	trip1 flights add: flight.
	trip1 flights add: flight1.
	self assert: trip previousReturnFlightTrip asString equals: trip1 asString
]

{ #category : #tests }
TripTest >> testPrice [
	self assert: trip price equals: 244
]

{ #category : #tests }
TripTest >> testReturnFlightArrivalTime [
	self assert: trip returnFlightArrivalTime equals: (Time fromString: '10:28')
]

{ #category : #tests }
TripTest >> testReturnFlightDepartureTime [
	self assert: trip returnFlightDepartureTime equals: (Time fromString: '08:23')
]

{ #category : #tests }
TripTest >> testReturnFlightDuration [
	self assert: trip returnFlightDuration equals: (Time fromString: '02:05')
]

{ #category : #tests }
TripTest >> testTravelDuration [
	self
		assert: trip travelDuration
		equals: (Time fromString: '04:12')
]
