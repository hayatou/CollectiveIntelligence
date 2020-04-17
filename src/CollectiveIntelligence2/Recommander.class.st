"
I'm gathering ranking and recommandation algorithm. 
"
Class {
	#name : #Recommander,
	#superclass : #Object,
	#instVars : [
		'aTableCollector'
	],
	#category : #CollectiveIntelligence2
}

{ #category : #'instance creation' }
Recommander class >> on: aTableCollector [
	^ self new 
		tableCollector: aTableCollector;
		yourself
]

{ #category : #ranking }
Recommander >> sortedMatchesFor: aKey [
	"Return a list containing aNumber similar tagged values that aRow"

	| topMatches similarities |
	topMatches := OrderedCollection new.
	similarities := (self rowKeysExcept: aKey) 
		collect: [ :anotherKey | 
			(self pearsonDistanceBetweenRow: aKey and: anotherKey) -> anotherKey].
	^ similarities sorted: [ :first :second | first key >= second key ]
]
