//
//  RssLink.m
//  PDX Bus
//
//  Created by Andrew Wallace on 4/4/10.



/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "RssLink.h"
#import "DebugLogging.h"

#define kFontName				@"Arial"
#define kTextViewFontSize		16.0
#define TIME_TAG 1
#define TEXT_TAG 2

@implementation RssLink

@synthesize title		= _title;
@synthesize link		= _link;
@synthesize description = _description;
@synthesize date		= _date;
@synthesize dateString	= _dateString;

- (void)dealloc
{
	self.title = nil;
	self.link  = nil;
	self.description = nil;
	self.date = nil;
	self.dateString = nil;
	
	[super dealloc];
}

- (id)init
{
	if ((self = [super init]))
	{
		self.dateString = @"";
	}
	return self;
}

#pragma mark Class methids

- (UILabel*)label:(UITableViewCell*)cell tag:(NSInteger)tag
{
	return ((UILabel*)[cell.contentView viewWithTag:tag]);
}

#pragma mark UI helpers

- (CGFloat)getTimeHeight:(ScreenType)width
{
	if (LargeScreenStyle(width))
	{
		return 24.0;
	}
	
	return 16.0;
}

- (NSString *)cellReuseIdentifier:(NSString *)identifier width:(ScreenType)width
{
	return [NSString stringWithFormat:@"%@-%d", identifier, width];
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier width:(ScreenType)width font:(UIFont*)font
{
	CGFloat TIME_FONT_SIZE				= 14.0;	
	CGFloat TIME_HEIGHT					= [self getTimeHeight:width];
//	CGFloat TEXT_FONT_SIZE				= 14.0;	
	CGFloat TEXT_HEIGHT					= 15.0;
	CGFloat LEFT_COL_OFFSET			    = 8.0;
//	CGFloat VGAP					    = 4.0;
	CGFloat COL_WIDTH					= 280;
		
	if (LargeScreenStyle(width))
	{
		TIME_FONT_SIZE = 22.0;
	}
	
	/*
	 Create an instance of UITableViewCell and add tagged subviews for the name, local time, and quarter image of the time zone.
	 */
	CGRect rect;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
													reuseIdentifier:identifier] autorelease];
	
	
	
	/*
	 Create labels for the text fields; set the highlight color so that when the cell is selected it changes appropriately.
	 */
	UILabel *label;
	
	
	rect = CGRectMake(LEFT_COL_OFFSET, VGAP, COL_WIDTH, TIME_HEIGHT);
	label = [[UILabel alloc] initWithFrame:rect];
	label.tag = TIME_TAG;
	label.font = [UIFont boldSystemFontOfSize:TIME_FONT_SIZE];
	label.adjustsFontSizeToFitWidth = YES;
	label.textColor = [UIColor blueColor];
	[cell.contentView addSubview:label];
	label.highlightedTextColor = [UIColor whiteColor];
	[label release];
	
	rect = CGRectMake(LEFT_COL_OFFSET, TIME_HEIGHT+VGAP, COL_WIDTH, TEXT_HEIGHT);
	label = [[UILabel alloc] initWithFrame:rect];
	label.tag = TEXT_TAG;
	label.font = font;
	label.adjustsFontSizeToFitWidth = NO;
	label.lineBreakMode = UILineBreakModeWordWrap;
	[cell.contentView addSubview:label];
	label.highlightedTextColor = [UIColor whiteColor];
	label.textColor = [UIColor blackColor];
	label.numberOfLines = 0;
	label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[label release];
		
			
	return cell;
}

- (void)populateCell:(UITableViewCell *)cell;
{
	UILabel * label = [self label:cell tag:TIME_TAG];

	if (self.date !=0)
	{
	
		label.text = self.dateString;
	}
	else {
		label.text = nil;
	}
	
	DEBUG_LOG(@"text width: %f\n", label.frame.size.width);
	
	label = [self label:cell tag:TEXT_TAG];
	
	label.text = self.title;
}


@end

