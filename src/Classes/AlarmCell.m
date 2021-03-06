//
//  AlarmCell.m
//  PDX Bus
//
//  Created by Andrew Wallace on 2/20/11.
//  Copyright 2011. All rights reserved.
//



/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "AlarmCell.h"

#define ALARM_NAME_TAG	1
#define ALARM_TOGO_TAG	2


@implementation AlarmCell

@dynamic fired;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        self.fired = false;
        _state = 0;
    }
    return self;
}

- (bool)fired
{
    return _fired;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}

- (void)updateState:(UITableViewCellStateMask)state
{
	CGRect cellRect = self.frame;
	double newMargin = 40.0;
	
	if (state & UITableViewCellStateShowingEditControlMask)
	{
		newMargin += 30;
	}
	
	if (state & UITableViewCellStateShowingDeleteConfirmationMask)
	{
		newMargin += 60;
	}
    else if (self.fired && !(state & UITableViewCellStateShowingEditControlMask))
    {
        newMargin += 20;
    }
	
	// Adjust the size of the labels to be the same width as the original, just in case the delete button etc.
	UILabel *label = ((UILabel*)[self.contentView viewWithTag:ALARM_NAME_TAG]);
	CGRect newFrame = label.frame;
	newFrame.size.width = cellRect.size.width - newFrame.origin.x - newMargin;
	label.frame = newFrame;
	
	label = ((UILabel*)[self.contentView viewWithTag:ALARM_TOGO_TAG]);
	newFrame = label.frame;
	newFrame.size.width = cellRect.size.width - newFrame.origin.x - newMargin;
	label.frame = newFrame;
    _state = state;
}

- (void)setFired:(_Bool)fired
{
    _fired = fired;
    [self updateState:_state];
}

- (void)resetState
{
	[self updateState:0];

}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
	[super willTransitionToState:state];
	[self  updateState:state];
}

+ (AlarmCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier width:(ScreenType)width height:(CGFloat)height
{
	CGFloat textOffset				= 45.0;
	CGFloat textWidth				= 230.0;
	CGFloat textHeight				= 20.0;
	CGFloat fontSize				= 18.0;
	
	switch (width)
	{
        default:
		case WidthiPhone:
        case WidthiPhone6:
        case WidthiPhone6Plus:
			break;
		case WidthiPadWide:
		case WidthiPadNarrow:
			textOffset				= 40.0;
			textHeight				= 20.0;
			
			if (width == WidthiPadWide)
			{
				textWidth	= 900.0;
				
			}
			else
			{
				textWidth	= 640.0;
			}
			
			// fontSize = 32.0;
			break;
	}
	
	/*
	 Create an instance of UITableViewCell and add tagged subviews for the name, local time, and quarter image of the time zone.
	 */
	CGRect rect;
	
	CGFloat yGap = (height - (textHeight * 2)) / 3;
	
	AlarmCell *cell = [[[AlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
	
	
	/*
	 Create labels for the text fields; set the highlight color so that when the cell is selected it changes appropriately.
	 */
	UILabel *label;
	
	
	rect =	CGRectMake(textOffset, yGap, textWidth, textHeight);
	label								= [[UILabel alloc] initWithFrame:rect];
	label.tag							= ALARM_NAME_TAG;
	label.font							= [UIFont boldSystemFontOfSize:fontSize];
	label.adjustsFontSizeToFitWidth		= YES;
	label.highlightedTextColor			= [UIColor whiteColor];
	label.textColor						= [UIColor blackColor];
	label.backgroundColor				= [UIColor clearColor];
	[cell.contentView addSubview:label];
	[label release];
	
	rect =	CGRectMake(textOffset, yGap+textHeight+yGap, textWidth, textHeight);
	label								=[[UILabel alloc] initWithFrame:rect];
	label.tag							= ALARM_TOGO_TAG;
	label.font							= [UIFont boldSystemFontOfSize:fontSize];
	label.adjustsFontSizeToFitWidth		= YES;
	label.highlightedTextColor			= [UIColor whiteColor];
	label.textColor						= [UIColor blueColor];
	label.backgroundColor				= [UIColor clearColor];
	[cell.contentView addSubview:label];
	[label release];	
	
	
	return cell;
}

- (void)populateCellLine1:(NSString *)line1 line2:(NSString *)line2 line2col:(UIColor *)col
{
	UILabel *label = ((UILabel*)[self.contentView viewWithTag:ALARM_NAME_TAG]);
	
	label.text = line1;
	
	label = ((UILabel*)[self.contentView viewWithTag:ALARM_TOGO_TAG]);
	
	label.text = line2;
	label.textColor =col;
}

+ (CGFloat)rowHeight:(ScreenType)width
{
	if (SmallScreenStyle(width))
	{
		return 40.0 * 1.4;
	}
	return 45.0 * 1.4;
}

@end
