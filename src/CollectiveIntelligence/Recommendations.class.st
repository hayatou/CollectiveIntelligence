Class {
	#name : #Recommendations,
	#superclass : #Object,
	#instVars : [
		'critics'
	],
	#category : #CollectiveIntelligence
}

{ #category : #'private-model' }
Recommendations >> allItems [
	"list all the items in critics elements "

	| allItems |
	allItems := OrderedCollection  new.
	self critics
		do: [ :each | 
			each notes
				do: [ :e | 
					((allItems collect: #tag) includes: e tag)
						ifFalse: [ allItems add: e ] ] ].
	^ allItems
]

{ #category : #'as yet unclassified' }
Recommendations >> allItemsNotRatedBy: aCritic [
	"list all the items in critics elements not present in self items"

	| allDissimilarItems |
	allDissimilarItems := Set new.
	self critics
		do:
			[ :each | (aCritic itemsRatedOnlyBy: each) do: [ :e | allDissimilarItems add: e ] ].
	^ allDissimilarItems
]

{ #category : #'as yet unclassified' }
Recommendations >> calculateSimilarItems: n [
	"return a collection of items showing which other items they are most similar to in form of association where key are item designation and value are ordered collection of association (similarity score->item) "

	| result itemPrefs c newRec |
	result := Set new.
	newRec := Recommendations new.
	itemPrefs := self transformPrefs. 
	newRec critics: itemPrefs.
	c := 0.
	itemPrefs
		do: [ :each | 
			| scores |
			c := c + 1.
			"scores := newRec topMatchesFor: each pearsonFirst: n."
			scores := newRec topMatchesFor: each simDistFirst: n.
			result add: each cName -> scores ].
	^ result
]

{ #category : #accessing }
Recommendations >> critics [
	^ critics
]

{ #category : #accessing }
Recommendations >> critics: anObject [
	critics := anObject
]

{ #category : #'as yet unclassified' }
Recommendations >> recommendationsFor1: aCritic similarity: aSimilarityCoreFunction [
	"Gets recommendations for a critic  by using a weighted average of every other user's rankings by pearson score NB: for all pearson value (Positive + Negative)"

	| topMatches allDissItems res |
	res := OrderedCollection new.
	allDissItems := self allItemsNotRatedBy: aCritic.
	topMatches := self topMatchesFor: aCritic pearsonFirst: critics size - 1.
	allDissItems
		do: [ :e | 
			| total simSum |
			total := 0.
			simSum := 0.
			topMatches
				do: [ :v | 
					v value cName = aCritic cName
						ifFalse: [ v value notes
								do: [ :iNote | 
									iNote tag = e tag
										ifTrue: [ total := total + v key.
											simSum := simSum + (iNote value * v key) ] ] ]	"]" ].
			"v key > 0
						ifTrue: ["
			e value: simSum / total.
			res add: e ].
	^ res
]

{ #category : #'as yet unclassified' }
Recommendations >> recommendationsFor: aCritic similarity: aSimilarityCoreFunction [
	"Gets recommendations for a critic  by using a weighted average of every other user's rankings by pearson score(NB : only positive value)"

	| topMatches allDissItems res |
	res := OrderedCollection new.
	allDissItems := self allItemsNotRatedBy: aCritic.
	topMatches := self topMatchesFor: aCritic pearsonFirst: self critics size - 1.
	allDissItems
		do: [ :e | 
			| total simSum |
			total := 0.
			simSum := 0.
			topMatches
				do: [ :v | 
					v key > 0
						ifTrue: [ v value cName = aCritic cName
								ifFalse: [ v value notes
										do: [ :iNote | 
											iNote tag = e tag
												ifTrue: [ total := total + v key.
													simSum := simSum + (iNote value * v key) ] ] ] ] ].
			e value: simSum / total.
			res add: e ].
	^ res
]

{ #category : #'as yet unclassified' }
Recommendations >> recommendationsFor: aCritic similarityDist: aSimilarityCoreFunction [
	"Gets recommendations for a critic  by using a weighted average of every other user's rankings by similarity distance"

	| topMatches allDissItems res |
	res := OrderedCollection new.
	allDissItems := self allItemsNotRatedBy: aCritic.
	topMatches := self topMatchesFor: aCritic simDistFirst: critics size - 1.
	allDissItems
		do: [ :e | 
			| total simSum |
			total := 0.
			simSum := 0.
			topMatches
				do: [ :v | 
					v key > 0
						ifTrue: [ v value cName = aCritic cName
								ifFalse: [ v value notes
										do: [ :iNote | 
											iNote tag = e tag
												ifTrue: [ total := total + v key.
													simSum := simSum + (iNote value * v key) ] ] ] ] ].
			e value: simSum / total.
			res add: e ].
	^ res
]

{ #category : #'as yet unclassified' }
Recommendations >> recommendedItemsFor: aCritic [
	"give recommendations using the item similarity"

	| otherItems simItems transfPrefs res a|
	transfPrefs := self transformPrefs. a := self allItems . 
	otherItems := OrderedCollection new. 
	res := OrderedCollection  new.
	self allItems
		do: [ :e | 
			((aCritic notes collect: #tag) includes: e tag)
				ifFalse: [ otherItems add: e ] ].
	simItems := self calculateSimilarItems: transfPrefs size - 1.
	otherItems
		do: [ :e | 
			| total simSum norm |
			total := 0.
			simSum := 0.
			simItems
				do: [ :v | 
					| note |
					((aCritic notes collect: #tag) includes: v key)
						ifTrue: [ note := aCritic ratingFor: v key.
							v key = e tag
								ifFalse: [ v value
										do: [ :p | 
											p value cName = e tag
												ifTrue: [ total := total + p key.
													simSum := simSum + (note * p key) ] ] ] ] ].
			norm := simSum / total.
			res add: norm -> e ].
	^ res asOrderedCollection 
]

{ #category : #'as yet unclassified' }
Recommendations >> topMatchesFor: aCritic pearsonFirst: aNumber [
	"Return a list containing aNumber best similar critic to the receiver"

	| topMatches |
	topMatches := OrderedCollection new.
	self critics
		do: [ :each | 
			each cName = aCritic cName
				ifFalse: [ topMatches add: (aCritic pearsonScore: each) -> each ] ].
	topMatches size = 0
		ifTrue: [ ^ topMatches ].
	^ (topMatches sorted: [ :first :second | first key >= second key ]) first: aNumber
]

{ #category : #'as yet unclassified' }
Recommendations >> topMatchesFor: aCritic simDistFirst: aNumber [
	"Return a list containing aNumber best similar critic to the receiver"

	| topMatches |
	topMatches := OrderedCollection new.
	self critics
		do: [ :each | 
			each cName = aCritic cName
				ifFalse: [ topMatches add: (aCritic similarityDistance: each) -> each ] ].
	topMatches size = 0
		ifTrue: [ ^ topMatches ].
	^ (topMatches sorted: [ :first :second | first key >= second key ]) first: aNumber
]

{ #category : #'as yet unclassified' }
Recommendations >> transformPrefs [
	"swap the critic and the items to be items centeric"

	| res |
	res := Set new.
	self allItems
		do: [ :e | 
			| critic critNotes |
			critic := Critic new.
			critNotes := Set new.
			critic cName: e tag.
			self critics
				do: [ :c | 
					| not1 not2 |
					((c notes collect: #tag) includes: e tag)
						ifTrue: [ not1 := ItemNote new.
							not1 tag: c cName.
							c notes
								do: [ :a | 
									a tag = e tag
										ifTrue: [ not2 := a value ].
									not1 value: not2 ].
							critNotes add: not1 ].
					critic notes: critNotes ].
			res add: critic ].

	"self critics:  res."
	^ res
]
