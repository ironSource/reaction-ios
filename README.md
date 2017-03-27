# ironSource.Reaction SDK for IOS

[![License][license-image]][license-url]
[![Pods][pod-image]][pod-url]

## Installation
### Installation from [CocoaPods](https://cocoapods.org/?q=reactionsdk).
Add dependency in your pod file
```ruby
use_frameworks!

pod 'ReactionSDK'

pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies; end
end
```

## Using the IronSource ReAction API

### Add methods to your application in Swift: 
```swift
import ReactionSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GCMReceiverDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        ISReactionApp.registerGCMServiceWithApplication(application,
                                                        deviceToken:deviceToken)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        ISReactionApp.applicationDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        ISReactionApp.applicationDidEnterBackground(application)
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        ISReactionApp.receiveRemoteNotificationWithApplication(application,
                                                               userInfo:userInfo);
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        ISReactionApp.receiveRemoteNotificationWithApplication(application,
                        userInfo:userInfo, fetchCompletionHandler:completionHandler)
    }
    
    func application(application: UIApplication,
                     didReceiveLocalNotification notification: UILocalNotification) {
        ISReactionApp.receiveLocalNotificationWithApplication(application,
                                                              notification:notification);
    }
}
```
### Add methods to your application in Objective-c
In application header add GCMReceiverDelegate interface delegate:
```objc
@import ReActionSDK;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GCMReceiverDelegate>
```

And methods in implementation:
```objc
@implementation AppDelegate
  -(void)application: (UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:
  (NSData*)deviceToken {
    [ISReactionApp registerGCMServiceWithApplication:application
                                         deviceToken:deviceToken];
  }
 
  -(void)applicationDidBecomeActive: (UIApplication*)application {
    [ISReactionApp applicationDidBecomeActive:application];
  }

  -(void)applicationDidEnterBackground: (UIApplication*)application {
    [ISReactionApp applicationDidEnterBackground:application];
  }
 
  -(void)application: (UIApplication*)application didReceiveRemoteNotification:
  (NSDictionary*)userInfo {
    [ISReactionApp receiveRemoteNotificationWithApplication:application
                                                   userInfo:userInfo];
  }
 
  -(void)application: (UIApplication*)application
  didReceiveRemoteNotification: (NSDictionary*)userInfo
  fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    [ISReactionApp receiveRemoteNotificationWithApplication:application
                                                   userInfo:userInfo
                                                   fetchCompletionHandler:completionHandler];
  }
 
  - (void)application: (UIApplication *)application
  didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    [ISReactionApp receiveLocalNotificationWithApplication:application
                                              notification:notification];
  }
@end
```


Example of using SDK in Swift:
```swift
import ReactionSDK

class ViewController: UIViewController {
    var reactionSDK_: ISReaction?

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize reaction-sdk api object
        self.reactionSDK_ = ISReaction(senderID: "<YOUR_SENDER_ID>",
                                 applicationKey: "<YOUR_APP_KEY>",
                                        isDebug: true)
    }
}
```

Example of using SDK in Objective-C:
```objc
@import ReActionSDK;

ISReaction* reaction_;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    reaction_ = [[ISReaction alloc] initWithSenderID:@"<YOUR_SENDER_ID>"
                                      applicationKey:@"<YOUR_APP_KEY>"
                                             isDebug:true];
    
}
@end
```

## Example 
You can use our [example][example-url]

## License
[MIT](LICENSE)

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[license-url]: LICENSE
[pod-image]: https://img.shields.io/cocoapods/v/ReActionSDK.svg
[pod-url]: https://cocoapods.org/?q=ReActionSDK

[example-url]: reaction_sdk/ReactionSDKExample