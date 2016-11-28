# ironSource.ReAction SDK for IOS

[![License][license-image]][license-url]
[![Pods][pod-image]][pod-url]

## Installation
### Installation from [CocoaPods](https://cocoapods.org/?q=reactionsdk).
Add dependency in your pod file
```ruby
pod 'ReActionSDK'
```

## Using the IronSource ReAction API
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

Also you nned to inherit your Appdelegate with our ISReactionApp in Swift:
```swift
import ReactionSDK

@UIApplicationMain
class AppDelegate: ISReactionApp {
}
```
and Objective-C:
```objc
#import "ISReactionApp.h"

@interface AppDelegate : ISReactionApp
@end
```

## Example 
You can use our [example][example-url]

## License
[MIT](LICENSE)

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[license-url]: LICENSE
[pod-image]: https://img.shields.io/cocoapods/v/AtomSDK.svg
[pod-url]: https://cocoapods.org/?q=AtomSDK

[example-url]: reaction_sdk/ReactionSDKExample