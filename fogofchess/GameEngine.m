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
  if(curPiece.type == KING) {

    if([self kingCanMove:curPiece X:xLoc Y:yLoc]) {
      return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
    } else if([self kingCanCastle:curPiece X:xLoc Y:yLoc]) {
      return [self executeCastle:curPiece X:xLoc Y:yLoc];
    }

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
    if(!attacked) {
      attacked = [self.board getEnPassantPawnX:xLoc Y:yLoc];
    }
    if (attacked && attacked.team != curPiece.team){
      bReturn = YES;
    }
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

  if (abs(xDiff) > 1 || abs(yDiff) > 1)
    return NO;

  return YES;
}

- (BOOL)kingCanCastle:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
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
    Team enemy = curPiece.team == DARK ? LIGHT : DARK;

    for (int i = curPiece.xLoc + direction; i != rook.xLoc; i += direction) {
      if (![self.board isUnoccupiedX:i Y:curPiece.yLoc])
        return NO;
    }

    for (int i = curPiece.xLoc; i != xLoc + direction; i += direction) {
      if ([self squareUnderAttackByTeam:enemy X:i Y:curPiece.yLoc])
        return NO;
    }

    return YES;
  }

  return NO;
}

- (BOOL)executeCastle:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  Piece *rook;

  if(xLoc == 2) {
      rook = [self.board getPieceAtX:0 Y:curPiece.yLoc];
  } else {
      rook = [self.board getPieceAtX:BOARD_SIZE-1 Y:curPiece.yLoc];
  }

  int newXLoc = rook.xLoc == 0 ? 3 : BOARD_SIZE - 3;

  [rook setLocationX:newXLoc Y:rook.yLoc];
  return YES;
}

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team
{
  if(attacked && attacked.team != team) {
    [self.board capturePiece: attacked];

    if(attacked.type != KING){
      return YES;
    }
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
    if(!attacked) {
      attacked = [self.board getEnPassantPawnX:xLoc Y:yLoc];
    }
    bReturn = [self attemptCaptureOf:attacked byTeam:curPiece.team];
  } else {
    bReturn = YES;
  }
  if(bReturn)
    [self promotePawn:curPiece Y:yLoc];
  return bReturn;
}

- (NSMutableArray *)possibleMoves:(Piece *)piece
{
  switch(piece.type) {
    case PAWN:
      return [self pawnMoves:piece];
      break;
    case KNIGHT:
      return [self knightMoves:piece];
      break;
    case ROOK:
      return [self rookMoves:piece];
      break;
    case BISHOP:
      return [self bishopMoves:piece];
      break;
    case QUEEN:
      return [self queenMoves:piece];
      break;
    case KING:
      return [self kingMoves:piece];
      break;
  }
}

- (NSMutableArray *)pawnMoves:(Piece *)piece
{
  NSMutableArray *array = [NSMutableArray array];
  int direction = [piece team] == DARK ? 1 : -1;

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

- (NSMutableArray *)queenMoves:(Piece *)piece
{
  NSMutableSet *setA = [NSMutableSet setWithArray:[self bishopMoves:piece]];
  NSMutableSet *setB = [NSMutableSet setWithArray:[self rookMoves:piece]];

  [setA unionSet:setB];

  NSMutableArray *array = [NSMutableArray arrayWithArray:[setA allObjects]];

  return array;
}


- (NSMutableArray *)kingMoves:(Piece *)piece
{
  NSMutableArray *array = [NSMutableArray array];

  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {

      if(x==0 && y==0)
        continue;

      int xLoc = piece.xLoc + x;
      int yLoc = piece.yLoc + y;

      if(![self onBoardX:xLoc Y:yLoc])
        continue;

      if ([self kingCanMove:piece X:xLoc Y:yLoc]){
        Piece *otherPiece = [self.board getPieceAtX:xLoc Y:yLoc];
        if (!otherPiece || otherPiece.team != piece.team){
          Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
          [array addObject:move];
        }
      }
    }
  }

  if(!piece.bEverMoved) {
    for (int x = 0; x < BOARD_SIZE; x++) {
      if([self kingCanCastle:piece X:x Y:piece.yLoc]){
          Move *move = [[Move alloc] initWithPiece:piece X:x Y:piece.yLoc];
          [array addObject:move];
      }
    }
  }

  return array;
}

- (BOOL)pawnThreatensSquare:(Piece *)pawn X:(int)xLoc Y:(int)yLoc
{
  int direction = [pawn team] == DARK ? 1 : -1;

  int xDiff = xLoc - pawn.xLoc; int yDiff = yLoc - pawn.yLoc;
  if (abs(xDiff) == 1 && yDiff == 1 * direction) {
    Piece *occupier = [self.board getPieceAtX:xLoc Y:yLoc];
    if(!occupier || occupier.team != pawn.team) {
      return YES;
    }
  }

  return NO;
}

- (BOOL)squareUnderAttackByTeam:(Team)team X:(int)xLoc Y:(int)yLoc
{
  for (Piece *piece in self.board.pieces){
    if(piece.bCaptured || piece.team != team)
      continue;
    
    if(xLoc == piece.xLoc && yLoc == piece.yLoc)
      continue;
    
    switch(piece.type) {
      case PAWN:
        if([self pawnThreatensSquare:piece X:xLoc Y:yLoc])
          return YES;
        break;
      case KNIGHT:
        if([self knightCanMove:piece X:xLoc Y:yLoc])
          return YES;
        break;
      case ROOK:
        if([self rookCanMove:piece X:xLoc Y:yLoc])
          return YES;
        break;
      case BISHOP:
        if([self bishopCanMove:piece X:xLoc Y:yLoc])
          return YES;
        break;
      case QUEEN:
        if([self queenCanMove:piece X:xLoc Y:yLoc])
          return YES;
        break;
      case KING:
        if([self kingCanMove:piece X:xLoc Y:yLoc])
          return YES;
        break;
    }
  }

  return NO;
}

- (BOOL)detectCheck:(Move *)move
{
  [self.board futureBoard:move];

  int kingX;
  int kingY;
  
  if(move.piece.type == KING) {
    kingX = move.xLoc;
    kingY = move.yLoc;
  } else {
    Piece* king = [self.board getKing:move.piece.team];
    kingX = king.xLoc;
    kingY = king.yLoc;
  }

  Team enemy = move.piece.team == DARK ? LIGHT : DARK;
  BOOL ret = [self squareUnderAttackByTeam:enemy X:kingX Y:kingY];

  [self.board updateAllSquares];

  return ret;
}

@end
