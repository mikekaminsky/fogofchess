//
//  Piece.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@class Board;


@interface Piece : UIImageView

@property (strong, nonatomic) Board *board;

@property int xLoc;
@property int yLoc;

@property Type type;
@property Team team;

@property BOOL bCaptured;

@property BOOL bEverMoved;

- (id)initWithBoard:(Board *)gameBoard;

- (void)enableInteraction;

- (void)changeLocationX:(int)xLoc Y:(int)yLoc;

- (void)setTeam:(Team)newTeam andType:(Type)newType;

- (void)highlight:(BOOL)bOn;

@end
