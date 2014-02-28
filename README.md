PixelHunter
===========
This library presents a User Interface verifying tool for iOS applications which appears by a specific gesture. It helps to detect differences between designers mock-ups and the real application appearance. The library could be embedded to an application during the development stage and might be useful for project managers, QA engineers and software development engineers.


## Features
-  Upload mockup from gallery to compare
-  Interactive rulers
-  Different marking notes
-  Mail sharing
-  Standard 50-pixel grid
-  1-pixel grid while zoom to max


## How To Get Started
-  Add PixelHunter folder to a project
-  Go to AppDelegate.m 
-  Make an import:

```objective-c
#import “SUPixelHunter.h”
```

-  In the method 

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```

write this line: 

```objective-c
[SUPixelHunter setup];
```

-  Go to Project > Choose target > Build Phases > Link Binary With Libraries.
-  Add “AVFoundation.framework”, “MessageUI.framework”, “CoreGraphics.framework” and “CoreMotion.framework”
-  Run the application on a device
-  Shake the device
-  Draw Z on screen
-  Enjoy!

## License
Copyright (c) 2013 GitHub, Inc. See the LICENSE file for license rights and limitations (MIT).
