//
//  GameTurnHistory.h
//  Machismo
//
//  Created by Aleksander B Hansen on 1/30/13.
//  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameTurnHistory : NSObject


- (void) addHistory: (NSString *) history;
- (NSString *) getHistoryAtIndex: (NSUInteger) index;

@end
