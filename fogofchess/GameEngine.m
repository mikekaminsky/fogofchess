//
//  GameEngine.m
//  fogofchess
//
//  Created by Case Commons on 2/11/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "GameEngine.h"
#import "Board.h"
#import "Piece.h"


@implementation GameEngine

- (id)initWithBoard:(Board *)board
{
  self = [super init];
  if(self) {
    self.board = board;
  }

  return self;
}

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  if(curPiece.type == PAWN)
    return [self pawnCanMove:curPiece X:xLoc Y:yLoc];
  if(curPiece.type == KNIGHT)
    return [self knightCanMove:curPiece X:xLoc Y:yLoc];
  return NO;
}

- (BOOL)pawnCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int direction = [curPiece team] == DARK ? -1 : 1;

  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  if (xLoc == curPiece.xLoc)
  {
    if (yDiff == 1*direction)
    {
      return [self.board isUnoccupied:xLoc Y:yLoc];
    }
    else if (yDiff == 2*direction)
    {
      return !curPiece.everMoved
        && [self.board isUnoccupied:xLoc Y:yLoc]
        && [self.board isUnoccupied:xLoc Y:curPiece.yLoc + direction];
    }

  }
  else if (abs(xDiff) == 1 && yDiff == 1*direction)
  {
    Piece *attacked = [self.board getPieceAtX:xLoc Y:yLoc];
    return [self.board attemptCaptureOf:attacked byTeam:curPiece.team];
  }

  return NO;
}

- (BOOL)knightCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int xDiff = abs(xLoc - curPiece.xLoc);
  int yDiff = abs(yLoc - curPiece.yLoc);

  if (xDiff > 2)
    return NO;
  if (yDiff > 2)
    return NO;

  if (xDiff + yDiff == 3) {
    Piece *otherPiece = [self.board getPieceAtX:xLoc Y:yLoc];

    if(otherPiece == nil)
      return YES;

    return [self.board attemptCaptureOf:otherPiece byTeam:curPiece.team];
  }

  return NO;
}

@end


