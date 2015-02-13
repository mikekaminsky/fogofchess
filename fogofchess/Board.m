//
//  BoardView.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "Board.h"
#import "Piece.h"
#import "GameEngine.h"

@implementation Board {
   NSMutableArray *allSquares;
}


- (id)initWithImage:(UIImage *)image width:(float)fullWidth
{
  self = [super initWithImage:image];
  if(self) {
    allSquares = [NSMutableArray array];
    for (int i=0; i < BOARD_SIZE * BOARD_SIZE; i++)
      [allSquares addObject:[NSNull null]];//initWithCapacity:BOARD_SIZE * BOARD_SIZE];

    self.squareWidth = (fullWidth - 2) / BOARD_SIZE;

    int ycoord = (590 - fullWidth)/2 + 20;
    self.frame = CGRectMake(0, ycoord, fullWidth, fullWidth);

    self.pieces = [[NSArray alloc] initWithArray:[self populatePieces]];
    self.engine = [[GameEngine alloc] initWithBoard:self];

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
  for (int i = 0; i < BOARD_SIZE; i++) {
    Piece *newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:1];
    [newPiece setTeam:LIGHT andType:PAWN];

    newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:BOARD_SIZE-2];
    [newPiece setTeam:DARK andType:PAWN];
  }

  for (int i = 0; i < BOARD_SIZE; i++) {
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

- (void)updateAllSquares:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int oldIndex = curPiece.yLoc * BOARD_SIZE + curPiece.xLoc;
  int newIndex = yLoc * BOARD_SIZE + xLoc;

  [allSquares replaceObjectAtIndex:oldIndex withObject:[NSNull null]];
  
  if(!curPiece.bCaptured) {
    [allSquares replaceObjectAtIndex:newIndex withObject:curPiece];
  }
}


- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc
{
  Piece *p = [allSquares objectAtIndex:yLoc*BOARD_SIZE+xLoc];
  if([p isEqual:[NSNull null]] || p.bCaptured == YES)
    return nil;
  return p;
}

- (BOOL)isUnoccupiedX:(int)xLoc Y:(int)yLoc {
  return [self getPieceAtX:xLoc Y:yLoc] == nil;
}

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
    return [self.engine canMove:curPiece X:xLoc Y:yLoc];
}

@end
