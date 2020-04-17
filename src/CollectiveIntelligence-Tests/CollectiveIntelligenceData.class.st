Class {
	#name : #CollectiveIntelligenceData,
	#superclass : #TestCase,
	#category : #'CollectiveIntelligence-Tests'
}

{ #category : #example }
CollectiveIntelligenceData class >> claudia [
	| claudia |
	claudia := DataSeries fromArray: #(0.0 3.5 3.0 4.0 2.5 4.5) named: 'Claudia Puig'.
	claudia
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ claudia
]

{ #category : #accessing }
CollectiveIntelligenceData class >> exampleFromBook [
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

{ #category : #'as yet unclassified' }
CollectiveIntelligenceData class >> gene [
	| gene |
	gene := DataSeries fromArray: #(3.0 3.5 1.5 5.0 3.5 3.0)  named: 'Gene Seymour'.
	gene
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ gene
]

{ #category : #example }
CollectiveIntelligenceData class >> jack [
	| jack |
	jack := DataSeries fromArray: #(3.0 4.0 0.0 5.0 3.5 3.0) named: 'Jack Matthews'.
	jack
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ jack
]

{ #category : #'as yet unclassified' }
CollectiveIntelligenceData class >> lisa [
	"comment stating purpose of message"

	| lisa |
	lisa := DataSeries fromArray: #(2.5 3.5 3.0 3.5 2.5 3.0) named: 'Lisa Rose'.
	lisa
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ lisa
]

{ #category : #example }
CollectiveIntelligenceData class >> michael [
	| michael |
	michael := DataSeries fromArray: #(2.5 3.0 0.0 3.5 0.0 4.0) named: 'Michael Phillips'.
	michael
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ michael
]

{ #category : #example }
CollectiveIntelligenceData class >> mick [
	| mick |
	mick := DataSeries fromArray: #(3.0 4.0 2.0 3.0 2.0 3.0) named: 'Mick LaSalle'.
	mick
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ mick
]

{ #category : #'as yet unclassified' }
CollectiveIntelligenceData class >> toby [
	| toby |
	toby := DataSeries fromArray: #(0.0 4.5 0.0 4.0 1.0 0.0) named: 'Toby'.
	toby
		keys:
			#('Lady in the Water' 'Snakes on a Plane' 'Just My Luck' 'Superman Returns' 'You, Me and Dupree' 'The Night Listener').
	^ toby
]
