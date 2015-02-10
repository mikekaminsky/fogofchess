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
            Piece *newPiece = [self addPieceToArray:arrayOfPieces];
            
            [newPiece changeLocationX:i Y:1];
            [newPiece setTeam:LIGHT andType:PAWN];
        }
        for (int i = 0; i < 8; i++) {
            Piece *newPiece = [self addPieceToArray:arrayOfPieces];
            
            [newPiece changeLocationX:i Y:6];
            [newPiece setTeam:DARK andType:PAWN];
        }

        self.pieces = [[NSArray alloc] initWithArray:arrayOfPieces];
    }

    return self;
}

- (Piece *)addPieceToArray:(NSMutableArray *)array
{
    CGRect frame = CGRectMake(0, 0, self.squareWidth, self.squareWidth);
    Piece *newPiece = [[Piece alloc] initWithFrame:frame withBoard:self];
    [array addObject:newPiece];
    [self addSubview:newPiece];
    
    return newPiece;
}

- (BOOL)canMove:(Piece *)curPiece X:(int)xLoc Y:(int)yLoc
{
  int direction = [curPiece team]==DARK ? -1 : 1;
  if([curPiece xLoc] == xLoc &&
      (yLoc - [curPiece yLoc] == 1*direction || yLoc - [curPiece yLoc] == 2*direction )) {
    return YES;
  }
  return NO;
}

@end
