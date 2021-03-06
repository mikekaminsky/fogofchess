//
//  Constants.h
//  fogofchess
//
//  Created by Case Commons on 2/9/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#ifndef fogofchess_Constants_h
#define fogofchess_Constants_h

#define BOARD_SIZE 8

typedef NS_ENUM(NSInteger, Team) {
  DARK = 0,
  LIGHT
};

typedef NS_ENUM(NSInteger, Type) {
  PAWN = 0,
  KNIGHT,
  BISHOP,
  ROOK,
  QUEEN,
  KING
};

extern NSString *const TypeName[];
extern NSString *const TeamName[];

#endif
