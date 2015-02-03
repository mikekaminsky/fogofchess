//
//  Piece.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Piece : UIImageView

@property int xLoc;
@property int yLoc;

@property float squareWidth;

- (id)initWithImage:(UIImage *)image width:(float)squareWidth;

@end
