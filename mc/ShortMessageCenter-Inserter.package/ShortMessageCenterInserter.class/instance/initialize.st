as yet unclassified
initialize
	super initialize.
	logger := LogStructuredLogger for: self area: #smscInserter.
	smppConnections := OrderedCollection new.