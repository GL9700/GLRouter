//
//  GLRouter.h
//  GLRouter
//
//  Created by liguoliang on 2020/7/9.
//

#import "RouterCore.h"
#import "RouterProtocol.h"
/**
 # Set:
 ===========================================
 <Info.plist>
 -----------------
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 ...
     <key>CFBundleTypeRole</key>
     <string>Editor</string>
     <key>CFBundleURLName</key>
     <string>router</string>
     <key>CFBundleURLSchemes</key>
     <array>
        <string>SCHEME</string>
     </array>
 ...
 </dict>
 </plist>

 # Use:
 ===========================================
 [RouterCore sharedRouter];
 ...
 [RouterCore openURL:@"SCHEME://push/CLASSNAME" form:<#CONTAINER#> before:<#BEFORE OF DISPLAY VC#> after:<#AFTER OF INVOKE METHOD#>];
 */
