//
//  Entity.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sprite;
@class TileWorld;

@interface Entity : NSObject
{
	Sprite    *sprite;
	TileWorld *world; //set when this entity is added to a TileWorld via addEntity.  used for tile collision detection.
    CGPoint   worldPos; //specifies origin for physical representation in the game world.  in pixels.

}

@property (nonatomic, retain) Sprite  *sprite;
@property (nonatomic) CGPoint position;

- (id) initWithPos:(CGPoint) pos sprite:(Sprite *)sprite;
- (void) drawAtPoint:(CGPoint) offset;
- (void) update:(CGFloat) time;
- (void) setWorld:(TileWorld*) newWorld;
- (void) forceToPos:(CGPoint) pos;

@end
