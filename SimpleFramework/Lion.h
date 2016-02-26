//
//  Lion.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum LionState
{
	ASLEEP = 0,
	WAKING,
	ALERT,
	ATTACKING
} LionState;

@interface Lion : Entity
{
	LionState state;
	float state_time; //how long we have been in current state.  set in setstate, incremented in update.
	int m_rage; //roughly how long a player has been too close to the lion.  incremented in wakeagainst, used to increment state
	bool flip;
}

- (id) initWithPos:(CGPoint) pos sprite:(Sprite*)spr facingLeft:(bool)faceleft;
- (bool) wakeAgainst:(Entity *) other;
- (void) obstruct;

@end
