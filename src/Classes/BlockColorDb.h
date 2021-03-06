//
//  BlockColorDb.h
//  PDX Bus
//
//  Created by Andrew Wallace on 5/25/13.
//  Copyright (c) 2013 Teleportaloo. All rights reserved.
//



/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import <Foundation/Foundation.h>
#import "MemoryCaches.h"

@interface BlockColorDb : NSObject <ClearableCache>
{
    NSMutableDictionary *_colorMap;
    NSString *_fileName;
}

+ (BlockColorDb *)getSingleton;
- (UIColor *) colorForBlock:(NSString *)block;
- (void)addColor:(UIColor *)color forBlock:(NSString *)block description:(NSString*)desc;
- (void)clearAll;
- (NSArray *)keys;
- (NSString *)descForBlock:(NSString *)block;
- (NSDate *)timeForBlock:(NSString *)block;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (void)openFile;
- (void)memoryWarning;

@end
