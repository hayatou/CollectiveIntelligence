"
Im a collection of named rows of tagged values.

	DataCollection new 
		addRow: 'Lisa Rose'
		withValues:
			{('Lady in the Water' -> 2.5).
			('Snakes on a Plane' -> 3.5).
			('Just My Luck' -> 3.0).
			('Superman Returns' -> 3.5).
			('You, Me and Dupree' -> 2.5).
			('The Night Listener' -> 3.0)}; 
		yourself 
		
	defines a collection with one single row and 6 tagged values.

Implementation note: I should change the dictionary with a list of values
int  a dictionary with dictionaries as values.
"
Class {
	#name : #DataFrameCI,
	#superclass : #Object,
	#instVars : [
		'dataframe'
	],
	#category : #CollectiveIntelligence2
}

{ #category : #example }
DataFrameCI class >> claudia [
	<sampleInstance>
	| col |
	col := self new.
	col
		addRow: 'Claudia Puig'
		withTaggedValues:
			{('Snakes on a Plane' -> 3.5).
			('Just My Luck' -> 3.0).
			('The Night Listener' -> 4.5).
			('Superman Returns' -> 4.0).
			('You, Me and Dupree' -> 2.5)}.
	^ col
]

{ #category : #accessing }
DataFrameCI class >> exampleFromBook [
	| data df |
	data := DataFrameCI new.
	df := DataFrame
		fromRows:
			#(#(2.5 3.5 3.0 3.5 2.5 3.0) #(3.0 3.5 1.5 5.0 3.5 3.0) #(2.5 3.0 0.0 3.5 0.0 4.0) #(0.0 3.5 3.0 4.0 2.5 4.5) #(3.0 4.0 2.0 3.0 2.0 3.0) #(3.0 4.0 0.0 5.0 3.5 3.0) #(0.0 4.5 0.0 4.0 1.0 0.0)).
	df
		columnNames:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	df
		rowNames:
			#('Lisa Rose' 'Gene Seymour' 'Michael Phillips' 'Claudia Puig' 'Mick LaSalle' 'Jack Matthews' 'Toby').
	data dataframe: df.
	^ data
]

{ #category : #'instance creation' }
DataFrameCI class >> fromRows: anArray [
	| res |
	res := self new.
^	res dataframe: (DataFrame fromRows: anArray)
]

{ #category : #adding }
DataFrameCI >> addColumn: anArray named: columnName [
	"Add a column named columnName with a list of tagged values"

	dataframe
		addColumn: anArray
		named: columnName
]

{ #category : #adding }
DataFrameCI >> addEmptyColumnNamed: columnName [
	"Create an empty column with a given name at the end of DataFrame. The values of a new column will be set equal to nil"

	"|anArray|
anArray := Array new: self dataframe numberOfRows.
anArray ifNotEmpty: [ 
1 to: anArray size do: [:i | anArray at: i put: self defaultElemValue  ] ].
	dataframe  addColumn: anArray  named: columnName"

 dataframe addEmptyColumnNamed: columnName 
]

{ #category : #adding }
DataFrameCI >> addRow: anArray [
	"Add a row named aKey with a list of tagged values"

	dataframe
		addRow: anArray  named: (self numberOfRows + 1)
]

{ #category : #adding }
DataFrameCI >> addRow: anArray named: rowName [
	"Add a row named rowName with a list of tagged values"

	dataframe addRow: anArray named: rowName
]

{ #category : #adding }
DataFrameCI >> addRow: aRowName withTaggedValues: aCollection [
	"Add a row named aKey with a list of tagged values"

	self dataframe addRow: (Array new: self columnCount) named: aRowName.
	aCollection
		do: [ :e | 
			(self columnNames includes: e key)
				ifTrue: [ self dataframe
						at: (self dataframe indexOfRowNamed: aRowName)
						at: (self dataframe indexOfColumnNamed: e key)
						put: e value ]
				ifFalse: [ self dataframe addEmptyColumnNamed: e key.
					self dataframe
						at: (self dataframe indexOfRowNamed: aRowName)
						at: (self dataframe indexOfColumnNamed: e key)
						put: e value ] ]
]

{ #category : #accessing }
DataFrameCI >> columnCount [
	^ self dataframe numberOfColumns
]

{ #category : #accessing }
DataFrameCI >> columnNames [
	^ self dataframe columnNames
]

{ #category : #accessing }
DataFrameCI >> dataframe [
	^ dataframe
]

{ #category : #accessing }
DataFrameCI >> dataframe: anObject [
	dataframe := anObject
]

{ #category : #'as yet unclassified' }
DataFrameCI >> defaultElemValue [
^0
]

{ #category : #distances }
DataFrameCI >> differentPearsonDistanceBetweenRow: aRow1 and: aRow2 [
	"Pearson is the quotient of covariance divided by the product of standard deviations"
	
	| score  sharedTags sum1 sum2 sum1Squared sum2Squared |
	score := 0.
	sharedTags := (self sharedTagsBetween: aRow1 and: aRow2) .
	sharedTags isEmpty 
		ifTrue: [ ^ score ].
		sum1 := self sumOfTaggedValues: sharedTags ofRow: aRow1.
	sum2 := self sumOfTaggedValues: sharedTags ofRow: aRow2.
	sum1Squared := self sumOfSquaredTaggedValues: sharedTags ofRow: aRow1.
	sum2Squared := self sumOfSquaredTaggedValues: sharedTags ofRow: aRow2.
	self halt.
	
]

{ #category : #distances }
DataFrameCI >> distanceBetweenRow: aRow1 and: aRow2 [ 
	| tags sum |
	tags := self sharedTagsBetween: aRow1 and: aRow2.
	sum := 0. 
	tags do: [ :aTag |	
		sum := ((self valueOfTag: aTag forRow: aRow1) - (self valueOfTag: aTag forRow: aRow2)) squared + sum ].
	^ sum sqrt
]

{ #category : #initialization }
DataFrameCI >> initialize [
	super initialize.
	dataframe := DataFrame  new.
]

{ #category : #queries }
DataFrameCI >> notValuedTagsOfRow: aRowName [
	"return the tagged that has default values for the row named aRowName"

	| ds |
	ds := self dataframe rowAt: (self dataframe indexOfRowNamed: aRowName).
	^ ds keys select: [ :k | (ds atKey: k)= self defaultElemValue  ]
]

{ #category : #distances }
DataFrameCI >> pearsonDistance2BetweenRow: aRow1 and: aRow2 [
	"Pearson is the quotient of covariance divided by the product of standard deviations"
	
	| score  sharedTags sum1 sum2 sum1Squared sum2Squared values1 values2 productSum n num den |
	score := 0.
	sharedTags := (self sharedTagsBetween: aRow1 and: aRow2) .
	sharedTags isEmpty 
		ifTrue: [ ^ score ].
	values1 := self valuesForTags: sharedTags  forRow: aRow1.
	values2 := self valuesForTags: sharedTags  forRow: aRow2.
	sum1 := values1 sum.
	sum2 := values2 sum. 
	sum1Squared := (values1 collect: #squared) sum.
	sum2Squared := (values2 collect: #squared) sum.
	productSum := 0.
	values1 with: values2 do: [ :v1 : v2 | productSum := productSum + (v1 * v2) ].
	n := sharedTags size.
	num := productSum - (sum1 * sum2 / n).
	den := (sum1Squared - (sum1 squared / n)) * (sum2Squared - (sum2 squared / n)) sqrt.
	^ den = 0
		ifTrue: [ 0 ]
		ifFalse: [ num / den ]
]

{ #category : #distances }
DataFrameCI >> pearsonDistanceBetweenRow: aRow1 and: aRow2 [
	"Pearson is the quotient of covariance divided by the product of standard deviations"
	
	| score  sharedTags sum1 sum2 sum1Squared sum2Squared values1 values2 productSum n num den |
	score := 0.
	sharedTags := (self sharedTagsBetween: aRow1 and: aRow2) .
	sharedTags isEmpty 
		ifTrue: [ ^ score ].
	values1 := self valuesForTags: sharedTags forRow: aRow1.
	values2 := self valuesForTags: sharedTags forRow: aRow2.
	sum1 := values1 sum.
	sum2 := values2 sum. 
	sum1Squared := (values1 collect: #squared) sum.
	sum2Squared := (values2 collect: #squared) sum.
	productSum := 0.
	values1 with: values2 do: [ :v1 : v2 | productSum := productSum + (v1 * v2) ].
	n := sharedTags size.
	num := productSum - (sum1 * sum2 / n).
	den := ((sum1Squared - (sum1 squared / n)) * (sum2Squared - (sum2 squared / n))) sqrt.
	^ den = 0
		ifTrue: [ 0 ]
		ifFalse: [ num / den ]
]

{ #category : #copy }
DataFrameCI >> postCopy [

	super postCopy.
	dataframe := dataframe copy.
	
]

{ #category : #recommendation }
DataFrameCI >> recommendationsFor: aRowName similarity: aSimilarityCoreFunction [
	"Gets recommendations for a aRowName  by using a weighted average of every other user's ranked by pearson score(NB : only positive value)"

	| topMatches allNotValuedTags res |
	res := OrderedCollection new.
	allNotValuedTags := self notValuedTagsOfRow: aRowName.
	topMatches := self topMatchesPearsonFor: aRowName first: self rowCount - 1.
	allNotValuedTags
		do: [ :e | 
			| total simSum |
			total := 0.
			simSum := 0.
			topMatches
				do: [ :v | 
					v key > 0
						ifTrue: [ v value = aRowName
								ifFalse: [ | actualTagValue |
									actualTagValue := self dataframe
										at: (self dataframe indexOfRowNamed: v value)
										at: (self dataframe indexOfColumnNamed: e).
									actualTagValue = self defaultElemValue
										ifFalse: [ 
											total := total + (actualTagValue * v key).
											simSum := simSum + v key ] ] ] ].
			(simSum =0) ifFalse: [  res add: e -> (total / simSum)] ].
	^ res
]

{ #category : #removing }
DataFrameCI >> removeColumn: columnName [
	dataframe removeColumn: columnName
]

{ #category : #removing }
DataFrameCI >> removeColumnAt: aColumnNumber [
	dataframe removeColumnAt: aColumnNumber
]

{ #category : #removing }
DataFrameCI >> removeRow: rowName [
	dataframe removeRow: rowName 
]

{ #category : #removing }
DataFrameCI >> removeRowAt: aRowNumber [
	dataframe removeRowAt: aRowNumber
]

{ #category : #accessing }
DataFrameCI >> row: rowName [

^ self dataframe row: rowName
]

{ #category : #accessing }
DataFrameCI >> rowCount [
	^ self dataframe numberOfRows
]

{ #category : #accessing }
DataFrameCI >> rowKeys [
	^ self dataframe rowNames 
]

{ #category : #queries }
DataFrameCI >> rowKeysExcept: aRowName [
	"Returns the row keys of the receiver except the argument."

	^ self rowKeys asOrderedCollection 
		remove: aRowName ifAbsent: [  ];
		yourself
]

{ #category : #accessing }
DataFrameCI >> rowNames [
	^ self dataframe rowNames
]

{ #category : #queries }
DataFrameCI >> sharedTagsBetween: rowOne and: rowTwo [
	"Returns the tags shared between two rows"
	^ (self tagsOfRow: rowOne) intersection: (self tagsOfRow: rowTwo)
]

{ #category : #distances }
DataFrameCI >> similarityDistanceBetweenRow: aRow1 and: aRow2 [
	^ 1 / (1 + (self distanceBetweenRow: aRow1 and: aRow2))
]

{ #category : #ranking }
DataFrameCI >> sortedMatchesFor: aKey [
	"Return a list containing aNumber similar tagged values that aRow"

	| topMatches similarities |
	topMatches := OrderedCollection new.
	similarities := (self rowKeysExcept: aKey) 
		collect: [ :anotherKey | 
			(self pearsonDistanceBetweenRow: aKey and: anotherKey) -> anotherKey].
	^ similarities sorted: [ :first :second | first key >= second key ]
]

{ #category : #operations }
DataFrameCI >> sumOfSquaredTaggedValues: tags ofRow: aRowName [

	^ tags
		inject: 0
		into: [ :subTotal :next | 
			subTotal
				+ (self valueOfTag: next forRow: aRowName) squared ]
]

{ #category : #operations }
DataFrameCI >> sumOfSquaredTaggedValuesOfRow: aRowName [
	"Returns the sum of the squared tagged values of the row, aRowName"

	^ (self valuesOfRow: aRowName)
		inject: 0
		into: [ :subTotal :next | subTotal + next squared ]
]

{ #category : #operations }
DataFrameCI >> sumOfTaggedValues: tags ofRow: aRowName [
	"Returns the sum of the tagged values designated by tags of the row, aKey "

	^ tags
		inject: 0
		into: [ :subTotal :next | subTotal + (self valueOfTag: next forRow: aRowName) ]
]

{ #category : #operations }
DataFrameCI >> sumOfTaggedValuesOfRow: aRowName [
	"Returns the sum of the tagged values of the row, aRowName"

	^ (self valuesOfRow: aRowName)
		inject: 0
		into: [ :subTotal :next | subTotal + next value ]
]

{ #category : #queries }
DataFrameCI >> taggedValuesOfRow: aRowName [
	"return the tagged values (pairs: tag values) of the receiver for the row named"

	| ds |
	ds := self dataframe rowAt: (self dataframe indexOfRowNamed: aRowName).
	^ (ds keys) collect: [ :k | k -> (ds atKey: k) ]
]

{ #category : #queries }
DataFrameCI >> tagsOfRow: aRowName [
	"The value of a row are tagged values, i.e., { $a -> 33. $b -> 55}. valueNamesOf: returns the tags #($a $b) asOrderedCollection"

	| tags row |
	tags := OrderedCollection new.
	row := self dataframe row: aRowName.
	1 to: row size do: [ :i | 
		(row at: i)
			= DataFrameCI new defaultElemValue
			ifFalse: [ tags add: (row keys at: i) ] ].
	^ tags
]

{ #category : #'advanced queries' }
DataFrameCI >> tagsOnlyDefinedBy: aRowKey [
	"Returns the unique tags of the argument by comparing its tags with all the tags of the receiver's row."

	| valueNames |
	valueNames := self tagsOfRow: aRowKey.
	(self rowKeysExcept: aRowKey)
		do: [ :eachRowName | 
			| currentNames |
			currentNames := self tagsOfRow: eachRowName.
			valueNames copy
				do: [ :v | 
					(currentNames includes: v)
						ifTrue: [ valueNames remove: v ].
					valueNames isEmpty
						ifTrue: [ ^ OrderedCollection new ] ] ].
	^ valueNames
]

{ #category : #recommendation }
DataFrameCI >> topMatchesPearsonFor: aRowName first: aNumber [
	"Return a list containing aNumber best similar critic to the receiver"

	| topMatches |
	topMatches := OrderedCollection new.
	self dataframe
		do: [ :each | 
			each name = aRowName
				ifFalse: [ topMatches add: (self pearsonDistanceBetweenRow: aRowName and: each name) -> each name] ].
	topMatches size = 0
		ifTrue: [ ^ topMatches ].
	^ (topMatches sorted: [ :first :second | first key >= second key ]) first: aNumber
]

{ #category : #'as yet unclassified' }
DataFrameCI >> transposed [
 |newDF|
newDF:= self class new.
newDF dataframe: self dataframe transposed .
^ newDF .
]

{ #category : #queries }
DataFrameCI >> valueOfTag: aColunmName forRow: aRowName [
	"Returns the value of a tag for a given row"

	^ dataframe
		at:
			
			(self dataframe
				indexOfRowNamed: aRowName)
		at:
		(self dataframe
				indexOfColumnNamed: aColunmName)

	"((self valuesOfRow: aRowName)
		detect: [ :each | each key = aTag ]
		ifNone: [ self error: 'No values' ]) value"
]

{ #category : #queries }
DataFrameCI >> valuesForTags: tags forRow: aRowName [
	"Returns the values of the row whose keys are listed in the tags argument. Pay attention that the order of the result is based on the order of the tags. This order is important to be able to then later do operations on different series."

	"this implementation works but it does not respect the order of the tags 
	^ (self taggedValuesOfRow: aKey) 
			select: [ :each | tags includes: each key ]  
			thenCollect: [ :each | each value ]
			"

	^ tags
		collect:
			[ :aTag | self valueOfTag: aTag forRow: aRowName ]
]

{ #category : #queries }
DataFrameCI >> valuesOfAColumn: aColumnName [
	"return the values (ag values) of the receiver for the row named"

	^ dataframe columnAt: (self dataframe indexOfColumnNamed: aColumnName)
]

{ #category : #queries }
DataFrameCI >> valuesOfRow: aRowName [
	"return the values (ag values) of the receiver for the row named"

	^ dataframe rowAt: ( self dataframe indexOfRowNamed: aRowName)
]
