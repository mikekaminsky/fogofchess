//
//  BoardView.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@class Piece;
@class GameEngine;
@class Move;
@class GameViewController;


@interface Board : UIImageView

@property float squareWidth;
@property int lightCapturedCount;
@property int darkCapturedCount;
@property int turn;

@property(nonatomic, strong) NSMutableArray *moves;

@property(nonatomic, strong) NSArray *pieces;

@property(nonatomic, strong) GameEngine *engine;

@property(nonatomic, strong) GameViewController *gameViewController;

@property(nonatomic, strong) UIButton *turnMarker;

- (id)initWithWidth:(float)fullWidth controller:(GameViewController *)viewController;

- (void)resetGame;

- (void)enableInteraction;

- (Piece *)addPieceToArray:(NSMutableArray *)array;

- (NSMutableArray *)populatePieces;

- (void)updateAllSquares:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)isUnoccupiedX:(int)xLoc Y:(int)yLoc;

- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc;

- (BOOL)executeMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (void)capturePiece:(Piece *)piece;

- (void)nextTurn;

- (void)recordMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (void)clearSelection;

- (void)highlightPossibleMoves:(Piece *)curPiece On:(BOOL) bOn;

- (Piece *) getEnPassantPawnX:(int)xLoc Y:(int)yLoc;


@end
