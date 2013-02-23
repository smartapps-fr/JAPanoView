//
//  JAPanoView.h
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JAPanoView : UIView

@property (nonatomic) CGFloat zoomFactor;
@property (nonatomic) CGFloat hAngle, vAngle;
@property (nonatomic) CGFloat leftLimit, rightLimit, upLimit, downLimit; // angle limits
@property (nonatomic) CGFloat minZoom, maxZoom; // zoom limits

-(void)setFrontImage:(UIImage *)i1 rightImage:(UIImage *)i2 backImage:(UIImage *)i3 leftImage:(UIImage *)i4 topImage:(UIImage *)i5 bottomImage:(UIImage *)i6;

-(void)addHotspot:(UIView*)hotspotView atHAngle:(CGFloat)hAngle vAngle:(CGFloat)vAngle;

@end


@interface UIView (JAPanoViewHotspot)

@property (nonatomic, readonly) JAPanoView *panoView;
@property (nonatomic) BOOL shouldApplyPerspective;

-(void)removeFromPanoView;

@end
