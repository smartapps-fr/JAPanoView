//
//  JAPanoView.h
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JAPanoViewDelegate;

@interface JAPanoView : UIView

@property (nonatomic) CGFloat zoomFactor; // from 0 to 100; default value: 1
@property (nonatomic) CGFloat hAngle; // azimuth angle in radians; from 0 to 2*PI; default value: 0 
@property (nonatomic) CGFloat vAngle; // elavation angle in radians; from -(PI/2) to (PI/2); default value: 0
@property (nonatomic) CGFloat leftLimit, rightLimit, upLimit, downLimit; // angle limits
@property (nonatomic) CGFloat minZoom, maxZoom; // zoom limits; default values: min 0, max 100
@property (nonatomic, getter = isPanEnabled) BOOL panEnabled;
@property (nonatomic, getter = isZoomEnabled) BOOL zoomEnabled;
@property (nonatomic, weak) id<JAPanoViewDelegate> delegate;
    
-(void)setFrontImage:(UIImage *)i1 rightImage:(UIImage *)i2 backImage:(UIImage *)i3 leftImage:(UIImage *)i4 topImage:(UIImage *)i5 bottomImage:(UIImage *)i6;
-(void)setFrontImageOver:(UIImage *)i1 rightImageOver:(UIImage *)i2 backImageOver:(UIImage *)i3 leftImageOver:(UIImage *)i4 topImageOver:(UIImage *)i5 bottomImageOver:(UIImage *)i6;

-(void)addHotspot:(UIView*)hotspotView atHAngle:(CGFloat)hAngle vAngle:(CGFloat)vAngle;

-(void)setImageOverTransparancy:(CGFloat)transparancyValue;

-(id)initWithFrame:(CGRect)frame enableImageOver:(BOOL)enableImageOver;

@end

@protocol JAPanoViewDelegate <NSObject>

@optional
-(void)panoViewDidPan:(JAPanoView*)panoView;
-(void)panoViewDidZoom:(JAPanoView*)panoView;

-(void)panoViewWillBeginPanning:(JAPanoView*)panoView;
-(void)panoViewWillBeginZooming:(JAPanoView *)panoView;

-(void)panoViewDidEndPanning:(JAPanoView *)panoView;
-(void)panoViewDidEndZooming:(JAPanoView *)panoView;

@end


@interface UIView (JAPanoViewHotspot)

@property (nonatomic, readonly) JAPanoView *panoView;
@property (nonatomic) BOOL shouldApplyPerspective;

-(void)removeFromPanoView;

@end
