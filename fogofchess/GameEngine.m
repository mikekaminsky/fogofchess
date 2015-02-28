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
  if( (self.board.turn % 2 == 0 && curPiece.team == DARK) ||
     (self.board.turn %2 == 1 && curPiece.team == LIGHT) ) {
    return NO;
  }

  if(xLoc < 0 || yLoc < 0 || xLoc > BOARD_SIZE-1 || yLoc > BOARD_SIZE-1)
    return NO;
  if(xLoc == curPiece.xLoc && yLoc == curPiece.yLoc)
    return NO;

  if(curPiece.type == PAWN)
    return [self pawnCanMove:curPiece X:xLoc Y:yLoc];
  if(curPiece.type == KNIGHT)
    return [self knightCanMove:curPiece X:xLoc Y:yLoc];
  if(curPiece.type == ROOK)
    return [self rookCanMove:curPiece X:xLoc Y:yLoc];
  if(curPiece.type == BISHOP)
    return [self bishopCanMove:curPiece X:xLoc Y:yLoc];
  if(curPiece.type == QUEEN)
    return [self queenCanMove:curPiece X:xLoc Y:yLoc];
  if(curPiece.type == KING)
    return [self kingCanMove:curPiece X:xLoc Y:yLoc];
  return NO;
}

- (void)promotePawn:(Piece *)curPiece Y:(int)yLoc
{
  if(yLoc == 0 || yLoc == BOARD_SIZE - 1) {
    [curPiece setTeam:curPiece.team andType:QUEEN];
  }
}

- (BOOL)pawnCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int direction = [curPiece team] == DARK ? 1 : -1;

  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  BOOL bReturn = NO;

  if (xLoc == curPiece.xLoc)
  {
    if (yDiff == 1 * direction)
    {
      bReturn = [self.board isUnoccupiedX:xLoc Y:yLoc];
    }
    else if (yDiff == 2 * direction)
    {
      bReturn = !curPiece.bEverMoved &&
                [self.board isUnoccupiedX:xLoc Y:yLoc] &&
                [self.board isUnoccupiedX:xLoc Y:curPiece.yLoc + direction];
    }

  }
  else if (abs(xDiff) == 1 && yDiff == 1 * direction)
  {
    Piece *attacked = [self.board getPieceAtX:xLoc Y:yLoc];
    bReturn =  [self attemptCaptureOf:attacked byTeam:curPiece.team];
  }

  if(bReturn) {
    [self promotePawn:curPiece Y:yLoc];
  }

  return bReturn;
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

    return [self attemptCaptureOf:otherPiece byTeam:curPiece.team];
  }

  return NO;
}

- (BOOL)rookCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  if (xDiff != 0 && yDiff != 0)
    return NO;

  if (yDiff != 0)
  {
    int direction = yDiff > 0 ? 1 : -1;
    for (int i = curPiece.yLoc + direction; i != yLoc; i += direction) {
      if (![self.board isUnoccupiedX:curPiece.xLoc Y:i])
        return NO;
    }
  }
  else if (xDiff != 0)
  {
    int direction = xDiff > 0 ? 1 : -1;
    for (int i = curPiece.xLoc + direction; i != xLoc; i += direction) {
      if (![self.board isUnoccupiedX:i Y:curPiece.yLoc])
        return NO;
    }
  }

  return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
}


- (BOOL)bishopCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{

  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;
  int xDirection = xDiff > 0 ? 1 : -1;
  int yDirection = yDiff > 0 ? 1 : -1;

  if (abs(xDiff) != abs(yDiff))
    return NO;

  int j = curPiece.yLoc + yDirection;
  for (int i = curPiece.xLoc + xDirection; i != xLoc && j != yLoc; i += xDirection) {
    if (![self.board isUnoccupiedX:i Y:j])
      return NO;
    j += yDirection;
  }

  return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
}


- (BOOL)queenCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  return [self bishopCanMove:curPiece X:xLoc Y:yLoc] ||
         [self rookCanMove:curPiece X:xLoc Y:yLoc];
}


- (BOOL)kingCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  BOOL isCastleXLoc = xLoc == 2 || xLoc == BOARD_SIZE - 2;
  if (!curPiece.bEverMoved && curPiece.yLoc == yLoc && isCastleXLoc) {
    Piece *rook;
    if(xLoc == 2) {
      rook = [self.board getPieceAtX:0 Y:curPiece.yLoc];
    } else {
      rook = [self.board getPieceAtX:BOARD_SIZE-1 Y:curPiece.yLoc];
    }

    if(!rook || rook.bEverMoved) {
      return NO;
    }

    int direction = xLoc == 2 ? -1 : 1;

    for (int i = curPiece.xLoc + direction; i != rook.xLoc; i += direction) {
      if (![self.board isUnoccupiedX:i Y:curPiece.yLoc])
        return NO;
    }

    int newXLoc = rook.xLoc == 0 ? 3 : BOARD_SIZE - 3;

    [rook changeLocationX:newXLoc Y:rook.yLoc];
    return YES;
  }

  if (abs(xDiff) > 1 || abs(yDiff) > 1)
    return NO;

  return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
}

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team;
{
  if(attacked && attacked.team != team) {
    [self.board capturePiece: attacked];

    return YES;
  }

  return NO;
}

- (BOOL)moveOrCapture:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  Piece *otherPiece = [self.board getPieceAtX:xLoc Y:yLoc];

  if(otherPiece == nil)
    return YES;

  return [self attemptCaptureOf:otherPiece byTeam:curPiece.team];
}

@end
