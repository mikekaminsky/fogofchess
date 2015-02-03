//
//  Piece.m
//  fogofchess
//
//  Created by Case Commons on 2/2/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#import "Piece.h"

@implementation Piece

- (id)initWithImage:(UIImage *)image width:(float)squareWidth
{
    self = [super initWithImage:image];
    
    if(self) {
        self.frame = CGRectMake(0, 0, squareWidth, squareWidth);
        [self setContentMode:UIViewContentModeScaleAspectFit];
        self.userInteractionEnabled = YES;
        self.squareWidth = squareWidth;
        
        UIPanGestureRecognizer *singleFingerTap = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(panAnim:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    
    return self;
}

//The event handling method
-(void) panAnim:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer.view superview]];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //Highlight potential moves.
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        int xLoc = (int)location.x/self.squareWidth;
        int yLoc = (int)location.y/self.squareWidth;
        
        self.xLoc = xLoc;
        self.yLoc = yLoc;
        
        CGRect frame = self.frame;
        frame.origin.x = self.xLoc * self.squareWidth; // new x coordinate
        frame.origin.y = self.yLoc * self.squareWidth; // new y coordinate
        self.frame = frame;
    }
}

@end
