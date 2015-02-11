//
//  GameEngine.h
//  fogofchess
//
//  Created by Case Commons on 2/11/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Board;
@class Piece;

@interface GameEngine : NSObject

@property (strong, nonatomic) Board *board;

- (id)initWithBoard:(Board *)board;

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)pawnCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

- (BOOL)knightCanMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

@end