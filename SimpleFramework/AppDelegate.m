//
//  AppDelegate.m
//  SimpleFramework
//
//  Created by Genaro Codina Reverter on 12/24/12.
//  Copyright (c) 2012 com.codina.genar. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GSMainMenu.h"
#import "ResourceManager.h"

@interface AppDelegate()
{
    //ivars for tracking frames per second
	int            _fps;
    CFTimeInterval _fpsLastSecondStart;
	int            _fpsFramesThisSecond;
    
    //ivar for the resource manager
    ResourceManager *resourceManager;
}
@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    resourceManager = [ResourceManager sharedInstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.viewController = [[ViewController alloc] initWithNibName:@"GSMainMenu_iPhone" bundle:nil];
    }
    else
    {
        self.viewController = [[ViewController alloc] initWithNibName:@"GSMainMenu_iPad" bundle:nil];
    }
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.viewController.view = [[GSMainMenu alloc]  initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height) andManager:self];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //set up the game loop
    [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(gameLoop:) userInfo:nil repeats:NO];
    
    [self changeState:[GSMainMenu class]];
    
    return YES;
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (int) getFramesPerSecond
{
	return _fps;
}

- (void) changeState:(Class)state
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
    
	if (self.viewController.view != nil)
    {
		[self.viewController.view removeFromSuperview]; //remove view from window's subviews.
	}
	CGRect screenSize = [[UIScreen mainScreen] bounds];
	self.viewController.view = [[state alloc]  initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height) andManager:self];
	
	//now set our view as visible
    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    
    [UIView commitAnimations];
}

- (void) gameLoop:(id) sender
{
	double currTime = [[NSDate date] timeIntervalSince1970];
	_fpsFramesThisSecond++;
	float timeThisSecond = currTime - _fpsLastSecondStart;
	if( timeThisSecond > 1.0f )
    {
		_fps = _fpsFramesThisSecond;
		_fpsFramesThisSecond = 0;
		_fpsLastSecondStart = currTime;
	}

	[((GameState *)self.viewController.view) update];
	[((GameState *)self.viewController.view) render];
	[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(gameLoop:) userInfo:nil repeats:NO];
}

@end
