//
//  Piece.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@class BoardView;


@interface Piece : UIImageView

@property (strong, nonatomic) BoardView *board;

@property int xLoc;
@property int yLoc;

@property Type type;
@property Team team;

- (id)initWithFrame:(CGRect)frame withBoard:(BoardView *)gameBoard;

- (void)attemptMoveX:(int)xLoc Y:(int)yLoc;

- (void)changeLocationX:(int)xLoc Y:(int)yLoc;

- (void)setTeam:(Team)newTeam andType:(Type)newType;

- (void)capture;

@end
