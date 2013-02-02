/*  CardGameViewController.m
 Matchismo
 Created by Aleksander B Hansen on 1/24/13.
 Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
 */
#import "PlayingCardDeck.h"
#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameTurnHistory.h"
@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) PlayingCardDeck *deck;
@property (weak, nonatomic) IBOutlet UILabel *cardDescLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchNumSwitch;


@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation CardGameViewController

// Lazy instantiation

- (PlayingCardDeck *) deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

- (CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (IBAction)deal:(id)sender
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    
    self.game.sliderValue = 0;
    self.flipCount = 0;
    [self.matchNumSwitch setEnabled:YES];
    [self updateUI];
}

- (IBAction)matchReqChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
        self.game.requiredMatches = 2;
    else
        self.game.requiredMatches = 3;
}



- (void) setCardButtons:(NSArray *) cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}



- (void) updateUI
{
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setImage:[UIImage imageNamed:card.imageName] forState:UIControlStateSelected];
        [cardButton setImage:[UIImage imageNamed:card.imageName] forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.cardDescLabel.text = self.game.moveDescription;    
    [self.slider setMinimumValue:0.0f];
    [self.slider setMaximumValue:50.0f];
    [self.slider setValue: self.game.sliderValue animated:YES];
    [self.cardDescLabel setBackgroundColor:[UIColor grayColor]];
    
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;

    
    if (sender.selected) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            // increment counters
            self.flipCount++;
            // disable match switch
            [self.matchNumSwitch setEnabled:NO];
            // change the state of buttons and show image
            [sender setTitle:card.contents forState:UIControlStateSelected];
            [sender setImage:[UIImage imageNamed:card.imageName] forState:UIControlStateSelected];
            //flip game card and will do the matching
            [self.game flipCardAtIndex:[self.cardButtons indexOfObject: sender]];
            // update UI base on the result of flip and matching
            [self updateUI];
            
        }
    }
}


- (IBAction)sliderAction:(UISlider *)sender {
    
    [self.cardDescLabel setBackgroundColor:[UIColor darkGrayColor]];
    self.cardDescLabel.text = [self.game.gameHistory getHistoryAtIndex:[sender value]];
}

@end
