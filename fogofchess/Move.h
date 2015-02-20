//
//  Move.h
//  fogofchess
//
//  Created by Case Commons on 2/19/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Piece.h"

@interface Move : NSObject
  @property(nonatomic, strong) Piece *piece;
  @property int xLoc;
  @property int yLoc;
  @property int oldYLoc;
  @property int oldXLoc;

  -(id)initWithPiece:(Piece *)piece X:(int)xLoc Y:(int)yLoc;

  -(NSString *)toS;
@end
