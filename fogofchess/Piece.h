//
//  Piece.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoardView;


@interface Piece : UIImageView

@property int xLoc;
@property int yLoc;

@property float squareWidth;
@property (strong, nonatomic) BoardView *board;

- (id)initWithImage:(UIImage *)image withBoard:(BoardView *)gameBoard;

- (void)attemptMoveX:(int)xLoc Y:(int)yLoc;

- (void)changeLocationX:(int)xLoc Y:(int)yLoc;

@end
