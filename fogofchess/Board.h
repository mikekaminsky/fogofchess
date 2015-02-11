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


@interface Board : UIImageView

@property float squareWidth;

@property(nonatomic, strong) NSArray *pieces;

- (id)initWithImage:(UIImage *)image width:(float)fullWidth;

- (Piece *)addPieceToArray:(NSMutableArray *)array;

- (NSMutableArray *)populatePieces;

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)pawnCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)knightCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)isUnoccupied:(int)xLoc Y:(int)yLoc;

- (Piece *)getPieceAtX:(int)xLoc Y:(int)yLoc;

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team;

@end