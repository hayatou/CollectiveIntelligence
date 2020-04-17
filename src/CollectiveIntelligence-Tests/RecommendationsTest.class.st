Class {
	#name : #RecommendationsTest,
	#superclass : #TestCase,
	#instVars : [
		'recommendations'
	],
	#category : #'CollectiveIntelligence-Tests'
}

{ #category : #accessing }
RecommendationsTest >> recommendations [
	^ recommendations
]

{ #category : #accessing }
RecommendationsTest >> recommendations: anObject [
	recommendations := anObject
]

{ #category : #'as yet unclassified' }
RecommendationsTest >> setUp [
	"comment stating purpose of message"

	| lisa gene michael claudia mick jack toby |
	lisa := Critic
		criticName: 'Lisa Rose'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 2.5)
				with: (ItemNote tag: 'Snakes on a Plane' value: 3.5)
				with: (ItemNote tag: 'Just My Luck' value: 3.0)
				with: (ItemNote tag: 'Superman Returns' value: 3.5)
				with: (ItemNote tag: 'You, Me and Dupree' value: 2.5)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)).
	gene := Critic
		criticName: 'Gene Seymour'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 3.0)
				with: (ItemNote tag: 'Snakes on a Plane' value: 3.5)
				with: (ItemNote tag: 'Just My Luck' value: 1.5)
				with: (ItemNote tag: 'Superman Returns' value: 5.0)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)
				with: (ItemNote tag: 'You, Me and Dupree' value: 3.5)).
	michael := Critic
		criticName: 'Michael Phillips'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 2.5)
				with: (ItemNote tag: 'Snakes on a Plane' value: 3.0)
				with: (ItemNote tag: 'Superman Returns' value: 3.5)
				with: (ItemNote tag: 'The Night Listener' value: 4.0)).
	claudia := Critic
		criticName: 'Claudia Puig'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Snakes on a Plane' value: 3.5)
				with: (ItemNote tag: 'Just My Luck' value: 3.0)
				with: (ItemNote tag: 'The Night Listener' value: 4.5)
				with: (ItemNote tag: 'Superman Returns' value: 4.0)
				with: (ItemNote tag: 'You, Me and Dupree' value: 2.5)).
	mick := Critic
		criticName: 'Mick LaSalle'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 3.0)
				with: (ItemNote tag: 'Snakes on a Plane' value: 4.0)
				with: (ItemNote tag: 'Just My Luck' value: 2.0)
				with: (ItemNote tag: 'Superman Returns' value: 3.0)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)
				with: (ItemNote tag: 'You, Me and Dupree' value: 2.0)).
	jack := Critic
		criticName: 'Jack Matthews'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 3.0)
				with: (ItemNote tag: 'Snakes on a Plane' value: 4.0)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)
				with: (ItemNote tag: 'Superman Returns' value: 5.0)
				with: (ItemNote tag: 'You, Me and Dupree' value: 3.5)).
	toby := Critic
		criticName: 'Toby'
		notes:
			(OrderedCollection
				with: (ItemNote tag: 'Snakes on a Plane' value: 4.5)
				with: (ItemNote tag: 'You, Me and Dupree' value: 1.0)
				with: (ItemNote tag: 'Superman Returns' value: 4.0)).
	recommendations := Recommendations new.
	recommendations
		critics:
			(OrderedCollection new
				add: lisa;
				add: gene;
				add: michael;
				add: claudia;
				add: mick;
				add: jack;
				add: toby;
				yourself)
]

{ #category : #tests }
RecommendationsTest >> testAllItemsNotRatedBy [
	"comment stating purpose of message"

	self
		assert:
			((recommendations allItemsNotRatedBy: recommendations critics last) collect: #tag)
		equals:
			((OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 2.5)
				with: (ItemNote tag: 'Just My Luck' value: 3.0)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)) collect: #tag) asSet.
	recommendations critics last
		notes:
			(recommendations critics last notes
				removeAt: 2;
				yourself).
	self assert: recommendations critics last notes size equals: 2.
	self
		assert:
			((recommendations allItemsNotRatedBy: recommendations critics last) collect: #tag)
		equals:
			((OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 2.5)
				with: (ItemNote tag: 'Just My Luck' value: 3.0)
				with: (ItemNote tag: 'You, Me and Dupree' value: 1.0)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)) collect: #tag) asSet
]

{ #category : #tests }
RecommendationsTest >> testCalculateSimilarItems [
	"comment stating purpose of message"

	| result |
	result := recommendations calculateSimilarItems: recommendations transformPrefs size -1.
	self assert: result asOrderedCollection first key equals: 'Lady in the Water'.
	self assert: result asOrderedCollection first value first key equals: 0.4.
	self assert: result asOrderedCollection first value first value cName equals: 'You, Me and Dupree'.
	self assert: result asOrderedCollection first value second key equals: 0.2857142857142857.
	self assert: result asOrderedCollection first value second value cName equals: 'The Night Listener'
]

{ #category : #tests }
RecommendationsTest >> testRecommendationsForSimilarity [
	""

	| est res |
	est := recommendations recommendationsFor: recommendations critics last similarity: 1.
	res := OrderedCollection
		with: (ItemNote tag: 'Lady in the Water' value: 2.8325499182641614)
		with: (ItemNote tag: 'The Night Listener' value: 3.3477895267131013)
		with: (ItemNote tag: 'Just My Luck' value: 2.5309807037655645).
	self assert: est first value equals: res first value.
	self assert: est second value equals: res second value.
	self assert: est last value equals: res last value
]

{ #category : #tests }
RecommendationsTest >> testRecommendationsForSimilarityDist [
	""

	| est res |
	est := recommendations
		recommendationsFor: recommendations critics last
		similarityDist: 1.
	res := OrderedCollection
		with: (ItemNote tag: 'Lady in the Water' value: 2.7561242939959363)
		with: (ItemNote tag: 'The Night Listener' value: 3.500247840141588)
		with: (ItemNote tag: 'Just My Luck' value: 2.461988486074374).
	self assert: est first value equals: res first value.
	self assert: est second value equals: res second value.
	self assert: est last value equals: res last value
]

{ #category : #tests }
RecommendationsTest >> testRecommendedItemsFor [
	"comment stating purpose of message"

	| toby recom |
	toby := recommendations critics last.
	recommendations transformPrefs.
	recom := recommendations recommendedItemsFor: toby. 
	self assert: recom size equals: 3.
	self
		assert:
			((recom collect: #key)
				includesAll: {3.182634730538922 . 2.5983318700614575 . 2.4730878186968837}).
	self
		assert:
			(((recom collect: #value) collect: #tag)
				includesAll: {'Lady in the Water' . 'Just My Luck' . 'The Night Listener'}).
	self assert: recom first key equals: 2.4730878186968837.
	self assert: recom first value tag equals: 'Lady in the Water'
]

{ #category : #'as yet unclassified' }
RecommendationsTest >> testTopMatchesForPearsonFirst [
	"Todo revoir les valeurs rendu par pearson"

	| res |
	res := recommendations topMatchesFor: recommendations critics last pearsonFirst: 3.
	self assert: res first value cName equals: 'Lisa Rose'.
	self assert: res first key equals: 0.99124070716192991.	"i got 0.3702717053044337 it's a correct value when i check manually"
	self assert: res second value cName equals: 'Mick LaSalle'.
	self assert: res second key equals: 0.92447345164190486.	"i got 0.3453312187190115 it's a correct value when i check manually"
	self assert: res last value cName equals: 'Claudia Puig'.
	self assert: res last key equals: 0.89340514744156474	"i got 0.33372584991801285 it's a correct value when i check manually"
	"i also remarked all these numbers are proportionnal 0.99124070716192991/0.3702717053044337 = 0.92447345164190486/0.3453312187190115=0.89340514744156474/0.33372584991801285"
]

{ #category : #tests }
RecommendationsTest >> testTopMatchesForSimDistFirst [
	""

	| res |
	res := recommendations topMatchesFor: recommendations critics last simDistFirst: 3.
	self assert: res first value cName equals: 'Lisa Rose'.
	self assert: res first key equals: 0.99124070716192991.
	self assert: res second value cName equals: 'Mick LaSalle'.
	self assert: res second key equals: 0.92447345164190486.
	self assert: res last value cName equals: 'Claudia Puig'.
	self assert: res last key equals: 0.89340514744156474
]

{ #category : #'as yet unclassified' }
RecommendationsTest >> testTransformPrefsRecommendations [
	"comment stating purpose of message"

	| est res jml movies recMovies |
	recMovies := Recommendations new.
	movies := recommendations transformPrefs.
	recMovies critics: movies.
	jml := movies asOrderedCollection third.
	est := recMovies recommendationsFor1: jml similarity: 1.
	res := OrderedCollection
		with: (ItemNote tag: 'Michael Phillips' value: 4.0)
		with: (ItemNote tag: 'Jack Matthews' value: 3.0).
	self assert: est first value equals: res first value.
	self assert: est first tag equals: res first tag.
	self assert: est second value equals: res second value.
	self assert: est second tag equals: res second tag
]

{ #category : #'as yet unclassified' }
RecommendationsTest >> testTransformPrefsTopMatches [
	"comment stating purpose of message"

	| res movies recMovies |
	recMovies := Recommendations new.
	movies := recommendations transformPrefs.
	recMovies critics: movies.
	res := recMovies topMatchesFor: recMovies critics asOrderedCollection fourth pearsonFirst: 5.
	self assert: res first value cName equals: 'You, Me and Dupree'.
	self assert: res first key equals: 0.657.	"i got 0.3673281980189863 it's a correct value when i check manually"
	self assert: res second value cName equals: 'Lady in the Water'.
	self assert: res second key equals: 0.487.	"i got 0.2608202654786518 it's a correct value when i check manually"
	self assert: res third value cName equals: 'Snakes on a Plane'.
	self assert: res third key equals: 0.111.	"i got 0.05976143046671964 it's a correct value when i check manually"
	self assert: res fourth value cName equals: 'The Night Listener'.
	self assert: res fourth key equals: -0.179.	"i got -0.09613236927292199 it's a correct value when i check manually"
	self assert: res fifth value cName equals: 'Just My Luck'.
	self assert: res fifth key equals: -0.422	"i got -0.2859258475986718 it's a correct value when i check manually"
]

{ #category : #'as yet unclassified' }
RecommendationsTest >> testallItems [
	"comment stating purpose of message"

	| res |
	res := OrderedCollection
		with: (ItemNote tag: 'Lady in the Water' value: 2.5)
		with: (ItemNote tag: 'Snakes on a Plane' value: 3.5)
		with: (ItemNote tag: 'Just My Luck' value: 3.0)
		with: (ItemNote tag: 'Superman Returns' value: 3.5)
		with: (ItemNote tag: 'You, Me and Dupree' value: 2.5)
		with: (ItemNote tag: 'The Night Listener' value: 3.0).
	self
		assert: (recommendations allItems collect: #tag) asSet
		equals: (res collect: #tag) asSet.
	recommendations critics last
		notes:
			(recommendations critics last notes
				removeAt: 2;
				yourself).
	self assert: recommendations critics last notes size equals: 2.
	self
		assert: (recommendations allItems collect: #tag) asSet
		equals:
			((OrderedCollection
				with: (ItemNote tag: 'Lady in the Water' value: 2.5)
				with: (ItemNote tag: 'Snakes on a Plane' value: 3.5)
				with: (ItemNote tag: 'Just My Luck' value: 3.0)
				with: (ItemNote tag: 'Superman Returns' value: 3.5)
				with: (ItemNote tag: 'You, Me and Dupree' value: 2.5)
				with: (ItemNote tag: 'The Night Listener' value: 3.0)) collect: #tag) asSet
]
