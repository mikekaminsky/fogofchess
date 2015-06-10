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
static Move *lastMove;

- (NSMutableArray *)possibleMovesByTeam:(Team)team WithBoard:(NSMutableArray *)boardState LastMove:(Move *)lastMoveFromBoard
{
  NSMutableArray *moves = [NSMutableArray array];

  lastMove = lastMoveFromBoard;

  for (Piece *piece in boardState){
    if([piece isEqual:[NSNull null]] || piece.team != team){
      continue;
    }

    NSMutableArray *array = [self possibleMoves:piece BoardState:boardState];

    [moves addObjectsFromArray:array];

  }

  lastMove = nil;

  return moves;

}

- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  if(![self onBoardX:xLoc Y:yLoc])
    return nil;
  Piece *p = [boardState objectAtIndex:yLoc*BOARD_SIZE+xLoc];
  if([p isEqual:[NSNull null]] || p.bCaptured == YES)
    return nil;
  return p;
}

- (BOOL)isUnoccupiedX:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  return [self getPieceAtX:xLoc Y:yLoc BoardState:boardState] == nil;
}

- (BOOL)onBoardX:(int)xLoc Y:(int)yLoc
{
  if(xLoc < 0 || yLoc < 0 || xLoc > BOARD_SIZE-1 || yLoc > BOARD_SIZE-1){
    return NO;
  }else{
    return YES;
  }
}

- (BOOL)executeMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:(NSMutableArray*)boardState
// TODO: Refactor and move any state changes to board.
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
      [self pawnCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState])
  {
    return [self pawnMoveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == KNIGHT &&
      [self knightCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == ROOK &&
      [self rookCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == BISHOP &&
      [self bishopCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == QUEEN &&
      [self queenCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState])
  {
    return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
  }
  if(curPiece.type == KING) {

    if([self kingCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState]) {
      return [self moveOrCapture:curPiece X:xLoc Y:yLoc];
    } else if([self kingCanCastle:curPiece X:xLoc Y:yLoc BoardState:boardState]) {
      return [self executeCastle:curPiece X:xLoc Y:yLoc];
    }

  }
  return NO;
}

- (void)promotePawn:(Piece *)curPiece Y:(int)yLoc
//Where does this live? Should it be on the board?
{
  if(yLoc == 0 || yLoc == BOARD_SIZE - 1) {
    [curPiece setTeam:curPiece.team andType:QUEEN];
  }
}

- (Piece *) getEnPassantPawnX:(int)xLoc Y:(int)yLoc{
  int yDiff = abs(lastMove.yLoc - lastMove.oldYLoc);
  int attackY = lastMove.piece.team == DARK ? 2 : 5;
  if(lastMove.piece.type == PAWN
      && xLoc == lastMove.xLoc
      && yDiff == 2
      && yLoc == attackY)
    return lastMove.piece;

  return nil;
}

- (BOOL)pawnCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  int direction = [curPiece team] == DARK ? 1 : -1;

  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  BOOL bReturn = NO;

  if (xLoc == curPiece.xLoc)
  {
    if (yDiff == 1 * direction)
    {
      bReturn = [self isUnoccupiedX:xLoc Y:yLoc BoardState:boardState];
    }
    else if (yDiff == 2 * direction)
    {
      bReturn = !curPiece.bEverMoved &&
                [self isUnoccupiedX:xLoc Y:yLoc BoardState:boardState] &&
                [self isUnoccupiedX:xLoc Y:curPiece.yLoc + direction BoardState:boardState];
    }

  }
  else if (abs(xDiff) == 1 && yDiff == 1 * direction)
  {
    Piece *attacked = [self getPieceAtX:xLoc Y:yLoc BoardState:boardState];
    if(!attacked) {
      attacked = [self getEnPassantPawnX:xLoc Y:yLoc];
    }
    if (attacked && attacked.team != curPiece.team){
      bReturn = YES;
    }
  }

  return bReturn;
}

- (BOOL)knightCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
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
    Piece *otherPiece = [self getPieceAtX:xLoc Y:yLoc BoardState:boardState];

    if(otherPiece == nil)
      return YES;

    return YES;
  }

  return NO;
}

- (BOOL)rookCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  if (xDiff != 0 && yDiff != 0)
    return NO;

  if (yDiff != 0)
  {
    int direction = yDiff > 0 ? 1 : -1;
    for (int i = curPiece.yLoc + direction; i != yLoc; i += direction) {
      if (![self isUnoccupiedX:curPiece.xLoc Y:i BoardState:boardState])
        return NO;
    }
  }
  else if (xDiff != 0)
  {
    int direction = xDiff > 0 ? 1 : -1;
    for (int i = curPiece.xLoc + direction; i != xLoc; i += direction) {
      if (![self isUnoccupiedX:i Y:curPiece.yLoc BoardState:boardState])
        return NO;
    }
  }

  return YES;
}


- (BOOL)bishopCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
{

  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;
  int xDirection = xDiff > 0 ? 1 : -1;
  int yDirection = yDiff > 0 ? 1 : -1;

  if (abs(xDiff) != abs(yDiff))
    return NO;

  int j = curPiece.yLoc + yDirection;
  for (int i = curPiece.xLoc + xDirection; i != xLoc && j != yLoc; i += xDirection) {
    if (![self isUnoccupiedX:i Y:j BoardState:boardState])
      return NO;
    j += yDirection;
  }

  return YES;
}


- (BOOL)queenCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  return [self bishopCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState] ||
         [self rookCanMove:curPiece X:xLoc Y:yLoc BoardState:boardState];
}


- (BOOL)kingCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  int xDiff = xLoc - curPiece.xLoc;
  int yDiff = yLoc - curPiece.yLoc;

  if (abs(xDiff) > 1 || abs(yDiff) > 1)
    return NO;

  return YES;
}

- (BOOL)kingCanCastle:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  BOOL isCastleXLoc = xLoc == 2 || xLoc == BOARD_SIZE - 2;
  if (!curPiece.bEverMoved && curPiece.yLoc == yLoc && isCastleXLoc) {
    Piece *rook;
    if(xLoc == 2) {
      rook = [self getPieceAtX:0 Y:curPiece.yLoc BoardState:boardState];
    } else {
      rook = [self getPieceAtX:BOARD_SIZE-1 Y:curPiece.yLoc BoardState:boardState];
    }

    if(!rook || rook.bEverMoved) {
      return NO;
    }

    int direction = xLoc == 2 ? -1 : 1;
    Team enemy = curPiece.team == DARK ? LIGHT : DARK;

    for (int i = curPiece.xLoc + direction; i != rook.xLoc; i += direction) {
      if (![self isUnoccupiedX:i Y:curPiece.yLoc BoardState:boardState])
        return NO;
    }

    for (int i = curPiece.xLoc; i != xLoc + direction; i += direction) {
      if ([self squareUnderAttackByTeam:enemy X:i Y:curPiece.yLoc BoardState:boardState])
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

  [rook setLocationX:newXLoc Y:rook.yLoc]; // TODO: Unfuck this.
  return YES;
}

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team
//Move to Board
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
//Move to Board
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
      attacked = [self getEnPassantPawnX:xLoc Y:yLoc];
    }
    bReturn = [self attemptCaptureOf:attacked byTeam:curPiece.team];
  } else {
    bReturn = YES;
  }
  if(bReturn)
    [self promotePawn:curPiece Y:yLoc];
  return bReturn;
}

- (NSMutableArray *)possibleMoves:(Piece *)piece BoardState:(NSMutableArray *)boardState
//TODO Detect check in here somewhere?!!?!?!
{
  switch(piece.type) {
    case PAWN:
      return [self pawnMoves:piece BoardState:boardState];
      break;
    case KNIGHT:
      return [self knightMoves:piece BoardState:boardState];
      break;
    case ROOK:
      return [self rookMoves:piece BoardState:boardState];
      break;
    case BISHOP:
      return [self bishopMoves:piece BoardState:boardState];
      break;
    case QUEEN:
      return [self queenMoves:piece BoardState:boardState];
      break;
    case KING:
      return [self kingMoves:piece BoardState:boardState];
      break;
  }
}

- (NSMutableArray *)pawnMoves:(Piece *)piece BoardState:boardState
{
  NSMutableArray *array = [NSMutableArray array];
  int direction = [piece team] == DARK ? 1 : -1;

  for (int i = -1; i <= 1; i++)
  {
    int xLoc = piece.xLoc + i;
    int yLoc = piece.yLoc + direction;

    Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
    if ([self pawnCanMove:piece X:xLoc Y:yLoc BoardState:boardState]){
      [array addObject:move];
    }
  }

  int xLoc = piece.xLoc;
  int yLoc = piece.yLoc + 2*direction;

  Move *move = [[Move alloc] initWithPiece:piece X:xLoc Y:yLoc];
  if ([self pawnCanMove:piece X:xLoc Y:yLoc BoardState:boardState]){
    [array addObject:move];
  }

  return array;
}

- (NSMutableArray *)knightMoves:(Piece *)piece BoardState:boardState
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
      Piece *otherPiece = [self getPieceAtX:xLoc Y:yLoc BoardState:boardState];

      if ([self knightCanMove:piece X:xLoc Y:yLoc BoardState:boardState]){
        if ((!otherPiece || otherPiece.team != piece.team)){
           [array addObject:move];
        }
      }
    }
  }
  return array;
}

- (NSMutableArray *)rookMoves:(Piece *)piece BoardState:boardState
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
        Piece *otherPiece = [self getPieceAtX:xLoc Y:yLoc BoardState:boardState];

        if ([self rookCanMove:piece X:xLoc Y:yLoc BoardState:boardState] && [self onBoardX:xLoc Y:yLoc]){
          if ((!otherPiece || otherPiece.team != piece.team)){
           [array addObject:move];
          }
        }
      }
    }
  }
  return array;
}

- (NSMutableArray *)bishopMoves:(Piece *)piece BoardState:boardState
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

        if ([self bishopCanMove:piece X:xLoc Y:yLoc BoardState:boardState] && [self onBoardX:xLoc Y:yLoc]){
          if ((!otherPiece || otherPiece.team != piece.team)){
           [array addObject:move];
          }
        }
      }
    }
  }
  return array;
}

- (NSMutableArray *)queenMoves:(Piece *)piece BoardState:boardState
{
  NSMutableSet *setA = [NSMutableSet setWithArray:[self bishopMoves:piece BoardState:boardState]];
  NSMutableSet *setB = [NSMutableSet setWithArray:[self rookMoves:piece BoardState:boardState]];

  [setA unionSet:setB];

  NSMutableArray *array = [NSMutableArray arrayWithArray:[setA allObjects]];

  return array;
}


- (NSMutableArray *)kingMoves:(Piece *)piece BoardState:boardState
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

      if ([self kingCanMove:piece X:xLoc Y:yLoc BoardState:boardState]){
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
      if([self kingCanCastle:piece X:x Y:piece.yLoc BoardState:boardState]){
          Move *move = [[Move alloc] initWithPiece:piece X:x Y:piece.yLoc];
          [array addObject:move];
      }
    }
  }

  return array;
}

- (BOOL)pawnThreatensSquare:(Piece *)pawn X:(int)xLoc Y:(int)yLoc BoardState:boardState
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

- (BOOL)squareUnderAttackByTeam:(Team)team X:(int)xLoc Y:(int)yLoc BoardState:boardState
{
  for (Piece *piece in self.board.pieces){
    if(piece.bCaptured || piece.team != team)
      continue;

    if(xLoc == piece.xLoc && yLoc == piece.yLoc)
      continue;

    switch(piece.type) {
      case PAWN:
        if([self pawnThreatensSquare:piece X:xLoc Y:yLoc BoardState:boardState])
          return YES;
        break;
      case KNIGHT:
        if([self knightCanMove:piece X:xLoc Y:yLoc BoardState:boardState])
          return YES;
        break;
      case ROOK:
        if([self rookCanMove:piece X:xLoc Y:yLoc BoardState:boardState])
          return YES;
        break;
      case BISHOP:
        if([self bishopCanMove:piece X:xLoc Y:yLoc BoardState:boardState])
          return YES;
        break;
      case QUEEN:
        if([self queenCanMove:piece X:xLoc Y:yLoc BoardState:boardState])
          return YES;
        break;
      case KING:
        if([self kingCanMove:piece X:xLoc Y:yLoc BoardState:boardState])
          return YES;
        break;
    }
  }

  return NO;
}

- (BOOL)detectCheck:(Move *)move BoardState:boardState
{
  Piece* attacked = nil;

  int kingX;
  int kingY;

  if(move.piece.type == KING) {
    kingX = move.xLoc;
    kingY = move.yLoc;
  } else {
    Piece* king = [self.board getKing:move.piece.team];
    kingX = king.xLoc;
    kingY = king.yLoc;

    attacked = [self getPieceAtX:move.xLoc Y:move.yLoc BoardState:boardState];
    attacked.bCaptured = YES;
  }

  Team enemy = move.piece.team == DARK ? LIGHT : DARK;

  [self.board futureBoard:move]; // Don't do this too early or it breaks :(
  BOOL ret = [self squareUnderAttackByTeam:enemy X:kingX Y:kingY BoardState:boardState];

  if(attacked) {
    attacked.bCaptured = NO;
  }

  [self.board updateAllSquares];

  return ret;
}

@end
