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


@interface Board : UIImageView

@property float squareWidth;

@property(nonatomic, strong) NSArray *pieces;

@property(nonatomic, strong) GameEngine *engine;

@property int lightCapturedCount;
@property int darkCapturedCount;

- (id)initWithImage:(UIImage *)image width:(float)fullWidth;

- (Piece *)addPieceToArray:(NSMutableArray *)array;

- (NSMutableArray *)populatePieces;

- (void)updateAllSquares:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)isUnoccupiedX:(int)xLoc Y:(int)yLoc;

- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc;

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (void)capturePiece:(Piece *)piece;

@end
