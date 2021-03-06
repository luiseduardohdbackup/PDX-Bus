//
//  MapViewWithStops.m
//  PDX Bus
//
//  Created by Andrew Wallace on 3/6/14.
//  Copyright (c) 2014 Teleportaloo. All rights reserved.
//

#import "MapViewWithStops.h"

#define kGettingStops @"getting stops"

@implementation MapViewWithStops

@synthesize stopData = _stopData;
@synthesize locId    = _locId;

- (void)dealloc
{
    self.stopData = nil;
    self.locId    = nil;
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addStops:(id<ReturnStop>)returnStop
{
    for (Stop *stop in self.stopData.itemArray)
    {
        if (![stop.locid isEqualToString:self.locId])
        {
            stop.callback = returnStop;
            [self addPin:stop];
        }
    }
}

- (void)fetchStops:(NSArray*) args
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self.backgroundTask.callbackWhenFetching backgroundThread:[NSThread currentThread]];
	[self.backgroundTask.callbackWhenFetching backgroundStart:1 title:kGettingStops];
    
	
    NSString *routeid           = [args objectAtIndex:0];
	NSString *dir               = [args objectAtIndex:1];
    id<ReturnStop> returnStop   = [args objectAtIndex:2];
	
	NSError *parseError = nil;
	
	[self.stopData getStopsForRoute:routeid
						  direction:dir
						description:@""
						 parseError:&parseError
						cacheAction:TriMetXMLUpdateCache];
	
    
    [self addStops:returnStop];
    
    [self.backgroundTask.callbackWhenFetching backgroundCompleted:self];
    
	[pool release];
}


- (void)fetchStopsInBackground:(id<BackgroundTaskProgress>) callback route:(NSString*)routeid direction:(NSString*)dir
                    returnStop:(id<ReturnStop>)returnStop
{
	self.backgroundTask.callbackWhenFetching = callback;
	self.stopData = [[[XMLStops alloc] init] autorelease];
	
	NSError *parseError = nil;
	if (!self.backgroundRefresh && [self.stopData getStopsForRoute:routeid
														 direction:dir
													   description:@""
														parseError:&parseError
													   cacheAction:TriMetXMLOnlyReadFromCache])
	{
        [self addStops:returnStop];
		[self.backgroundTask.callbackWhenFetching backgroundCompleted:self];
	}
	else
	{
		id args[] = {routeid, dir, returnStop };
		
		[NSThread detachNewThreadSelector:@selector(fetchStops:)
								 toTarget:self
							   withObject:[NSArray arrayWithObjects:args count:sizeof(args)/sizeof(id)]];
        
	}
	
}


@end
