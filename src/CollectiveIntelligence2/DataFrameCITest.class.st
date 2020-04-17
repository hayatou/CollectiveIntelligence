Class {
	#name : #DataFrameCITest,
	#superclass : #TestCase,
	#instVars : [
		'df'
	],
	#category : #CollectiveIntelligence2
}

{ #category : #'tests-raw definition' }
DataFrameCITest >> rawPearsonDistance [
	| lisa gene lisastdev genestdev lisaAve geneAve cov lisaDiff geneDiff |
	lisa := #(2.5 3.5 3.0 3.5 2.5 3.0).
	gene := #(3.0 3.5 1.5 5.0 3.5 3.0).
	lisastdev := lisa stdev.
 	genestdev := gene stdev.	
	lisaAve := lisa average.
	geneAve := gene average.
	lisaDiff := lisa collect: [ :each | each - lisaAve ].
	geneDiff := gene collect: [ :each | each - geneAve ].
	cov := (lisaDiff * geneDiff) sum.
	cov := cov / (lisa size -1).
	^ cov / (lisastdev * genestdev)
]

{ #category : #initialization }
DataFrameCITest >> setUp [
		
	df := DataFrameCI exampleFromBook.
]

{ #category : #tests }
DataFrameCITest >> testAddValue [
	| collector claudiaRowName |
	self halt.
	collector := DataCollection claudia.
	claudiaRowName := collector rowKeys
		first.
	self
		assert: (collector tagsOfRow: claudiaRowName)
		equals:
			#('Snakes on a Plane' 'Just My Luck' 'The Night Listener' 'Superman Returns' 'You, Me and Dupree')
				asOrderedCollection.
	collector
		addValue: 75
		tagged: 'new'
		inRow: claudiaRowName.
	self
		assert: (collector tagsOfRow: claudiaRowName)
		equals:
			#('Snakes on a Plane' 'Just My Luck' 'The Night Listener' 'Superman Returns' 'You, Me and Dupree' 'new')
				asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testCopyShouldCopyTheInternalStructure [
	| col col2 |
	col := DataCollection claudia.
	self halt.
	col2 := col copy.
	col
		addRow: 'New Lisa Rose'
		withTaggedValues: {('Snakes on a Plane' -> 75)}.
	self assert: col2 rowCount equals: 1
]

{ #category : #tests }
DataFrameCITest >> testCreation [
	| df1 |
	df1 := DataFrameCI new.
	df1
		addRow: 'Lisa Rose'
		withTaggedValues:
			{('Snakes on a Plane' -> 3.5).
			('Just My Luck' -> 3.0).
			('Superman Returns' -> 3.5).
			('You, Me and Dupree' -> 2.5).
			('The Night Listener' -> 3.0)}.

	self assert: df1 rowCount equals: 1
]

{ #category : #tests }
DataFrameCITest >> testCreationWithSeveralRows [
	| df1 |
	df1 := DataFrameCI new.
	df1
		addRow: 'Lisa Rose'
		withTaggedValues:
			{('Snakes on a Plane' -> 3.5).
			('Just My Luck' -> 3.0).
			('Superman Returns' -> 3.5).
			('You, Me and Dupree' -> 2.5).
			('The Night Listener' -> 3.0)}.
	df1
		addRow: 'Toby'
		withTaggedValues:
			{('Snakes on a Plane' -> 4.5).
			('You, Me and Dupree' -> 1.0).
			('Superman Returns' -> 4.0)}.
	self assert: df1 rowCount equals: 2
]

{ #category : #'tests-distance' }
DataFrameCITest >> testDistance [
	|  distance |
	distance := {(2.5 - 3.0) squared.
	(3.5 - 3.5) squared.
	(3.0 - 1.5) squared.
	(3.5 - 5) squared.
	(2.5 - 3.5) squared.
	(3.0 - 3.0) squared} sum sqrt.
	self
		assert:
			(df
				distanceBetweenRow: 'Gene Seymour'
				and: 'Lisa Rose')
		equals: distance.
	self
		assert:
			(df
				distanceBetweenRow: 'Lisa Rose'
				and: 'Gene Seymour')
		equals: distance
]

{ #category : #tests }
DataFrameCITest >> testGetRecommendationsForSimilarity [
	self
		assert: (df transposed recommendationsFor: 'Just My Luck' similarity: 1)
		equals:
			{('Michael Phillips'->4.0).
('Jack Matthews'->3.0)} asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testNotValuedTagsOfRow [
	self
		assert: (df notValuedTagsOfRow: 'Toby')
		equals:
			{'Lady in the Water' .  'Just My Luck' . 			 'The Night Listener'} asArray
]

{ #category : #'tests-distance' }
DataFrameCITest >> testPearsonDistanceBetweenRowand [
	self
		assert: (df pearsonDistanceBetweenRow: 'Gene Seymour' and: 'Lisa Rose')
		equals: 0.39605901719066977
	"	equals: self rawPearsonDistance."
	"yes should use a better way to test with some notion of precision"
]

{ #category : #'tests-raw definition' }
DataFrameCITest >> testRawCovariance [
	| lisa gene lisastdev genestdev lisaAve geneAve cov lisaDiff geneDiff |
	self halt.
	lisa := #(2.5 3.5 3.0 3.5 2.5 3.0).
	gene := #(3.0 3.5 1.5 5.0 3.5 3.0).
	lisastdev := lisa stdev.
	genestdev := gene stdev.
	lisaAve := lisa average.
	geneAve := gene average.
	lisaDiff := lisa
		collect: [ :each | each - lisaAve ].
	geneDiff := gene
		collect: [ :each | each - geneAve ].
	cov := (lisaDiff * geneDiff) sum.
	cov := cov / (lisa size - 1).
	self assert: cov equals: 0.2
]

{ #category : #tests }
DataFrameCITest >> testRecommendationsForSimilarity [
	self
		assert: (df recommendationsFor: 'Toby' similarity: 1)
		equals:
			{('Lady in the Water' -> 2.8325499182641614).
			('Just My Luck' -> 2.5309807037655645).
			('The Night Listener' -> 3.3477895267131013)} asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testRowKeysExcept [

	self
		assert: (df rowKeysExcept: 'Lisa Rose')
		equals:
			{'Gene Seymour'.'Michael Phillips' . 'Claudia Puig' .'Mick LaSalle'.
			'Jack Matthews'. 'Toby' } asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testSharedTagsBetweenAnd [
	self
		assert:
			(df
				sharedTagsBetween: 'Toby'
				and: 'Lisa Rose')
		equals:
			{'Snakes on a Plane' . 'You, Me and Dupree'.
			'Superman Returns'} asOrderedCollection
]

{ #category : #'tests-distance' }
DataFrameCITest >> testSimilarityDistanceBetweenRowand [
	| distance simDistance |
	distance := {(2.5 - 3.0 raisedTo: 2).
	(3.5 - 3.5 raisedTo: 2).
	(3.0 - 1.5 raisedTo: 2).
	(3.5 - 5 raisedTo: 2).
	(2.5 - 3.5 raisedTo: 2).
	(3.0 - 3.0 raisedTo: 2)} sum sqrt.
	simDistance := 1 / (1 + distance). 
	self
		assert: (df similarityDistanceBetweenRow: 'Gene Seymour' and: 'Lisa Rose')
		equals: simDistance
]

{ #category : #tests }
DataFrameCITest >> testSortedMatchesFor [

	self
		assert: (df sortedMatchesFor: 'Toby')
		equals:
			{(0.9912407071619299 -> 'Lisa Rose').
			(0.9244734516419049 -> 'Mick LaSalle').
			(0.8934051474415647 -> 'Claudia Puig').
			(0.66284898035987 -> 'Jack Matthews').
			(0.38124642583151164 -> 'Gene Seymour').
			(-1.0 -> 'Michael Phillips')}
				asOrderedCollection
]

{ #category : #'tests-distance' }
DataFrameCITest >> testSumOfSquaredTaggedValuesOfRow [
	self
		assert:
			(df
				sumOfSquaredTaggedValuesOfRow: 'Claudia Puig')
		equals:
			{3.5 squared.
			3 squared.
			4.5 squared.
			4 squared.
			2.5 squared} sum
]

{ #category : #'tests-distance' }
DataFrameCITest >> testSumOfSquaredTaggedValuesOfRow2 [

	self
		assert:
			(df
				sumOfSquaredTaggedValues: #('Snakes on a Plane' 'Just My Luck')
				ofRow: 'Claudia Puig')
		equals:
			{3.5 squared.
			3 squared} sum
]

{ #category : #'tests-distance' }
DataFrameCITest >> testSumOfTaggedValuesOfRow [

	self
		assert:
			(df
				sumOfTaggedValuesOfRow: 'Claudia Puig')
		equals: 17.5
]

{ #category : #'tests-distance' }
DataFrameCITest >> testSumOfTaggedValuesOfRow2 [

	self
		assert:
			(df
				sumOfTaggedValues: #('Snakes on a Plane' 'Just My Luck')
				ofRow: 'Claudia Puig')
		equals: 6.5
]

{ #category : #tests }
DataFrameCITest >> testTaggedValuesOfRow [
	self
		assert: (df taggedValuesOfRow: 'Lisa Rose')
		equals:
			{('Lady in the Water' -> 2.5).
			('Snakes on a Plane' -> 3.5).
			('Just My Luck' -> 3.0).
			('Superman Returns' -> 3.5).
			('You, Me and Dupree' -> 2.5).
			('The Night Listener' -> 3.0)} asArray
]

{ #category : #tests }
DataFrameCITest >> testTagsOfRow [

	self
		assert: (df tagsOfRow: 'Lisa Rose')
		equals:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener')
				asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testTagsOnlyDefinedBy [
	| toExclude |
	toExclude := #('Gene Seymour' 'Michael Phillips' 'Claudia Puig' 'Mick LaSalle' 'Jack Matthews').
	toExclude do: [ :e | df removeRow: e ].
	self assert: (df tagsOnlyDefinedBy: 'Toby') isEmpty.
	self
		assert: (df tagsOnlyDefinedBy: 'Lisa Rose') size
		equals: 3.
	self
		assert: (df tagsOnlyDefinedBy: 'Lisa Rose')
		equals:
			{'Lady in the Water' . 'Just My Luck' . 'The Night Listener'}
				asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testTopMatchesPearsonForFirst [
	"Todo revoir les valeurs rendu par pearson"

	self
		assert: (df topMatchesPearsonFor: (df dataframe at: df dataframe size) name first: 3)
		equals:
			{(0.99124070716192991 -> 'Lisa Rose').
			(0.92447345164190486 -> 'Mick LaSalle').
			(0.89340514744156474 -> 'Claudia Puig')} asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testTopMatchesPearsonForFirstTransposed [
	"Todo revoir les valeurs rendu par pearson"

	| res df1 |
	df1 := df transposed.
	res := df1
		topMatchesPearsonFor: (df1 dataframe at: df1 dataframe size - 2) name
		first: df1 dataframe numberOfRows - 1.
	self
		assert: res
		equals:
			{(0.6579516949597695 -> 'You, Me and Dupree').
			(0.4879500364742689 -> 'Lady in the Water').
			(0.11180339887498941 -> 'Snakes on a Plane').
			(-0.1798471947990544->'The Night Listener').
(-0.42289003161103106->'Just My Luck')} asOrderedCollection
]

{ #category : #tests }
DataFrameCITest >> testValueOfTagForRow [
	self
		assert:
			(df
				valueOfTag: 'Snakes on a Plane'
				forRow: 'Lisa Rose')
		equals: 3.5.
	self
		assert:
			(df
				valueOfTag: 'The Night Listener'
				forRow: 'Lisa Rose')
		equals: 3.0
]

{ #category : #tests }
DataFrameCITest >> testValuesForTagsForRow [

	self
		assert:
			(df
				valuesForTags: #('Snakes on a Plane' 'Just My Luck')
				forRow: 'Lisa Rose')
		equals: #(3.5 3.0).
	"pay attention the order of values is important because we should be able
	to manipulate two arrays of values to compute things."
	self
		assert:
			(df
				valuesForTags: #('Just My Luck' 'Snakes on a Plane')
				forRow: 'Lisa Rose')
		equals: #(3.0 3.5)
]

{ #category : #tests }
DataFrameCITest >> testValuesOfRow [
	|  ds |
	ds := df valuesOfRow: 'Lisa Rose'.

	self assert: ((1 to: ds size) collect: [ :i | ds at: i ]) equals: #(2.5 3.5 3 3.5 2.5 3.0)
]
