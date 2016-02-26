//
//  EmuyMother.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/28/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "Emu.h"

typedef enum EmuMotherState
{
	EM_WALKING = 0,
	EM_IDLING,
} EmuMotherState;

//making EmuMother a subclass of Emu, because i just want emu's update method.
@interface EmuMother : Emu
{
	EmuMotherState state;
	float state_timeout; //set with state, decremented in update, triggers state change when expired.
	CGRect bounds; //where we will wander around.
}

@end
