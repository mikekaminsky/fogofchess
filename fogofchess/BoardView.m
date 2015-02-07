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

- (id)initWithImage:(UIImage *)image width:(float)fullWidth
{
    self = [super initWithImage:image];
    if(self) {
        [self setContentMode:UIViewContentModeScaleAspectFit];

        self.userInteractionEnabled = YES;
        self.squareWidth = (fullWidth - 2) / 8;

        int ycoord = (590 - fullWidth)/2 + 20;
        self.frame = CGRectMake(0, ycoord, fullWidth, fullWidth);

        NSMutableArray *arrayOfPieces = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            Piece *newPiece = [[Piece alloc] initWithImage:[UIImage imageNamed:@"Chess_plt60"] withBoard:self];
            [newPiece changeLocationX:i Y:1];
            [arrayOfPieces addObject:newPiece];
            [self addSubview:newPiece];
        }

        self.pieces = [[NSArray alloc] initWithArray:arrayOfPieces];
    }

    return self;
}

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  if([curPiece xLoc] == xLoc &&
      (yLoc - [curPiece yLoc] == 1 || yLoc - [curPiece yLoc] == 2)) {
    return YES;
  }
  return NO;
}

@end
