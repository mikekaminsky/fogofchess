//
//  Move.m
//  fogofchess
//
//  Created by Case Commons on 2/19/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//
#import "move.h"
#import "Piece.h"
#import "Board.h"

NSString * const TypeChar[] = {
  [PAWN] = @"P",
  [KNIGHT] = @"N",
  [BISHOP] = @"B",
  [ROOK] = @"R",
  [QUEEN] = @"Q",
  [KING] = @"K"
};

NSString * const TeamChar[] = {
  [DARK] = @"D",
  [LIGHT] = @"L",
};

@implementation Move

  -(id)initWithPiece:(Piece *)piece X:(int)xLoc Y:(int)yLoc; {
    self = [super init];
    if(self) {
      self.piece = piece;
      self.xLoc = xLoc;
      self.yLoc = yLoc;
      self.oldXLoc = piece.xLoc;
      self.oldYLoc = piece.yLoc;
    }
    return self;
  }

  -(NSString *)toS{
    NSString *moveString = [NSString stringWithFormat:@"%@,%@,%d,%d",
             TypeChar[self.piece.type],
             TeamChar[self.piece.team],
             self.xLoc,
             self.yLoc];
    return moveString;
  }

@end
