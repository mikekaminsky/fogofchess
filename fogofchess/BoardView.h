//
//  BoardView.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Piece;


@interface BoardView : UIImageView

@property float squareWidth;
@property(nonatomic, strong) NSArray *pieces;

- (id)initWithImage:(UIImage *)image width:(float)fullWidth;

- (bool)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc;

@end
