//
//  BoardView.h
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardView : UIImageView

- (id)initWithImage:(UIImage *)image width:(float)fullWidth;

@property float squareWidth;
@property(nonatomic, strong) NSArray *pieces;

@end
