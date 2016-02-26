//
//  Animation.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/27/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationSequence : NSObject
{
    @public
        int     frameCount;
        float   *timeout;
        CGRect  *frames;
        bool    flipped;
        NSString *next;
}

- (AnimationSequence *) initWithFrames:(NSDictionary *) animData width:(float) width height:(float) height;

@end


@interface Animation : NSObject
{
	NSString *image;
	NSMutableDictionary *sequences;
	CGPoint anchor;
}

- (Animation *) initWithAnim:(NSString*) img;
- (void) drawAtPoint:(CGPoint) point withSequence:(NSString *) sequence withFrame:(int) frame;
- (int) getFrameCount:(NSString*) sequence;
- (NSString *) firstSequence;
- (AnimationSequence *) get:(NSString*) sequence;

@end