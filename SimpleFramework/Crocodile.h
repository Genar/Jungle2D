//
//  Crocodile.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/28/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Crocodile : Entity

- (bool) under:(CGPoint)point;
- (void) attack:(Entity *)other;

@end
