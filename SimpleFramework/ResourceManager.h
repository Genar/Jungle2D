//
//  ResourceManager.h
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLTexture.h"
#import "GLFont.h"

#define STORAGE_FILENAME @"appstorage"

@interface ResourceManager : NSObject

+ (ResourceManager *) sharedInstance; //Returns the singleton instance
+ (NSString *) appendStorePath:(NSString*) filename;

- (void) shutdown;

//loads and buffers images as 2d opengles textures.
- (GLTexture *) getTexture: (NSString*) filename;
- (void) purgeTextures;

- (void) setupSound; //intialize the sound device.  Takes a non-trivial amount of time, and should be called during initialization.
- (UInt32) getSound:(NSString*) filename; //useful for preloading sounds; called automatically by playSound.  Buffers sounds.
- (void) purgeSounds;
- (void) playSound:(NSString*) filename; //play a sound.  Loads and buffers the sound if needed.
- (void) playMusic:(NSString*)filename; //play and loop a music file in the background.  streams the file.
- (void) stopMusic; //stop the music.  unloads the currently playing music file.

//useful for loading binary files that you include in the program bundle, such as game level data
- (NSData*) getBundleData:(NSString*) filename;

//for saving preferences or other game data.  This is stored in the documents directory, and may persist between app version updates.
- (BOOL) storeUserData:(id) data toFile:(NSString*) filename;
//for loading prefs or other data saved with storeData.  Returns nil if the file does not exist.
- (id) getUserData:(NSString*) filename;
- (BOOL) userDataExists:(NSString*) filename;

- (GLFont *) defaultFont;
- (void) setDefaultFont: (GLFont *) newValue;

@end
