Class {
	#name : #DataClusterTest,
	#superclass : #TestCase,
	#instVars : [
		'datacluster'
	],
	#category : #'CollectiveIntelligence-Tests'
}

{ #category : #initialization }
DataClusterTest >> setUp [
	| a |
	a := {CollectiveIntelligenceData lisa.
	CollectiveIntelligenceData gene.
	CollectiveIntelligenceData claudia.
	CollectiveIntelligenceData michael.
	CollectiveIntelligenceData mick.
	CollectiveIntelligenceData toby.
	CollectiveIntelligenceData jack} collect: #asTransposedDataFrame.
	a do: [ :e | e adaptColumnOrderTo: a first columnNames ].
	datacluster := DataCluster new.
	a do: [ :d | datacluster addDataFrame: d ]
	
]

{ #category : #tests }
DataClusterTest >> testCenter [
	| result centre |
	result := DataSeries
		fromArray: #(2.0 3.7142857142857144 1.3571428571428572 4.0 2.142857142857143 2.9285714285714284)
		named: 'Claudia Puig+Gene Seymour+Jack Matthews+Lisa Rose+Michael Phillips+Mick LaSalle+Toby'.
	result
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	centre := datacluster center.
	self assert: (datacluster center hasSameContents: result).
	self assert: datacluster center name equals: result name
]

{ #category : #tests }
DataClusterTest >> testClosestTo [
	"Toby is the closest to Lisa Rose "


	self
		assert: (datacluster closestTo: datacluster dataframes first generateName) generateName1
		equals: 'Toby'
]

{ #category : #tests }
DataClusterTest >> testGenerateCentroids [
	self assert: (datacluster generateCentroids: 4) size equals: 4.
	self
		assert: (datacluster generateCentroids: 4) asOrderedCollection first class
		equals: DataSeries.
	self assert: (datacluster generateCentroids: 2) size equals: 2.
	self
		assert:
			(datacluster generateCentroids: 3) asOrderedCollection atRandom max
				<= (2*datacluster maxValue )
]

{ #category : #tests }
DataClusterTest >> testGroupBy [
	| res |
	res := datacluster groupBy: (datacluster generateCentroids: 2).
	self assert: datacluster dataframes size equals: 7.
	self assert: (datacluster groupBy: (datacluster generateCentroids: 2)) size equals: 2.
	self
		assert: (datacluster groupBy: (datacluster generateCentroids: 2)) atRandom class
		equals: DataFrame
]

{ #category : #tests }
DataClusterTest >> testHCluster [
	self assert: datacluster dataframes  size equals: 7.
	datacluster hCluster.
	self assert: datacluster dataframes  size equals: 1
]

{ #category : #tests }
DataClusterTest >> testHCluster1 [
	self assert: datacluster dataframes size equals: 7.
	datacluster hCluster1.
	self assert: datacluster dataframes size equals: 6
]

{ #category : #tests }
DataClusterTest >> testIncludesDataFrame [
	self assert: (datacluster includesDataFrame: '242391830')
]

{ #category : #tests }
DataClusterTest >> testKMeansClustering [
	self assert: (datacluster kMeansClustering: 2) size equals: 2.
	self assert: (datacluster kMeansClustering: 3) size equals: 3.
]

{ #category : #tests }
DataClusterTest >> testMaxValue [
	self assert: datacluster maxValue equals: 5.0
]

{ #category : #tests }
DataClusterTest >> testMerge [
	| james |
	james := DataSeries
		fromArray: #(2.0 3.7142857142857144 1.3571428571428572 4.0 2.142857142857143 2.9285714285714284)
		named: 'James Bond'.
	james
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	self assert: datacluster dataframes size equals: 7.
	datacluster merge: james asTransposedDataFrame asDataCluster.
	self assert: datacluster dataframes size equals: 8
]

{ #category : #tests }
DataClusterTest >> testPearsonScore [
	| gene |
	gene := CollectiveIntelligenceData gene asTransposedDataFrame asDataCluster.
	datacluster dataframes: (OrderedCollection with: datacluster dataframes first).	"keep just lisa"
	datacluster pearsonScore: gene.

	self assert: (datacluster pearsonScore: gene) equals: 0.39605901719066977
]

{ #category : #tests }
DataClusterTest >> testRefreshDistDictFor [
	| a b |
	a := {CollectiveIntelligenceData lisa.
	CollectiveIntelligenceData gene.
	CollectiveIntelligenceData claudia.
	CollectiveIntelligenceData michael.
	CollectiveIntelligenceData mick.
	CollectiveIntelligenceData toby.
	CollectiveIntelligenceData jack} collect: #asTransposedDataFrame.
	a do: [ :e | e adaptColumnOrderTo: a first columnNames ].
	b := DataCluster new.
	a do: [ :d | b addDataFrame: d ].
	self assert: b distDict size equals: 0.
	b refreshDistDictFor: (b dataframes collect: #generateName).

	self assert: (b distDict at: '242391830>11716303') equals: 0.39605901719066977.
	self assert: b distDict size equals: 21
]

{ #category : #tests }
DataClusterTest >> testSameContentsAs [
	| a newDC claudia claudia1 newDC1 |
	claudia := DataSeries fromArray: #(0.0 3.5 3.0 4.0 2.5 4.5) named: 'Claudia Puig'.
	claudia
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	claudia1 := DataSeries fromArray: #(0.0 3.5 3.0 4.0 2.5 4.5) named: 'Claudia Puig'.
	claudia1
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	a := {CollectiveIntelligenceData michael.
	CollectiveIntelligenceData lisa.
	CollectiveIntelligenceData gene.
	CollectiveIntelligenceData toby.
	CollectiveIntelligenceData mick.
	CollectiveIntelligenceData jack} collect: #asTransposedDataFrame.
	a do: [ :e | e adaptColumnOrderTo: a first columnNames ].
	newDC := DataCluster new.
	a do: [ :d | newDC addDataFrame: d ].
	newDC1 := newDC deepCopy.
	newDC addDataFrame: claudia asTransposedDataFrame.
	newDC1 addDataFrame: claudia1 asTransposedDataFrame.
	self deny: (datacluster  hasSameContents: newDC1 ).
	self assert: (datacluster  hasSameContents: newDC )
]

{ #category : #tests }
DataClusterTest >> testSelectDataFrame [
	self
		assert: (datacluster selectDataFrame: '242391830')
		equals: datacluster dataframes asOrderedCollection first
]

{ #category : #tests }
DataClusterTest >> testSort [
	self
		assert: (datacluster dataframes collect: #generateName1)
		equals:
			#('Lisa Rose' 'Gene Seymour' 'Claudia Puig' 'Michael Phillips' 'Mick LaSalle' 'Toby' 'Jack Matthews')
				asOrderedCollection.
	datacluster sort.
	self
		assert: (datacluster dataframes collect: #generateName1)
		equals:
			#('Claudia Puig' 'Gene Seymour' 'Jack Matthews' 'Lisa Rose' 'Michael Phillips' 'Mick LaSalle' 'Toby')
				asOrderedCollection
]

{ #category : #tests }
DataClusterTest >> testremoveDataFrame [
	| toby |
	toby := CollectiveIntelligenceData toby asTransposedDataFrame.
	self assert: datacluster dataframes size equals: 7.
	datacluster removeDataFrame: toby.
	self assert: datacluster dataframes size equals: 6
]
