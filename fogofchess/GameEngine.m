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
#import "Move.h"


@implementation GameEngine

- (id)initWithBoard:(Board *)board
{
  self = [super init];
  if(self) {
    self.board = board;
  }

  return self;
}

- (BOOL)onBoardX:(int)xLoc Y:(int)yLoc
{
  if(xLoc < 0 || yLoc < 0 || xLoc > BOARD_SIZE-1 || yLoc > BOARD_SIZE-1){
    return NO;
  }else{
    return YES;
  }
}

- (BOOL)executeMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  if( (self.board.turn % 2 == 0 && curPiece.team == DARK) ||
     (self.board.turn %2 == 1 && curPiece.team == LIGHT) ) {
    return NO;
  }

  if(![self onBoardX:xLoc Y:yLoc])
    return NO;
  if(xLoc == curPiece.xLoc && yLoc == curPiece.yLoc)
    return NO;

  if(curPiece.type == PAWN &&
      [self pawnCanMove:curPiece X:xLoc Y:yLoc])
  {
    return [self pawnMoveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == KNIGHT &&
      [self knightCanMove:curPiece X:xLoc Y:yLoc])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == ROOK &&
      [self rookCanMove:curPiece X:xLoc Y:yLoc])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == BISHOP &&
      [self bishopCanMove:curPiece X:xLoc Y:yLoc])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == QUEEN &&
      [self queenCanMove:curPiece X:xLoc Y:yLoc])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == KING &&
      [self kingCanMove:curPiece X:xLoc Y:yLoc])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
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
    if (attacked){
      bReturn = YES;
    }
  }

  if(bReturn) {
  }

  return bReturn;
}

- (BOOL)knightCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  if(xLoc < 0 || yLoc < 0 || xLoc > BOARD_SIZE-1 || yLoc > BOARD_SIZE-1)
    return NO;
  if(xLoc == curPiece.xLoc && yLoc == curPiece.yLoc)
    return NO;

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

    return YES;
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

  return YES;
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

  return YES;
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

  return YES;
}

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team
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

- (BOOL)pawnMoveOrCapture:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  BOOL bReturn = NO;
  if(xLoc != curPiece.xLoc) {
    Piece *attacked = [self.board getPieceAtX:xLoc Y:yLoc];
    bReturn = [self attemptCaptureOf:attacked byTeam:curPiece.team];
  } else {
    bReturn = YES;
  }
  if(bReturn)
    [self promotePawn:curPiece Y:yLoc];
  return bReturn;
}

- (BOOL)squareUnderAttackX:(int)xLoc Y:(int)yLoc byTeam:(Team)team
{

  // if( self.board.turn % 2 == 0 ){
    // Dark
  // }
  return NO;

}

- (NSMutableArray *)pawnMoves:(Piece *)piece{

  int direction = [piece team] == DARK ? 1 : -1;
  NSMutableArray *array = [NSMutableArray array];

  for (int i = -1; i <= 1; i++)
  {
    int xLoc = piece.xLoc + i;
    int yLoc = piece.yLoc + direction;

    Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
    if ([self pawnCanMove:piece X:xLoc Y:yLoc]){
      [array addObject:move];
    }
  }

  int xLoc = piece.xLoc;
  int yLoc = piece.yLoc + 2*direction;

  Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
  if ([self pawnCanMove:piece X:xLoc Y:yLoc]){
    [array addObject:move];
  }

  return array;
}

- (NSMutableArray *)knightMoves:(Piece *)piece
{
  NSMutableArray *array = [NSMutableArray array];

  for (int x = -2; x <= 2; x++)
  {
    for(int y = -2; y <= 2; y++) {
      if(x == 0 || y == 0 || x == y){
        continue;
      }
      int xLoc = piece.xLoc + x;
      int yLoc = piece.yLoc + y;

      Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
      Piece *otherPiece = [self.board getPieceAtX:xLoc Y:yLoc];

      if ([self knightCanMove:piece X:xLoc Y:yLoc]){
        if ((!otherPiece || otherPiece.team != piece.team)){
           [array addObject:move];
        }
      }
    }
  }
  return array;
}

- (NSMutableArray *)rookMoves:(Piece *)piece
{
  NSMutableArray *array = [NSMutableArray array];

  for (int i = 1; i <= BOARD_SIZE-1; i++)
  {
    for (int pos = 0; pos <= 1; pos++)
    {
      for (int x = 0; x <= 1; x++)
      {
        int direction = pos == 0 ? -1 : 1;

        int xLoc = x == 0 ? piece.xLoc : piece.xLoc + i*direction;
        int yLoc = x == 1 ? piece.yLoc : piece.yLoc + i*direction;

        Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
        Piece *otherPiece = [self.board getPieceAtX:xLoc Y:yLoc];

        if ([self rookCanMove:piece X:xLoc Y:yLoc] && [self onBoardX:xLoc Y:yLoc]){
          if ((!otherPiece || otherPiece.team != piece.team)){
           [array addObject:move];
          }
        }
      }
    }
  }
  return array;
}

- (NSMutableArray *)bishopMoves:(Piece *)piece
{
  NSMutableArray *array = [NSMutableArray array];

  for (int i = 1; i <= BOARD_SIZE-1; i++)
  {
    for (int xpos = 0; xpos <= 1; xpos++)
    {
      for (int ypos = 0; ypos <= 1; ypos++)
      {

        int xDirection = xpos == 0 ? -1 : 1;
        int yDirection = ypos == 0 ? -1 : 1;

        int xLoc = piece.xLoc + i*xDirection;
        int yLoc = piece.yLoc + i*yDirection;

        Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
        Piece *otherPiece = [self.board getPieceAtX:xLoc Y:yLoc];

        if ([self bishopCanMove:piece X:xLoc Y:yLoc] && [self onBoardX:xLoc Y:yLoc]){
          if ((!otherPiece || otherPiece.team != piece.team)){
           [array addObject:move];
          }
        }
      }
    }
  }
  return array;
}






@end
