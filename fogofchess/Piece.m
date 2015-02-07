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

- (id)initWithImage:(UIImage *)image withBoard:(BoardView *)gameBoard
{
    self = [super initWithImage:image];

    if(self) {
        [self setContentMode:UIViewContentModeScaleAspectFit];
        self.userInteractionEnabled = YES;

        self.board = gameBoard;
        self.squareWidth = [gameBoard squareWidth];
        self.frame = CGRectMake(0, 0, self.squareWidth, self.squareWidth);

        UIPanGestureRecognizer *swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                   action:@selector(panAnim:)];
        [self addGestureRecognizer:swipeRecognizer];
    }

    return self;
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

@end
