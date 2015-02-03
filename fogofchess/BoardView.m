//
//  BoardView.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "BoardView.h"
#import "Piece.h"

@implementation BoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithImage:(UIImage *)image width:(float)fullWidth
{
    self = [super initWithImage:image];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    
    self.userInteractionEnabled = YES;
    self.squareWidth = fullWidth/8;
    
    Piece *piece = [[Piece alloc] initWithImage: [UIImage imageNamed:@"Chess_plt60"]];
    piece.frame = CGRectMake(0, 0, self.squareWidth, self.squareWidth);
    [piece setContentMode:UIViewContentModeScaleAspectFit];
    piece.userInteractionEnabled = YES;
    
    [self addSubview:piece];
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    int xLoc = (int)location.x/self.squareWidth;
    int yLoc = (int)location.y/self.squareWidth;
    
    NSLog(@"Whereami x:%d,y:%d", xLoc, yLoc);
}

@end
