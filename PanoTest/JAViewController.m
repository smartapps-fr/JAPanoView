//
//  JAViewController.m
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import "JAViewController.h"
#import "JAPanoView.h"

@implementation JAViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadView{
    JAPanoView *panoView=[[JAPanoView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    self.view=panoView;
    [panoView setFrontImage:[UIImage imageNamed:@"TowerHousepano_f.jpg"] rightImage:[UIImage imageNamed:@"TowerHousepano_r.jpg"] backImage:[UIImage imageNamed:@"TowerHousepano_b.jpg"] leftImage:[UIImage imageNamed:@"TowerHousepano_l.jpg"] topImage:[UIImage imageNamed:@"TowerHousepano_u.jpg"] bottomImage:[UIImage imageNamed:@"Down_fixed.jpg"]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
