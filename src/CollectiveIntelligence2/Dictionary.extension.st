Extension { #name : #Dictionary }

{ #category : #'*CollectiveIntelligence2' }
Dictionary >> at: firstKey at: secondKey [
	"Return the object stored in the second dictionary returned by firstKey."

	"
	[
	| d |
	d := Dictionary new.
	d at: #top at: #below1 put: 1.
	d at: #top at: #below1 put: 2.
	d at: #top at: #below1.
	] value
	>>>
	2"

	^ self at: firstKey at: secondKey ifAbsent: [ self errorKeyNotFound ]
]

{ #category : #'*CollectiveIntelligence2' }
Dictionary >> at: firstKey at: secondKey ifAbsent: aZeroArgBlock [
	| subDictionary |
	subDictionary := self at: firstKey ifAbsent: [ ^ aZeroArgBlock value ].
	^ subDictionary at: secondKey ifAbsent: aZeroArgBlock
]

{ #category : #'*CollectiveIntelligence2' }
Dictionary >> at: firstKey at: secondKey ifAbsentPut: aZeroArgBlock [
	| subDictionary |
	subDictionary := self at: firstKey ifAbsentPut: [ Dictionary new ].
	^ subDictionary at: secondKey ifAbsentPut: aZeroArgBlock
]

{ #category : #'*CollectiveIntelligence2' }
Dictionary >> at: firstKey at: secondKey put: aValue [
	| subDictionary |
	subDictionary := self at: firstKey ifAbsentPut: [ Dictionary new ].
	^ subDictionary at: secondKey put: aValue

]
