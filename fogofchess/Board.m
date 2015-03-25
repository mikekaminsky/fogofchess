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
#import "GameViewController.h"
#import "Move.h"


@implementation Board {
   NSMutableArray *allSquares;
   NSMutableArray *highlights;
   Move *lastMove;
   Piece *selected;
}

- (id)initWithWidth:(float)fullWidth controller:(GameViewController *)viewController
{
  self = [super initWithImage:[UIImage imageNamed:@"chessboard_flip.jpg"]];
  if(self) {
    
    self.gameViewController = viewController;
    
    allSquares = [NSMutableArray array];
    for (int i=0; i < BOARD_SIZE * BOARD_SIZE; i++)
      [allSquares addObject:[NSNull null]];//initWithCapacity:BOARD_SIZE * BOARD_SIZE];
    highlights = [NSMutableArray array];
    
    self.squareWidth = (fullWidth - 2) / BOARD_SIZE;

    int ycoord = (590 - fullWidth)/2 + 20;
    self.frame = CGRectMake(0, ycoord, fullWidth, fullWidth);

    self.turn = 0;
    lastMove = nil;

    self.moves = [NSMutableArray array];

    self.darkCapturedCount = 0;
    self.lightCapturedCount = 0;

    self.pieces = [[NSArray alloc] initWithArray:[self populatePieces]];
    self.engine = [[GameEngine alloc] initWithBoard:self];

    self.turnMarker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.turnMarker.frame = CGRectMake(3.5 * self.squareWidth, 8 * self.squareWidth, fullWidth/6, fullWidth/16);
    [self.turnMarker setTitle:@"My turn!" forState:UIControlStateNormal];

    [self addSubview: self.turnMarker];

    self.contentMode = UIViewContentModeScaleAspectFit;
    [self enableInteraction];
  }

  return self;
}

- (void)enableInteraction
{
  UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(singleTapGesture:)];
  tapGestureRecognize.numberOfTapsRequired = 1;
  [self addGestureRecognizer:tapGestureRecognize];

  self.userInteractionEnabled = YES;
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
    [newPiece setTeam:DARK andType:PAWN];

    newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:BOARD_SIZE-2];
    [newPiece setTeam:LIGHT andType:PAWN];
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
    [newPiece setTeam:DARK andType:newType];

    newPiece = [self addPieceToArray:arrayOfPieces];
    [newPiece changeLocationX:i Y:7];
    [newPiece setTeam:LIGHT andType:newType];
  }

  return arrayOfPieces;
}

- (void)updateAllSquares:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int oldIndex = curPiece.yLoc * BOARD_SIZE + curPiece.xLoc;
  int newIndex = yLoc * BOARD_SIZE + xLoc;

  if(oldIndex >= 0 && oldIndex < BOARD_SIZE * BOARD_SIZE) {
    [allSquares replaceObjectAtIndex:oldIndex withObject:[NSNull null]];
  }

  if(!curPiece.bCaptured) {
    [allSquares replaceObjectAtIndex:newIndex withObject:curPiece];
  }
}

- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc
{
  if(![self.engine onBoardX:xLoc Y:yLoc])
    return nil;
  Piece *p = [allSquares objectAtIndex:yLoc*BOARD_SIZE+xLoc];
  if([p isEqual:[NSNull null]] || p.bCaptured == YES)
    return nil;
  return p;
}

- (BOOL)isUnoccupiedX:(int)xLoc Y:(int)yLoc {
  return [self getPieceAtX:xLoc Y:yLoc] == nil;
}

- (BOOL)executeMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
    BOOL bMoved = [self.engine executeMove:curPiece X:xLoc Y:yLoc];
    if(bMoved) {
      [self nextTurn];
      [self recordMove:curPiece X:xLoc Y:yLoc];
    }
    return bMoved;
}

- (void)capturePiece:(Piece *)piece
{
  piece.bCaptured = true;
  [self updateAllSquares:piece X:-1 Y:-1];

  if(piece.team == DARK) {

    CGRect frame = piece.frame;
    frame.origin.x = (self.lightCapturedCount % BOARD_SIZE) * self.squareWidth;
    frame.origin.y = (BOARD_SIZE + self.lightCapturedCount/BOARD_SIZE) * self.squareWidth + (self.squareWidth/2);
    piece.frame = frame;

    self.lightCapturedCount++;
  } else {

    CGRect frame = piece.frame;
    frame.origin.x = (self.darkCapturedCount % BOARD_SIZE) * self.squareWidth;
    frame.origin.y = (-1 - self.darkCapturedCount/BOARD_SIZE) * self.squareWidth - (self.squareWidth/2);
    piece.frame = frame;

    self.darkCapturedCount++;
  }

  if (piece.type == KING){
    [self.gameViewController showWinscreen];
  }
}

- (void)nextTurn{
  self.turn++;

  CGRect frame = self.turnMarker.frame;

  float yCoord = -0.5 * self.squareWidth;
  if(self.turn % 2 == 0) {
    yCoord = 8 * self.squareWidth;
  }

  frame.origin.y = yCoord;
  frame.origin.x = 3.5 * self.squareWidth;
  self.turnMarker.frame = frame;
}

- (void)recordMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  lastMove = [[Move alloc] initWithPiece:curPiece X:xLoc Y:yLoc];
  [self.moves addObject:[lastMove toS]];
  for (int i = 0; i<self.moves.count; i++) {
    NSLog(@"obj: %@",self.moves[i]);
  }
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
  CGPoint location = [gestureRecognizer locationInView: self];
  int xLoc = (int)location.x/self.squareWidth;
  int yLoc = (int)location.y/self.squareWidth;

  if(selected) {
    [selected attemptMoveX:xLoc Y:yLoc];
    [self clearSelection];
  }
  else
  {
    Piece *piece = [self getPieceAtX:xLoc Y:yLoc];
    if(piece) {
      selected = piece;
      [piece select:YES];
    }
  }
}

-(void) clearSelection
{
  [selected select:NO];
  selected = nil;
}

- (void)highlightSquareX:(int)xLoc Y:(int)yLoc
{
  float xCoord = xLoc * self.squareWidth;
  float yCoord = yLoc * self.squareWidth;
  CGRect frame = CGRectMake(xCoord, yCoord, self.squareWidth, self.squareWidth);

  UIImageView *highlight = [[UIImageView alloc] initWithFrame:frame];
  [highlight setImage:[UIImage imageNamed:@"white_square"]];

  highlight.alpha = 0.5;

  [highlights addObject:highlight];
  [self addSubview: highlight];
}


- (void)highlightPossibleMoves:(Piece *)curPiece On:(BOOL)bOn
{
  for(UIImageView* view in highlights) {
    [view removeFromSuperview];
  }


  NSMutableArray *array = nil;

  if(bOn && curPiece.type == PAWN){
    array = [self.engine pawnMoves:curPiece];
  }

  if(bOn && curPiece.type == KNIGHT){
    array = [self.engine knightMoves:curPiece];
  }

  if(bOn && curPiece.type == ROOK){
    array = [self.engine rookMoves:curPiece];
  }

  if(bOn && curPiece.type == BISHOP){
    array = [self.engine bishopMoves:curPiece];
  }

  if(bOn && curPiece.type == QUEEN){
    array = [self.engine queenMoves:curPiece];
  }


  if(bOn && curPiece.type == KING){
    array = [self.engine kingMoves:curPiece];
  }


  if(array) {
    for (Move *move in array) {
      int xLoc = move.xLoc;
      int yLoc = move.yLoc;
      [self highlightSquareX:xLoc Y:yLoc];
      NSLog(@"%d",xLoc);
    }
  }
}

@end
