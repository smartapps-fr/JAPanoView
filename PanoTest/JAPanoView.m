//
//  JAPanoView.m
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import "JAPanoView.h"
#import <QuartzCore/QuartzCore.h>

@interface JAPanoView(){
    UIImageView *_image1,*_image2,*_image3,*_image4,*_image5,*_image6;
	CGFloat _referenceSide;
	CGFloat _previousZoomFactor;
}

-(void)defaultValues;
-(void)render;

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

-(void)setZoomFactor:(float)zoomFactor{
	//a limit of 0 gets a factor of 0,5
	//a limit of 100 gets a factor of 4
	float minFactor=(_minZoom*3.5/100.0)+0.5;
	float maxFactor=(_maxZoom*3.5/100.0)+0.5;
	if (zoomFactor>maxFactor) {
		zoomFactor=maxFactor;
	}else if (zoomFactor<minFactor) {
		zoomFactor=minFactor;
	}
	_zoomFactor=(zoomFactor)*_referenceSide;
}

-(float)zoomFactor{
	return (_zoomFactor/_referenceSide);
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self defaultValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
	if (self) {
		[self defaultValues];
	}
	return self;
}

-(void)defaultValues{
	if (self.bounds.size.width>self.bounds.size.height) {
		_referenceSide=self.bounds.size.width/2;
	}else {
		_referenceSide=self.bounds.size.height/2;
	}
	CGRect rect = CGRectMake(0, 0, _referenceSide*2, _referenceSide*2);
	
	// Initialization code.
	_image1=[[UIImageView alloc] initWithFrame:rect];
	_image2=[[UIImageView alloc] initWithFrame:rect];
	_image3=[[UIImageView alloc] initWithFrame:rect];
	_image4=[[UIImageView alloc] initWithFrame:rect];
	_image5=[[UIImageView alloc] initWithFrame:rect];
	_image6=[[UIImageView alloc] initWithFrame:rect];
	CGPoint centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	_image1.center=centerPoint;
	_image2.center=centerPoint;
	_image3.center=centerPoint;
	_image4.center=centerPoint;
	_image5.center=centerPoint;
	_image6.center=centerPoint;
	_image1.contentMode=UIViewContentModeScaleToFill;
	_image2.contentMode=UIViewContentModeScaleToFill;
	_image3.contentMode=UIViewContentModeScaleToFill;
	_image4.contentMode=UIViewContentModeScaleToFill;
	_image5.contentMode=UIViewContentModeScaleToFill;
	_image6.contentMode=UIViewContentModeScaleToFill;
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
	_minZoom=5;
	_maxZoom=100;
	self.userInteractionEnabled=YES;
	UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[self addGestureRecognizer:panGR];
	UIPinchGestureRecognizer *pinchGR=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
	[self addGestureRecognizer:pinchGR];
}

-(void)setFrontImage:(UIImage *)i1 rightImage:(UIImage *)i2 backImage:(UIImage *)i3 leftImage:(UIImage *)i4 topImage:(UIImage *)i5 bottomImage:(UIImage *)i6{
	_image1.image=i1;
	_image2.image=i2;
	_image3.image=i3;
	_image4.image=i4;
	_image5.image=i5;
	_image6.image=i6;
}

-(void)render{
	
	CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D, -_referenceSide*cosf(_hAngle), 0, _referenceSide*sinf(_hAngle));
	transform3D=CATransform3DRotate(transform3D, (M_PI/2)+_hAngle, 0, 1, 0);
	_image1.layer.transform=CATransform3DRotate(transform3D, _vAngle, cosf((M_PI/2)+_hAngle), 0, sinf((M_PI/2)+_hAngle));
	
	float tempHAngle=_hAngle;
	float tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image1.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
    
	tempHAngle=_hAngle-(M_PI/2);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image2.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
	
	tempHAngle=_hAngle-(M_PI);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image3.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
	
	tempHAngle=_hAngle-(3*M_PI/2);
	tempVAngle=_vAngle;
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   _referenceSide*sinf(-tempHAngle),
									   -_referenceSide*cosf(-tempHAngle)*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempHAngle)*cosf(-tempVAngle)-_zoomFactor)
									   );
	transform3D=CATransform3DRotate(transform3D, tempHAngle, 0, 1, 0);
	_image4.layer.transform=CATransform3DRotate(transform3D, tempVAngle, cosf(tempHAngle), 0, sinf(tempHAngle));
	
	tempHAngle=_hAngle;
	tempVAngle=_vAngle-(M_PI/2);
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   0,
									   -_referenceSide*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempVAngle)-_zoomFactor)
									   );
	
	transform3D=CATransform3DRotate(transform3D, tempVAngle, 1,0,0);
	_image5.layer.transform=CATransform3DRotate(transform3D, tempHAngle, 0, 0, 1);
	
	tempHAngle=_hAngle;
	tempVAngle=_vAngle+(M_PI/2);
	transform3D = CATransform3DIdentity;
    transform3D.m34 = 1 / -_zoomFactor;
	transform3D=CATransform3DTranslate(transform3D,
									   0,
									   -_referenceSide*sinf(-tempVAngle),
									   -(_referenceSide*cosf(-tempVAngle)-_zoomFactor)
									   );
	
	transform3D=CATransform3DRotate(transform3D, tempVAngle, 1,0,0);
	_image6.layer.transform=CATransform3DRotate(transform3D, -tempHAngle, 0, 0, 1);
}

-(void)layoutSubviews{
	float tempZoomFactor=self.zoomFactor;
	if (self.bounds.size.width>self.bounds.size.height) {
		_referenceSide=self.bounds.size.width/2;
	}else {
		_referenceSide=self.bounds.size.height/2;
	}
	//recalculate zoomFactor as a function of dim
	self.zoomFactor=tempZoomFactor;
	CGRect rect = CGRectMake(0, 0, _referenceSide*2, _referenceSide*2);
	
	// Initialization code.
	_image1.frame=rect;
	_image2.frame=rect;
	_image3.frame=rect;
	_image4.frame=rect;
	_image5.frame=rect;
	_image6.frame=rect;
	CGPoint centerPoint=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	_image1.center=centerPoint;
	_image2.center=centerPoint;
	_image3.center=centerPoint;
	_image4.center=centerPoint;
	_image5.center=centerPoint;
	_image6.center=centerPoint;
	[self render];
}

#pragma mark GestureRecognizers

-(void)didPan:(UIPanGestureRecognizer *)gestureRecognizer{
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan ||
		gestureRecognizer.state==UIGestureRecognizerStateChanged) {
		CGPoint translation=[gestureRecognizer translationInView:self];
		float newHAngle = self.hAngle-(translation.x/(_zoomFactor/1.5));
		float newVAngle = self.vAngle+(translation.y/(_zoomFactor/1.5));
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
		self.hAngle=newHAngle;
		self.vAngle=newVAngle;
		[self render];
		[gestureRecognizer setTranslation:CGPointZero inView:self];
	}
}

-(void)didPinch:(UIPinchGestureRecognizer *)gestureRecognizer{
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
		_previousZoomFactor=self.zoomFactor;
	}
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan ||
		gestureRecognizer.state==UIGestureRecognizerStateChanged) {
		float newFactor=_previousZoomFactor*gestureRecognizer.scale;
        self.zoomFactor=newFactor;
        [self render];
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
