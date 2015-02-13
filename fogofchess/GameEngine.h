//
//  GameEngine.h
//  fogofchess
//
//  Created by Case Commons on 2/11/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Board;
@class Piece;

@interface GameEngine : NSObject

@property (strong, nonatomic) Board *board;

- (id)initWithBoard:(Board *)board;

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)pawnCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)knightCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)rookCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)bishopCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)queenCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)kingCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)attemptCaptureOf:(Piece *)attacked byTeam:(Team)team;

@end
