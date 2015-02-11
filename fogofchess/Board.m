//
//  BoardView.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "Board.h"
#import "Piece.h"

@implementation Board

- (id)initWithImage:(UIImage *)image width:(float)fullWidth
{
  self = [super initWithImage:image];
  if(self) {

    self.squareWidth = (fullWidth - 2) / 8;

    int ycoord = (590 - fullWidth)/2 + 20;
    self.frame = CGRectMake(0, ycoord, fullWidth, fullWidth);

    self.pieces = [[NSArray alloc] initWithArray:[self populatePieces]];

    self.contentMode = UIViewContentModeScaleAspectFit;
    self.userInteractionEnabled = YES;
  }

  return self;
}

- (Piece *)addPieceToArray:(NSMutableArray *)array
{
  CGRect frame = CGRectMake(0, 0, self.squareWidth, self.squareWidth);
  Piece *newPiece = [[Piece alloc] initWithFrame:frame withBoard:self];
  [array addObject:newPiece];
  [self addSubview:newPiece];

  return newPiece;
}

- (NSMutableArray *)populatePieces
{
  NSMutableArray *arrayOfPieces = [NSMutableArray array];
  for (int i = 0; i < 8; i++) {
    Piece *newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:1];
    [newPiece setTeam:LIGHT andType:PAWN];

    newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:6];
    [newPiece setTeam:DARK andType:PAWN];
  }

  for (int i = 0; i < 8; i++) {
    Type newType;
    switch(i) {
      case 0 :
      case 7 :
        newType = ROOK;
        break;
      case 1 :
      case 6 :
        newType = KNIGHT;
        break;
      case 2 :
      case 5 :
        newType = BISHOP;
        break;
      case 3 :
        newType = QUEEN;
        break;
      case 4 :
        newType = KING;
        break;
      default:
        break;
    }

    Piece *newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:0];
    [newPiece setTeam:LIGHT andType:newType];

    newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:7];
    [newPiece setTeam:DARK andType:newType];
  }

  return arrayOfPieces;
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
      return [self isUnoccupied:xLoc Y:yLoc];
    }
    else if (yDiff == 2*direction)
    {
      return !curPiece.everMoved
        && [self isUnoccupied:xLoc Y:yLoc]
        && [self isUnoccupied:xLoc Y:curPiece.yLoc + direction];
    }

  }
  else if (abs(xDiff) == 1 && yDiff == 1*direction)
  {

    Piece *attacked = [self getPieceAtX:xLoc Y:yLoc];
    return [self attemptCaptureOf:attacked byTeam:curPiece.team];

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
    Piece *otherPiece = [self getPieceAtX:xLoc Y:yLoc];

    if(otherPiece == nil)
      return YES;

    return [self attemptCaptureOf:otherPiece byTeam:curPiece.team];
  }

  return NO;
}

- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc
{
  for(Piece* piece in self.pieces) {
    if(piece.xLoc == xLoc && piece.yLoc == yLoc && !piece.hidden)
      return piece;
  }

  return nil;
}

- (BOOL)isUnoccupied:(int)xLoc Y:(int)yLoc {
    return [self getPieceAtX:xLoc Y:yLoc] == nil;
}

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team;
{
  if(attacked && attacked.team != team) {
    [attacked capture];
    return YES;
  }

  return NO;
}

@end