//
//  AlarmFetchArrivalsTask.h
//  PDX Bus
//
//  Created by Andrew Wallace on 1/29/11.
//  Copyright 2011. All rights reserved.
//

/*

``The contents of this file are subject to the Mozilla Public License
     Version 1.1 (the "License"); you may not use this file except in
     compliance with the License. You may obtain a copy of the License at
     http://www.mozilla.org/MPL/

     Software distributed under the License is distributed on an "AS IS"
     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
     License for the specific language governing rights and limitations
     under the License.

     The Original Code is PDXBus.

     The Initial Developer of the Original Code is Andrew Wallace.
     Copyright (c) 2008-2011 Andrew Wallace.  All Rights Reserved.''

 */

#import <Foundation/Foundation.h>
#import "XMLDepartures.h"
#import "AlarmTask.h"

// @interface AlarmFetchArrivalsTask;


#define DEBUG_BACKGROUND_FETCH



@interface AlarmFetchArrivalsTask : AlarmTask  {

	NSString *_block;
	
	
	XMLDepartures *_departures;
	Departure	  *_lastFetched;
	TriMetTime _queryTime;
	
	uint _minsToAlert;	
}


@property (nonatomic, retain) NSString * block;
@property (nonatomic, retain) XMLDepartures * departures;
@property (nonatomic) uint minsToAlert;
@property (retain) Departure	  *lastFetched;

- (void) startTask;

@end