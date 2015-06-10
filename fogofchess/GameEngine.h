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
@class Move;

@interface GameEngine : NSObject

@property (strong, nonatomic) Board *board;

- (NSMutableArray *)possibleMovesByTeam:(Team)team WithBoard:(NSMutableArray *)boardState LastMove:(Move *)lastMoveFromBoard;

@end
