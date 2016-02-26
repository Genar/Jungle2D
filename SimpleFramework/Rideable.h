//
//  Rideable.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entity.h"

@interface Rideable : Entity
{
	CGRect bounds;
	Entity *m_rider;
	int    sunkframe;
}

- (bool) under:(CGPoint) point;
- (void) markRidden:(Entity*) rider;

@end
