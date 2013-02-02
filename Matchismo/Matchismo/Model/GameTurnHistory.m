//
//  GameTurnHistory.m
//  Machismo
//  Created by Aleksander B Hansen on 1/30/13.
//  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
//

#import "GameTurnHistory.h"

@interface GameTurnHistory ()
@property (nonatomic, strong) NSMutableArray *histories;
@end

@implementation GameTurnHistory

- (NSMutableArray *) histories
{
    if (!_histories) _histories = [[NSMutableArray alloc] init];
    return _histories;
}

- (void) addHistory:(NSString *)history
{
    [self.histories addObject:history];
}

- (NSString *) getHistoryAtIndex: (NSUInteger) index;
{
    NSString * history = nil;
    
    if (index < [self.histories count]) {
        history = self.histories[index];
    }
    return history;
}
@end


