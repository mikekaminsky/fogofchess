//
//  Piece.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "Piece.h"
#import "Board.h"

NSString * const TypeName[] = {
  [PAWN] = @"pawn",
  [KNIGHT] = @"knight",
  [BISHOP] = @"bishop",
  [ROOK] = @"rook",
  [QUEEN] = @"queen",
  [KING] = @"king"
};

NSString * const TeamName[] = {
  [DARK] = @"dark",
  [LIGHT] = @"light",
};

@implementation Piece

- (id)initWithFrame:(CGRect)frame withBoard:(Board *)gameBoard
{
  self = [super initWithFrame:frame];

  if(self) {
    self.board = gameBoard;

    self.bEverMoved = NO;
    self.bCaptured = NO;
    self.xLoc = -1;
    self.yLoc = -1;

    self.contentMode = UIViewContentModeScaleAspectFit;
    [self enableInteraction];
  }

  return self;
}

- (void)enableInteraction
{
  UIPanGestureRecognizer *swipeRecognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(panAnim:)];
  [self addGestureRecognizer:swipeRecognizer];

  self.userInteractionEnabled = YES;
}

- (void)setTeam:(Team)newTeam andType:(Type)newType
{
  self.team = newTeam;
  self.type = newType;

  NSString *assetFile = [NSString stringWithFormat:@"%@_%@", TeamName[newTeam], TypeName[newType]];

  [self setImage:[UIImage imageNamed:assetFile]];
}

- (void)changeLocationX:(int)xLoc Y:(int)yLoc
{
  [self.board updateAllSquares:self X:xLoc Y:yLoc];

  self.xLoc = xLoc;
  self.yLoc = yLoc;

  CGRect frame = self.frame;
  frame.origin.x = self.xLoc * self.board.squareWidth;
  frame.origin.y = self.yLoc * self.board.squareWidth;
  self.frame = frame;
}

- (void)attemptMoveX:(int)xLoc Y:(int)yLoc;
{

  if([self.board executeMove:self X:xLoc Y:yLoc]) {
    self.bEverMoved = YES;
    [self changeLocationX:xLoc Y:yLoc];
  }
}

- (void)highlight:(BOOL)bOn
{
  if (bOn){
    self.alpha = 0.5;
  }
  else{
    self.alpha = 1;
  }
}

- (void)select:(BOOL)bOn{
  [self highlight:bOn];

  [self.board highlightPossibleMoves:self On:bOn];
}

- (void)panAnim:(UIPanGestureRecognizer*)gestureRecognizer
{
  CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer.view superview]];

  if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
  {
    [self.board clearSelection];
    [self select:YES];
  }
  else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
  {
    int xLoc = (int)location.x/self.board.squareWidth;
    int yLoc = (int)location.y/self.board.squareWidth;

    [self select:NO];
    [self attemptMoveX:xLoc Y:yLoc];
  }
}

@end
