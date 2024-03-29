//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Aleksander B Hansen on 1/30/13.
//  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
//
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"


@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) NSString *moveDescription;
@property (nonatomic, readwrite) int score;


@end

@implementation CardMatchingGame

- (GameTurnHistory *) gameHistory
{
    if (!_gameHistory) _gameHistory = [[GameTurnHistory alloc] init];
    return _gameHistory;
}

- (NSMutableArray *) cards {
    if (!_cards)
    {
        _cards =[[NSMutableArray alloc] init];
    }
    return _cards;
}

-(id) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.requiredMatches = 2;
    }
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count ? self.cards[index] : nil);
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void) flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (card.isUnplayable) return;
    
    card.faceUp = !card.isFaceUp;
    
    if (card.isFaceUp)
    {
        NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
        
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                [faceUpCards addObject: otherCard];
            }
        }
        
        if ([faceUpCards count] < self.requiredMatches)
        {
            self.score -= FLIP_COST;
            self.moveDescription = [NSString stringWithFormat:@"You flipped %@", card.contents];
            [self.gameHistory addHistory:self.moveDescription];
            self.sliderValue++;
        }
        else
        {
            int matchscore = [card match:faceUpCards];
            
            if (matchscore == 0) {
                for (Card *c in faceUpCards) {
                    c.faceUp = NO;
                }
                card.faceUp = YES;
                self.score -= MISMATCH_PENALTY;
                NSString *mismatches = [faceUpCards componentsJoinedByString:@" & "];
                self.moveDescription = [NSString stringWithFormat:@"%@ don't match! %d point penalty", mismatches, MISMATCH_PENALTY];
                [self.gameHistory addHistory:self.moveDescription];
                self.sliderValue++;
            }
            else {
                self.score += matchscore * MATCH_BONUS;
                for (Card *c in faceUpCards) {
                    c.unplayable = YES;
                    card.unplayable = YES;
                }
                NSString *matches = [faceUpCards componentsJoinedByString:@" & "];
                self.moveDescription = [NSString stringWithFormat:@"Matched %@ for %d points!", matches, matchscore * MATCH_BONUS];
                [self.gameHistory addHistory:self.moveDescription];
                self.sliderValue++;
            }
        }
        
        faceUpCards = nil;
    }
}
@end