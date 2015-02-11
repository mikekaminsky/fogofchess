//
//  Constants.h
//  fogofchess
//
//  Created by Case Commons on 2/9/15.
//  Copyright (c) 2015 Kaminsky. All rights reserved.
//

#ifndef fogofchess_Constants_h
#define fogofchess_Constants_h

typedef NS_ENUM(NSInteger, Team) {
  DARK = 0,
  LIGHT,
  TeamCount
};

typedef NS_ENUM(NSInteger, Type) {
  PAWN = 0,
  KNIGHT,
  BISHOP,
  ROOK,
  QUEEN,
  KING,
  TypeCount
};

extern NSString *const TypeName[TypeCount];
extern NSString *const TeamName[TeamCount];

#endif
