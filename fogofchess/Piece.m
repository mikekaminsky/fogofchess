//
//  Piece.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "Piece.h"
#import "BoardView.h"

@implementation Piece

- (id)initWithFrame:(CGRect)frame withBoard:(BoardView *)gameBoard
{
    self = [super initWithFrame:frame];

    if(self) {
        [self setContentMode:UIViewContentModeScaleAspectFit];
        self.userInteractionEnabled = YES;

        self.board = gameBoard;
        self.squareWidth = [gameBoard squareWidth];

        UIPanGestureRecognizer *swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                   action:@selector(panAnim:)];
        [self addGestureRecognizer:swipeRecognizer];
    }

    return self;
}

- (void)setTeam:(Team)newTeam andType:(Type)newType
{
    self.team = newTeam;
    self.type = newType;
    if(newTeam == DARK) {
        [self setImage:[UIImage imageNamed:@"dark_pawn"]];
    } else {
        [self setImage:[UIImage imageNamed:@"light_pawn"]];
    }
}

- (void)changeLocationX:(int)xLoc Y:(int)yLoc
{
  self.xLoc = xLoc;
  self.yLoc = yLoc;

  CGRect frame = self.frame;
  frame.origin.x = self.xLoc * self.squareWidth;
  frame.origin.y = self.yLoc * self.squareWidth;
  self.frame = frame;
}

- (void)attemptMoveX:(int)xLoc Y:(int)yLoc;
{
  if(xLoc < 0 || yLoc < 0 || xLoc > 7 || yLoc > 7) return;
    
  if([self.board canMove:self X:xLoc Y:yLoc]) {
    [self changeLocationX:xLoc Y:yLoc];
  }
}

-(void) panAnim:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer.view superview]];

    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //Highlight potential moves.
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        int xLoc = (int)location.x/self.squareWidth;
        int yLoc = (int)location.y/self.squareWidth;

        [self attemptMoveX:xLoc Y:yLoc];
    }
}

-(void)capture
{
    self.hidden = YES;
}

@end
