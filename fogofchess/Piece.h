//
//  Piece.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoardView;

typedef NS_ENUM(NSInteger, Team) {
    DARK,
    LIGHT
};

typedef NS_ENUM(NSInteger, Type) {
    PAWN,
    KNIGHT,
    BISHOP,
    ROOK,
    QUEEN,
    KING,
};

@interface Piece : UIImageView

@property (strong, nonatomic) BoardView *board;

@property int xLoc;
@property int yLoc;

@property char type;
@property char team;

@property float squareWidth;

- (id)initWithFrame:(CGRect)frame withBoard:(BoardView *)gameBoard;

- (void)attemptMoveX:(int)xLoc Y:(int)yLoc;

- (void)changeLocationX:(int)xLoc Y:(int)yLoc;

- (void)setTeam:(Team)newTeam andType:(Type)newType;

- (void)capture;

@end
