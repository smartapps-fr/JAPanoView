//
//  JAPanoView.m
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import "JAPanoView.h"
#import <tgmath.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface UIView (JAPanoViewHotspotPrivate)

@property (nonatomic, assign) JAPanoView *panoView;
@property (nonatomic) CGFloat hAngle;
@property (nonatomic) CGFloat vAngle;

@end

@interface JAPanoView() {
	UIImageView *_image1,*_image2,*_image3,*_image4,*_image5,*_image6;
	UIImageView *_imageOver1,*_imageOver2,*_imageOver3,*_imageOver4,*_imageOver5,*_imageOver6;
	CGFloat _referenceSide;
	CGFloat _previousZoomFactor;
	NSMutableArray *_hotspots;
	UIPanGestureRecognizer *_panGestureRecognizer;
	UIPinchGestureRecognizer *_pinchGestureRecognizer;
	//delegate
	BOOL _delegateDidPan;
	BOOL _delegateDidZoom;
	BOOL _delegateBeginPan;
	BOOL _delegateBeginZoom;
	BOOL _delegateEndPan;
	BOOL _delegateEndZoom;
}

- (void)defaultValues;
- (void)render;
- (void)removeHotspot:(UIView*)hotspot;

@end

@implementation JAPanoView

@synthesize zoomFactor=_zoomFactor;
@synthesize hAngle=_hAngle;
@synthesize vAngle=_vAngle;
@synthesize leftLimit=_leftLimit;
@synthesize rightLimit=_rightLimit;
@synthesize upLimit=_upLimit;
@synthesize downLimit=_downLimit;
@synthesize minZoom=_minZoom;
@synthesize maxZoom=_maxZoom;

- (void)setZoomFactor:(CGFloat)zoomFactor {
	//a limit of 0 gets a factor of 0,5
	//a limit of 100 gets a factor of 4
	CGFloat minFactor=(_minZoom*3.5/100.0)+0.5;
	CGFloat maxFactor=(_maxZoom*3.5/100.0)+0.5;
	if (zoomFactor>maxFactor) {
		zoomFactor=maxFactor;
	} else if (zoomFactor<minFactor) {
		zoomFactor=minFactor;
	}
	_zoomFactor=(zoomFactor)*_referenceSide;
    [self render];
}

- (CGFloat)zoomFactor {
	return (_zoomFactor/_referenceSide);
}

- (void)setHAngle:(CGFloat)hAngle {
    _hAngle=hAngle;
    [self render];
}

- (void)setVAngle:(CGFloat)vAngle {
    _vAngle=vAngle;
    [self render];
}

- (void)setPanEnabled:(BOOL)panEnabled {
    _panGestureRecognizer.enabled=panEnabled;
}

- (BOOL)isPanEnabled {
    return _panGestureRecognizer.enabled;
}

-(void)setZoomEnabled:(BOOL)zoomEnabled{
    _pinchGestureRecognizer.enabled=zoomEnabled;
}

- (BOOL)isZoomEnabled {
    return _pinchGestureRecognizer.enabled;
}

- (void)setDelegate:(id<JAPanoViewDelegate>)delegate {
    _delegate=delegate;
    _delegateDidPan=[_delegate respondsToSelector:@selector(panoViewDidPan:)];
    _delegateDidZoom=[_delegate respondsToSelector:@selector(panoViewDidZoom:)];
    _delegateBeginPan=[_delegate respondsToSelector:@selector(panoViewWillBeginPanning:)];
    _delegateBeginZoom=[_delegate respondsToSelector:@selector(panoViewWillBeginZooming:)];
    _delegateEndPan=[_delegate respondsToSelector:@selector(panoViewDidEndPanning:)];
    _delegateEndZoom=[_delegate respondsToSelector:@selector(panoViewDidEndZooming:)];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame enableImageOver:NO];
}

- (id)initWithFrame:(CGRect)frame enableImageOver:(BOOL)enableImageOver {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultValues];
        if (enableImageOver) [self defaultValuesForImageOver];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithCoder:aDecoder enableImageOver:NO];
}

- (id)initWithCoder:(NSCoder *)aDecoder enableImageOver:(BOOL)enableImageOver {
    self=[super initWithCoder:aDecoder];
	if (self) {
		[self defaultValues];
        if (enableImageOver) [self defaultValuesForImageOver];
	}
	return self;
}

- (void)defaultValues {
    _hotspots=[NSMutableArray array];
	if (self.bounds.size.width>self.bounds.size.height) {
		_referenceSide=self.bounds.size.width/2;
	} else {
		_referenceSide=self.bounds.size.height/2;
	}
	CGRect rect = CGRectMake(0, 0, _referenceSide*2, _referenceSide*2);
    CGPoint centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
	// Initialization code.
	_image1 = [[UIImageView alloc] initWithFrame:rect];
	_image2 = [[UIImageView alloc] initWithFrame:rect];
	_image3 = [[UIImageView alloc] initWithFrame:rect];
	_image4 = [[UIImageView alloc] initWithFrame:rect];
	_image5 = [[UIImageView alloc] initWithFrame:rect];
	_image6 = [[UIImageView alloc] initWithFrame:rect];
    
	_image1.center = centerPoint;
	_image2.center = centerPoint;
	_image3.center = centerPoint;
	_image4.center = centerPoint;
	_image5.center = centerPoint;
	_image6.center = centerPoint;
    
	_image1.contentMode = UIViewContentModeScaleToFill;
	_image2.contentMode = UIViewContentModeScaleToFill;
	_image3.contentMode = UIViewContentModeScaleToFill;
	_image4.contentMode = UIViewContentModeScaleToFill;
	_image5.contentMode = UIViewContentModeScaleToFill;
	_image6.contentMode = UIViewContentModeScaleToFill;
    
	[self addSubview:_image1];
	[self addSubview:_image2];
	[self addSubview:_image3];
	[self addSubview:_image4];
	[self addSubview:_image5];
	[self addSubview:_image6];
    
	_zoomFactor=_referenceSide;
	_hAngle=0;
	_vAngle=0;
	_leftLimit=0;
	_rightLimit=0;
	_upLimit=M_PI_2;
	_downLimit=M_PI_2;
	_minZoom=0;
	_maxZoom=100;
	self.userInteractionEnabled=YES;
	UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[self addGestureRecognizer:panGR];
    _panGestureRecognizer=panGR;
	UIPinchGestureRecognizer *pinchGR=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
	[self addGestureRecognizer:pinchGR];
    _pinchGestureRecognizer=pinchGR;    
}

- (void)defaultValuesForImageOver {
    CGRect rect = _image1.frame;
    CGPoint centerPoint = _image1.center;
    
    _imageOver1 = [[UIImageView alloc] initWithFrame:rect];
    _imageOver2 = [[UIImageView alloc] initWithFrame:rect];
    _imageOver3 = [[UIImageView alloc] initWithFrame:rect];
    _imageOver4 = [[UIImageView alloc] initWithFrame:rect];
    _imageOver5 = [[UIImageView alloc] initWithFrame:rect];
    _imageOver6 = [[UIImageView alloc] initWithFrame:rect];
    
    _imageOver1.center = centerPoint;
    _imageOver2.center = centerPoint;
    _imageOver3.center = centerPoint;
    _imageOver4.center = centerPoint;
    _imageOver5.center = centerPoint;
    _imageOver6.center = centerPoint;
    
    _imageOver1.contentMode = UIViewContentModeScaleToFill;
    _imageOver2.contentMode = UIViewContentModeScaleToFill;
    _imageOver3.contentMode = UIViewContentModeScaleToFill;
    _imageOver4.contentMode = UIViewContentModeScaleToFill;
    _imageOver5.contentMode = UIViewContentModeScaleToFill;
    _imageOver6.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:_imageOver1];
    [self addSubview:_imageOver2];
    [self addSubview:_imageOver3];
    [self addSubview:_imageOver4];
    [self addSubview:_imageOver5];
    [self addSubview:_imageOver6];
    
    [self setImageOverTransparancy:0];
}

- (void)setFrontImage:(UIImage *)i1 rightImage:(UIImage *)i2 backImage:(UIImage *)i3 leftImage:(UIImage *)i4 topImage:(UIImage *)i5 bottomImage:(UIImage *)i6
{
	_image1.image = i1;
	_image2.image = i2;
	_image3.image = i3;
	_image4.image = i4;
	_image5.image = i5;
	_image6.image = i6;
}

-(void)setFrontImageOver:(UIImage *)i1 rightImageOver:(UIImage *)i2 backImageOver:(UIImage *)i3 leftImageOver:(UIImage *)i4 topImageOver:(UIImage *)i5 bottomImageOver:(UIImage *)i6
{
    _imageOver1.image = i1;
    _imageOver2.image = i2;
    _imageOver3.image = i3;
    _imageOver4.image = i4;
    _imageOver5.image = i5;
    _imageOver6.image = i6;
}

- (void)render {
	
	CATransform3D transform3D = CATransform3DIdentity;
	
	CGFloat tempHAngle=_hAngle;
	CGFloat tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sin(-tempHAngle),
									   -_referenceSide*cos(-tempHAngle)*sin(-tempVAngle),
									   -(_referenceSide*cos(-tempHAngle)*cos(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
    if (_imageOver1.image != nil) _imageOver1.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
	_image1.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
    
	tempHAngle=_hAngle-(M_PI/2);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sin(-tempHAngle),
									   -_referenceSide*cos(-tempHAngle)*sin(-tempVAngle),
									   -(_referenceSide*cos(-tempHAngle)*cos(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
    if (_imageOver2.image != nil) _imageOver2.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
	_image2.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
	
	tempHAngle=_hAngle-(M_PI);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sin(-tempHAngle),
									   -_referenceSide*cos(-tempHAngle)*sin(-tempVAngle),
									   -(_referenceSide*cos(-tempHAngle)*cos(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
    if (_imageOver3.image != nil) _imageOver3.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
	_image3.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));

    tempHAngle=_hAngle-(3*M_PI/2);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sin(-tempHAngle),
									   -_referenceSide*cos(-tempHAngle)*sin(-tempVAngle),
									   -(_referenceSide*cos(-tempHAngle)*cos(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
    if (_imageOver4.image != nil) _imageOver4.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
	_image4.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cos(tempHAngle), 0, sin(tempHAngle));
	
	tempHAngle=_hAngle;
	tempVAngle=_vAngle-(M_PI/2);
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   0,
									   -_referenceSide*sin(-tempVAngle),
									   -(_referenceSide*cos(-tempVAngle)-_zoomFactor)
									   );
	
	transform3D=CATransform3DRotate(transform3D, tempVAngle, 1,0,0);
    if (_imageOver5.image != nil) _imageOver5.layer.transform=CATransform3DRotate(transform3D, tempHAngle, 0, 0, 1);
	_image5.layer.transform=CATransform3DRotate(transform3D, tempHAngle, 0, 0, 1);
    
    tempHAngle=_hAngle;
	tempVAngle=_vAngle+(M_PI/2);
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   0,
									   -_referenceSide*sin(-tempVAngle),
									   -(_referenceSide*cos(-tempVAngle)-_zoomFactor)
									   );
	
	transform3D=CATransform3DRotate(transform3D, tempVAngle, 1,0,0);
    if (_imageOver6.image != nil) _imageOver6.layer.transform=CATransform3DRotate(transform3D, -tempHAngle, 0, 0, 1);
	_image6.layer.transform=CATransform3DRotate(transform3D, -tempHAngle, 0, 0, 1);

    CGFloat hotspotReference=_referenceSide;
    for (UIView *hotspot in _hotspots) {
        tempHAngle=hotspot.hAngle;
        tempVAngle=hotspot.vAngle;
        
        CGFloat x=sin(tempHAngle)*cos(tempVAngle);
        CGFloat y=sin(tempVAngle);
        CGFloat z=cos(tempVAngle)*cos(tempHAngle);
        
        CGPoint transformedPoint=CGPointApplyAffineTransform(CGPointMake(x, z), CGAffineTransformMakeRotation(_hAngle));
        x=transformedPoint.x;
        z=transformedPoint.y;
        transformedPoint=CGPointApplyAffineTransform(CGPointMake(z, y), CGAffineTransformMakeRotation(-_vAngle));
        y=transformedPoint.y;
        z=transformedPoint.x;
        
        transform3D = CATransform3DIdentity;
        transform3D.m34 = 1 / -_zoomFactor;
        transform3D=CATransform3DTranslate(transform3D,
                                           hotspotReference*x,
                                           -(hotspotReference*y),
                                           -((hotspotReference)*z-_zoomFactor)
                                           );
        if (hotspot.shouldApplyPerspective) {
            transform3D=CATransform3DRotate(transform3D, _hAngle, 0, 1, 0);
            transform3D=CATransform3DRotate(transform3D, _vAngle, cos(_hAngle), 0, sin(_hAngle));
            transform3D=CATransform3DRotate(transform3D, -hotspot.hAngle, 0, 1, 0);
            transform3D=CATransform3DRotate(transform3D, -hotspot.vAngle, 1, 0, 0);
        }
        
        
        hotspot.layer.transform=transform3D;
    }
}

- (void)layoutSubviews {
	CGFloat tempZoomFactor = self.zoomFactor;
	if (self.bounds.size.width > self.bounds.size.height) {
		_referenceSide = self.bounds.size.width/2;
	}else {
		_referenceSide = self.bounds.size.height/2;
	}
	//recalculate zoomFactor as a function of dim
	self.zoomFactor=tempZoomFactor;
	CGRect rect = CGRectMake(0, 0, _referenceSide*2, _referenceSide*2);
    CGPoint centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    _image1.frame = rect;
    _image2.frame = rect;
    _image3.frame = rect;
    _image4.frame = rect;
    _image5.frame = rect;
    _image6.frame = rect;
    
    _imageOver1.frame = rect;
    _imageOver2.frame = rect;
    _imageOver3.frame = rect;
    _imageOver4.frame = rect;
    _imageOver5.frame = rect;
    _imageOver6.frame = rect;
    
    _image1.center = centerPoint;
    _image2.center = centerPoint;
    _image3.center = centerPoint;
    _image4.center = centerPoint;
    _image5.center = centerPoint;
    _image6.center = centerPoint;
    
    _imageOver1.center = centerPoint;
    _imageOver2.center = centerPoint;
    _imageOver3.center = centerPoint;
    _imageOver4.center = centerPoint;
    _imageOver5.center = centerPoint;
    _imageOver6.center = centerPoint;
    
    for (UIView *hotspot in _hotspots) {
        hotspot.center = centerPoint;
    }
	[self render];
}

- (void)setImageOverTransparancy:(CGFloat)transparancyValue
{
    _imageOver1.alpha = transparancyValue;
    _imageOver2.alpha = transparancyValue;
    _imageOver3.alpha = transparancyValue;
    _imageOver4.alpha = transparancyValue;
    _imageOver5.alpha = transparancyValue;
    _imageOver6.alpha = transparancyValue;
}

#pragma mark GestureRecognizers

- (void)didPan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        if (_delegate && _delegateBeginPan) {
            [_delegate panoViewWillBeginPanning:self];
        }
	}
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan ||
		gestureRecognizer.state==UIGestureRecognizerStateChanged) {
		CGPoint translation=[gestureRecognizer translationInView:self];
		CGFloat newHAngle = self.hAngle-(translation.x/(_zoomFactor/1.5));
		CGFloat newVAngle = self.vAngle+(translation.y/(_zoomFactor/1.5));
		if (newHAngle>0 && _rightLimit!=0) {
			if (newHAngle>_rightLimit) {
				newHAngle=_rightLimit;
			}
		}else if (newHAngle<0 && _leftLimit!=0) {
			// negative angle to the left, but limit is always positive (absolute value)
			if (newHAngle<(-_leftLimit)) {
				newHAngle=-_leftLimit;
			}
		}
		if (newVAngle>0 && _upLimit!=0) {
			if (newVAngle>_upLimit) {
				newVAngle=_upLimit;
			}
		}else if (newVAngle<0 && _downLimit!=0) {
			// negative angle to the bottom, but limit is always positive (absolute value)
			if (newVAngle<(-_downLimit)) {
				newVAngle=-_downLimit;
			}
		}
		_hAngle=newHAngle;
		_vAngle=newVAngle;
		[self render];
		[gestureRecognizer setTranslation:CGPointZero inView:self];
        if (_delegate && _delegateDidPan) {
            [_delegate panoViewDidPan:self];
        }
	}
    if (gestureRecognizer.state==UIGestureRecognizerStateEnded) {
        if (_delegate && _delegateEndPan) {
            [_delegate panoViewDidEndPanning:self];
        }
	}
}

- (void)didPinch:(UIPinchGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
		_previousZoomFactor=self.zoomFactor;
        if (_delegate && _delegateBeginZoom) {
            [_delegate panoViewWillBeginZooming:self];
        }
	}
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan ||
		gestureRecognizer.state==UIGestureRecognizerStateChanged) {
		CGFloat newFactor=_previousZoomFactor*gestureRecognizer.scale;
        self.zoomFactor=newFactor;
        if (_delegate && _delegateDidZoom) {
            [_delegate panoViewDidZoom:self];
        }
	}
    if (gestureRecognizer.state==UIGestureRecognizerStateEnded) {
        if (_delegate && _delegateEndZoom) {
            [_delegate panoViewDidEndZooming:self];
        }
	}
}

#pragma mark hotspot management

- (void)addHotspot:(UIView*)hotspotView atHAngle:(CGFloat)hAngle vAngle:(CGFloat)vAngle {
    if (hotspotView.panoView!=nil) {
        [hotspotView removeFromPanoView];
    }
    hotspotView.panoView=self;
    hotspotView.hAngle=hAngle;
    hotspotView.vAngle=vAngle;
    [_hotspots addObject:hotspotView];
    [self addSubview:hotspotView];
}

- (void)removeHotspot:(UIView *)hotspot {
    if (hotspot.panoView==self) {
        [hotspot removeFromSuperview];
        [_hotspots removeObject:hotspot];
        hotspot.panoView=nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


static char kUIViewHotSpotPanoViewObjectKey;
static char kUIViewHotSpotShouldApplyPerspectiveObjectKey;

@implementation UIView (JAPanoViewHotspot)

@dynamic panoView;
@dynamic shouldApplyPerspective;

- (void)removeFromPanoView {
    if (self.panoView) {
        [self.panoView removeHotspot:self];
    }
}

- (JAPanoView*)panoView {
    return (JAPanoView *)objc_getAssociatedObject(self, &kUIViewHotSpotPanoViewObjectKey);
}

- (void)setShouldApplyPerspective:(BOOL)shouldApplyPerspective {
    objc_setAssociatedObject(self, &kUIViewHotSpotShouldApplyPerspectiveObjectKey, @(shouldApplyPerspective), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)shouldApplyPerspective {
    NSNumber *value=(NSNumber *)objc_getAssociatedObject(self, &kUIViewHotSpotShouldApplyPerspectiveObjectKey);
    return value?[value boolValue]:YES;
}

@end


static char kUIViewHotSpotHAngleObjectKey;
static char kUIViewHotSpotVAngleObjectKey;

@implementation UIView (JAPanoViewHotspotPrivate)

@dynamic panoView;
@dynamic hAngle;
@dynamic vAngle;

- (void)setPanoView:(JAPanoView *)panoView {
    objc_setAssociatedObject(self, &kUIViewHotSpotPanoViewObjectKey, panoView, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setHAngle:(CGFloat)hAngle {
    objc_setAssociatedObject(self, &kUIViewHotSpotHAngleObjectKey, @(hAngle), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setVAngle:(CGFloat)vAngle {
    objc_setAssociatedObject(self, &kUIViewHotSpotVAngleObjectKey, @(vAngle), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)hAngle {
    return [(NSNumber *)objc_getAssociatedObject(self, &kUIViewHotSpotHAngleObjectKey) floatValue];
}

- (CGFloat)vAngle {
    return [(NSNumber *)objc_getAssociatedObject(self, &kUIViewHotSpotVAngleObjectKey) floatValue];
}

@end
