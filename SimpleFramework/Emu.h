//
//  Emu.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entity.h"

@interface Emu : Entity
{
	CGPoint worldSpeed;
	CGPoint nextSpeed;
	CGPoint collision_tweak;
	bool runawaymode;
}

@property (nonatomic) bool runawaymode;

- (id) initWithPos:(CGPoint)pos sprite:(Sprite *)spr;
-(void) flockAgainst:(Emu **)others count:(int)count;
- (void) avoid:(Entity *) other;
- (void) goal:(Entity *) other;
- (void) update:(CGFloat) time;

@end
