//
//  BoardView.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    self.userInteractionEnabled = YES;
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    float squareWidth = self.frame.size.width/8;
    int xLoc = (int)location.x/squareWidth;
    int yLoc = (int)location.y/squareWidth;
    
    NSLog(@"Whereami x:%d,y:%d", xLoc, yLoc);
    NSLog(@"RealCoords x:%f,y:%f",location.x, location.y);
}
@end
