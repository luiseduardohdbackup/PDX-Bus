//
//  AlarmViewMinutes.h
//  PDX Bus
//
//  Created by Andrew Wallace on 1/30/11.
//  Copyright 2011. All rights reserved.
//



/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import <Foundation/Foundation.h>
#import "TableViewWithToolbar.h"
#import "XMLDepartures.h"

@interface AlarmViewMinutes : TableViewWithToolbar <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *_pickerView;
	
	Departure *_dep;
}

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) Departure *dep;

- (CGRect)pickerFrameWithSize:(CGSize)size;

@end
