//
//  TileWorld.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

//global tile size.
#define TILE_SIZE 32

@class Tile;
@class Entity;

@interface TileWorld : NSObject
{
	Tile           ***tiles;
	NSMutableArray *entities;
	CGRect view; //typically will be the same rect as the screen.  in pixels.  considered to be in opengl coordinates (0, 0 in bottom left)
	int world_width, world_height; //in tiles.  defines the dimensions of ***tiles.
	int camera_x, camera_y; //in pixels, relative to world origin (0, 0).  view will be centered around this point.
}

- (void) loadLevel:(NSString*) levelFilename withTiles:(NSString*)imageFilename;

- (TileWorld *) initWithFrame:(CGRect) frame;
- (void) draw;
- (void) setCamera:(CGPoint)position;
- (CGPoint) worldPosition:(CGPoint)screenPosition;

- (void) addEntity:(Entity*) entity;
- (void) removeEntity:(Entity*) entity;
- (Tile *) tileAt:(CGPoint)worldPosition;
- (BOOL) walkable:(CGPoint) point;

//used in croc level to figure out what our player can jump to.
- (NSArray*) entitiesNear:(CGPoint) point withRadius:(float) radius;

@property (readonly) int world_width, world_height;

@end
