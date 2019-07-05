//
//  JAViewController.m
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import "JAViewController.h"
#import "JAPanoView.h"
#import <QuartzCore/QuartzCore.h>

@interface JAViewController () <JAPanoViewDelegate> {
    UIPopoverController *_testPopover;
}

@end

@implementation JAViewController

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    JAPanoView *panoView = [[JAPanoView alloc] initWithFrame:frame enableImage:YES enableImageOver:NO];
    panoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = panoView;
    panoView.delegate = self;
    panoView.zoomFactor = 1.25;
    panoView.autoPlayVideo = YES;
    [panoView setFrontImage:nil rightImage:[UIImage imageNamed:@"TowerHousepano_r.jpg"] backImage:[UIImage imageNamed:@"TowerHousepano_b.jpg"] leftImage:[UIImage imageNamed:@"TowerHousepano_l.jpg"] topImage:[UIImage imageNamed:@"TowerHousepano_u.jpg"] bottomImage:[UIImage imageNamed:@"Down_fixed.jpg"]];
    [panoView setFrontVideo:[[NSBundle mainBundle] URLForResource:@"output_5" withExtension:@"mp4"]
                 rightVideo:nil
                  backVideo:nil
                  leftVideo:nil
                   topVideo:nil
                bottomVideo:nil];
    /*[panoView setFrontVideo:[[NSBundle mainBundle] URLForResource:@"output_5" withExtension:@"mp4"]
                 rightVideo:[[NSBundle mainBundle] URLForResource:@"output_right" withExtension:@"mp4"]
                  backVideo:[[NSBundle mainBundle] URLForResource:@"output_back" withExtension:@"mp4"]
                  leftVideo:[[NSBundle mainBundle] URLForResource:@"output_left" withExtension:@"mp4"]
                   topVideo:[[NSBundle mainBundle] URLForResource:@"output_top" withExtension:@"mp4"]
                bottomVideo:[[NSBundle mainBundle] URLForResource:@"output_bottom" withExtension:@"mp4"]];*/
    
    /*UILabel *hotspot1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    hotspot1.backgroundColor=[UIColor clearColor];
    hotspot1.textColor=[UIColor redColor];
    hotspot1.text=@"DOOR";
    hotspot1.textAlignment=NSTextAlignmentCenter;
    [panoView addHotspot:hotspot1 atHAngle:0 vAngle:0];
    UIView *hotspot2=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    hotspot2.backgroundColor=[UIColor yellowColor];
    hotspot2.alpha=0.5;
    hotspot2.layer.cornerRadius=25;
    [panoView addHotspot:hotspot2 atHAngle:M_PI_4 vAngle:M_PI_4];
    
    UIButton *hotspot3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hotspot3 setTitle:@"clouds" forState:UIControlStateNormal];
    [hotspot3 setFrame:CGRectMake(0, 0, 100, 30)];
    hotspot3.shouldApplyPerspective=NO;
    [hotspot3 addTarget:self action:@selector(centerClouds:) forControlEvents:UIControlEventTouchUpInside];
    [panoView addHotspot:hotspot3 atHAngle:-M_PI_2 vAngle:M_PI_4];
    
    
    UITapGestureRecognizer *tapgr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [hotspot2 addGestureRecognizer:tapgr];*/
}

- (void)tapped:(UITapGestureRecognizer *)tapGR {
    _testPopover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
    [_testPopover presentPopoverFromRect:tapGR.view.frame inView:tapGR.view.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)centerClouds:(id)sender {
    [(JAPanoView*)self.view setHAngle:-M_PI_2];
    [(JAPanoView*)self.view setVAngle:M_PI_4];
}

#pragma mark JAPanoViewDelegate

- (void)panoViewDidPan:(JAPanoView *)panoView {
    NSLog(@"didPan");
}

- (void)panoViewDidEndPanning:(JAPanoView *)panoView {
    NSLog(@"didEndPanning");
}

@end
