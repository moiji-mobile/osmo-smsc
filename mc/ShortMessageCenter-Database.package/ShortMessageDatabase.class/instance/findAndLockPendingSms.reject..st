sms-read
findAndLockPendingSms: aSystemName reject: aMsisdnList
	| res now |
	now := DateAndTime now.
	res := database command: {
		'findAndModify' -> collectionForSms name.
		'query' -> [:item |
			(item lock = 0) &
			(item deliveryTime <= now) &
			(item destMSISDN notIn: aMsisdnList) ] asMongoQuery.
		'sort' -> [:item |
			item creationTime = Mongo ascending ] asMongoQuery.
		'update' -> {
			'$set' -> {
				'lockTime' -> now.
				'lockedBy' -> aSystemName.
				'lock' -> 1.
			} asDictionary.
		} asDictionary.
		'new' -> true.
		'writeConcern' -> self writeConcern.
	} asDictionary.
	logger logDebug: 'Find and lock pending' with: { 'res nil' -> res isNil. 'systemName' -> aSystemName }.
	^res ifNotNil: [res at: 'value'].