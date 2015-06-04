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


@implementation Board

static NSMutableArray *allSquares;
static NSMutableArray *highlights;
static Move *lastMove;
static Piece *selected;

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

    self.moves = [NSMutableArray array];

    self.darkCapturedCount = 0;
    self.lightCapturedCount = 0;

    self.engine = [[GameEngine alloc] initWithBoard:self];

    self.turnMarker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.turnMarker.frame = CGRectMake(3.5 * self.squareWidth, 8 * self.squareWidth, fullWidth/6, fullWidth/16);
    [self.turnMarker setTitle:@"My turn!" forState:UIControlStateNormal];

    [self addSubview: self.turnMarker];

    self.contentMode = UIViewContentModeScaleAspectFit;
    [self enableInteraction];

    self.pieces = [[NSArray alloc] initWithArray:[self populatePieces]];
    [self setPieces];

    lastMove = nil;
    selected = nil;
  }

  return self;
}

//setup

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
  Piece *newPiece = [[Piece alloc] initWithBoard:self];
  [array addObject:newPiece];
  [self addSubview:newPiece];

  return newPiece;
}

- (NSMutableArray *)populatePieces
{
  NSMutableArray *arrayOfPieces = [NSMutableArray array];
  for (int i = 0; i < BOARD_SIZE * 4; i++) {
    [self addPieceToArray:arrayOfPieces];
  }

  return arrayOfPieces;
}

- (void) setPieces
{
  for (int i = 0; i < BOARD_SIZE * 4; i++) {
    Piece *piece = self.pieces[i];

    piece.bCaptured = false;
    piece.bEverMoved = false;



    CGRect frame = piece.frame;
    frame.size.width = self.squareWidth;
    frame.size.height = self.squareWidth;
    piece.frame = frame;

    if (i < BOARD_SIZE) {
      [piece setLocationX:i%BOARD_SIZE Y:1];
      [piece setTeam:DARK andType:PAWN];
    } else if(i < BOARD_SIZE * 2){
      [piece setLocationX:i%BOARD_SIZE Y:BOARD_SIZE - 2];
      [piece setTeam:LIGHT andType:PAWN];
    }
    else {

      Type newType = PAWN;
      switch(i%BOARD_SIZE) {
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

      if (i < BOARD_SIZE * 3) {
        [piece setLocationX:i%BOARD_SIZE Y:0];
        [piece setTeam:DARK andType:newType];
      } else {
        [piece setLocationX:i%BOARD_SIZE Y:7];
        [piece setTeam:LIGHT andType:newType];
      }
    }
  }

  [self updateAllSquares];
}

//public methods

- (void)resetGame
{
  [self setPieces];

  lastMove = nil;
  self.turn = 0;
  self.darkCapturedCount = 0;
  self.lightCapturedCount = 0;

  [self clearSelection];
  [self.moves removeAllObjects];

  self.turnMarker.frame = CGRectMake(3.5 * self.squareWidth, 8 * self.squareWidth, self.frame.size.width/6, self.frame.size.width/16);
}

- (void)updateAllSquares
{
  //Clear array
  for (int i=0; i < BOARD_SIZE * BOARD_SIZE; i++)
    [allSquares replaceObjectAtIndex:i withObject:[NSNull null]];

  //Ask each piece where in the array they belong
  for (Piece *curPiece in self.pieces){
    if (!curPiece.bCaptured){
      int newIndex = curPiece.yLoc * BOARD_SIZE + curPiece.xLoc;
      if (newIndex >= 0 && newIndex < BOARD_SIZE * BOARD_SIZE){
        [allSquares replaceObjectAtIndex:newIndex withObject:curPiece];
      }
    }
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


- (Piece *)getKing:(Team)team
{

  for (int i = 0; i<self.pieces.count; i++) {
    Piece *piece = self.pieces[i];
    if (piece.type == KING && piece.team == team){
      return piece;
    }
  }

  return nil;
}


- (BOOL)isUnoccupiedX:(int)xLoc Y:(int)yLoc {
  return [self getPieceAtX:xLoc Y:yLoc] == nil;
}

- (void)executeMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  BOOL bMoved = [self.engine executeMove:curPiece X:xLoc Y:yLoc];
  if(bMoved) {
    [self nextTurn];
    [self recordMove:curPiece X:xLoc Y:yLoc];

    curPiece.bEverMoved = YES;
    [curPiece setLocationX:xLoc Y:yLoc];
    [self updateAllSquares];
  }
}

- (void)capturePiece:(Piece *)piece
{
  piece.bCaptured = true;

  if(piece.team == DARK) {

    CGRect frame = piece.frame;
    frame.origin.x = self.lightCapturedCount * self.squareWidth / 2;
    frame.origin.y = (BOARD_SIZE + 0.5)  * self.squareWidth;

    frame.size.width = self.squareWidth/2;
    frame.size.height = self.squareWidth/2;

    piece.frame = frame;

    self.lightCapturedCount++;
  } else {

    CGRect frame = piece.frame;
    frame.origin.x = self.darkCapturedCount * self.squareWidth / 2;
    frame.origin.y = -self.squareWidth;

    frame.size.width = self.squareWidth/2;
    frame.size.height = self.squareWidth/2;

    piece.frame = frame;

    self.darkCapturedCount++;
  }

  if (piece.type == KING){
    //[self.gameViewController showWinscreen];
    [self resetGame];
  }
  else {
    [self updateAllSquares];
  }
}

- (void)selectPiece:(Piece *)curPiece
{
  if((self.turn % 2 == 0 && curPiece.team == DARK) ||
      (self.turn % 2 == 1 && curPiece.team == LIGHT)) {
    [self clearSelection];
    return;
  }

  [self highlightPossibleMoves:curPiece];

  [curPiece highlight:YES];
  selected = curPiece;
}

- (void)clearSelection
{
  [self clearHighlights];

  [selected highlight:NO];
  selected = nil;
}


- (Piece *) getEnPassantPawnX:(int)xLoc Y:(int)yLoc{
  int yDiff = abs(lastMove.yLoc - lastMove.oldYLoc);
  int attackY = lastMove.piece.team == DARK ? 2 : 5;
  if( lastMove.piece.type == PAWN
      && xLoc == lastMove.xLoc
      && yDiff == 2
      && yLoc == attackY )
    return lastMove.piece;

  return nil;
}

//interaction

- (void)singleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
  CGPoint location = [gestureRecognizer locationInView: self];
  int xLoc = (int)location.x/self.squareWidth;
  int yLoc = (int)location.y/self.squareWidth;

  if(selected) {
    [self executeMove:selected X:xLoc Y:yLoc];
    [self clearSelection];
  }
  else
  {
    Piece *piece = [self getPieceAtX:xLoc Y:yLoc];
    if(piece) {
      [self selectPiece:piece];
    }
  }
}

//private

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


- (void)highlightPossibleMoves:(Piece *)curPiece
{
  NSMutableArray *array = [self.engine possibleMoves:curPiece];

  for (Move *move in array) {
    int xLoc = move.xLoc;
    int yLoc = move.yLoc;
    [self highlightSquareX:xLoc Y:yLoc];
    NSLog(@"%d",xLoc);
  }

  [array removeAllObjects];
}

- (void)clearHighlights
{
  for(UIImageView* view in highlights) {
    [view removeFromSuperview];
  }

  [highlights removeAllObjects];
}

- (void)futureBoard:(Move *)move
{
  int oldIndex = move.oldYLoc * BOARD_SIZE + move.oldXLoc;
  int newIndex = move.yLoc * BOARD_SIZE + move.xLoc;
  [allSquares replaceObjectAtIndex:oldIndex withObject:[NSNull null]];
  [allSquares replaceObjectAtIndex:newIndex withObject:move.piece];
}

@end
