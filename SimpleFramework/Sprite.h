//
//  Sprite.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

@class Animation;

#import <Foundation/Foundation.h>

@interface Sprite : NSObject
{
    Animation *anim;
	NSString  *sequence;
	float     sequence_time;
	int       currentFrame;
}

@property (nonatomic, retain) Animation *anim;
@property (nonatomic, retain) NSString *sequence;
@property (nonatomic, readonly) int currentFrame; //made accessible for Rideable

+ (Sprite *) spriteWithAnimation:(Animation*) anim;
- (void) drawAtPoint:(CGPoint) point;
- (void) update:(float) time;

@end
