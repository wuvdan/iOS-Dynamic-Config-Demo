//
//  SceneDelegate.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "SceneDelegate.h"
#import "WDAlterManager.h"
#import "URLSchemeManager.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [connectionOptions.URLContexts enumerateObjectsUsingBlock:^(UIOpenURLContext * _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"%@", obj.URL);
            [URLSchemeManager openPageWithURLString:obj.URL.absoluteString controller:self.window.rootViewController];
        }];
    });
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    [URLContexts enumerateObjectsUsingBlock:^(UIOpenURLContext * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj.URL);
        [URLSchemeManager openPageWithURLString:obj.URL.absoluteString controller:self.window.rootViewController];
    }];
}

@end
