//
//  Tile.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	UNWALKABLE = 1,
	WATER = 2,
	EMUTEARS = 4,
} PhysicsFlags;


@interface Tile : NSObject
{
    @public
        PhysicsFlags flags;
        NSString     *textureName;
        CGRect       frame;
}

@property (nonatomic, retain) NSString* textureName;
@property (nonatomic) CGRect frame;

- (void) drawInRect:(CGRect)rect;
- (Tile *) initWithTexture:(NSString*)texture withFrame:(CGRect) fram;

@end
