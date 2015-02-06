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
    if(self) {
        [self setContentMode:UIViewContentModeScaleAspectFit];
        
        self.userInteractionEnabled = YES;
        self.squareWidth = fullWidth/8;
        
        int ycoord = (590 - fullWidth)/2 + 20;
        self.frame = CGRectMake(0, ycoord, fullWidth, fullWidth);
        
        Piece *piece = [[Piece alloc] initWithImage: [UIImage imageNamed:@"Chess_plt60"] width:self.squareWidth];
        
        [piece setXLoc:3];
        [piece setYLoc:4];
        
        CGRect frame = piece.frame;
        frame.origin.x = [piece xLoc] * self.squareWidth; // new x coordinate
        frame.origin.y = [piece yLoc] * self.squareWidth; // new y coordinate
        piece.frame = frame;

        [self addSubview:piece];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                   action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //CGPoint location = [[touches anyObject] locationInView:self];
    //[[self superview] bringSubviewToFront:self];
}

//The setup code (in viewDidLoad in your view controller)


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    
    int xLoc = (int)location.x/self.squareWidth;
    int yLoc = (int)location.y/self.squareWidth;
    
    //NSLog(@"Whereami x:%d,y:%d", xLoc, yLoc);
    NSLog(@"Whereami x:%f,y:%f", location.x, location.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
