This is a fork of [JAPanoView](https://bitbucket.org/javieralonso/japanoview)...
 - compatible with the latest iOS SDK (8.0).
 - adds Podspec

- - -


# JAPanoView: open source panorama viewer

JAPanoView is a UIView subclass that renders 360-180 degree panoramic views created from cubic panoramic images with interactive panning and zooming. You can add any UIView as a hotspot into JAPanoView.
Watch a video: http://www.youtube.com/watch?v=8g0LcuNzzNM

JAPanoView source code is distributed under Apache license. More info at http://www.apache.org/licenses/LICENSE-2.0.html
Sample images are from http://www.remedypanoramic.com/ and © Remedy Panoramic Design 2010. Included with the permission of the copyright holder.

JAPanoView has been created by Javier Alonso.
http://javieralog.blogspot.com
@javieralog

You can get the latest version from https://github.com/ddebin/JAPanoView


# How to use it

Copy JAPanoView.h and JAPanoView.m to your project.
Make sure your project includes the following frameworks:
 - QuartzCore.framework
 - UIKit.framework

JAPanoView code uses ARC and iOS deployment target version is iOS 5.0 or later
Latest version was tested using iOS SDK 8.0

Creating a panoramic view:

```objc
JAPanoView *panoView = [[JAPanoView alloc] initWithFrame:self.view.bounds];
[panoView setFrontImage:[UIImage imageNamed:@"TowerHousepano_f.jpg"]
             rightImage:[UIImage imageNamed:@"TowerHousepano_r.jpg"]
              backImage:[UIImage imageNamed:@"TowerHousepano_b.jpg"]
              leftImage:[UIImage imageNamed:@"TowerHousepano_l.jpg"]
               topImage:[UIImage imageNamed:@"TowerHousepano_u.jpg"]
            bottomImage:[UIImage imageNamed:@"Down_fixed.jpg"]];
[self.view addSubview:panoView];`
```

# Hotspots

Instantiate any UIView subclass and add it as a hotspot with the method `addHotspot:atHAngle:vAngle:` indicating the horizontal angle (azimuth) and vertical angle (elevation). To remove a hotspot form a JAPanoView just call `removeFromPanoView` on the hotspot instance (like `addSubview:` and `removeFromSuperview`).

Since any UIView can be a hotspot, you can add any UIControl or add any UIGestureRecognizer to your hotspot and make it fully user interactive. You can also take advantage of the convertPoint/Rect:from/toView: UIView methods and show popovers from a hotspot as seen in the demo project:

```objc
[popover presentPopoverFromRect:hotspot.frame
                         inView:hotspot.superview
       permittedArrowDirections:UIPopoverArrowDirectionAny
                       animated:YES];
```

There's also a property for UIView: shouldApplyPerspective. It indicates if the hotspot should be rendered always parallel to the screen (`shouldApplyPerspective==NO`) or perpendicular to the point-of-view/hotspot axis (`shouldApplyPerspective==YES`; default value).