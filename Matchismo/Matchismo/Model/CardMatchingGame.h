//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Aleksander B Hansen on 1/30/13.
//  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "GameTurnHistory.h"

@interface CardMatchingGame : NSObject
    /* Remember NSUInteger is typedef'ed */
- (id)initWithCardCount:(NSUInteger) cardCount
              usingDeck:(Deck *) deck;

- (void) flipCardAtIndex:(NSUInteger) index;

- (Card *) cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) int score;
@property (nonatomic) int requiredMatches; 
@property (nonatomic, readonly) NSString *moveDescription;
@property (nonatomic) float sliderValue;
@property (strong, nonatomic) GameTurnHistory *gameHistory;

@end
