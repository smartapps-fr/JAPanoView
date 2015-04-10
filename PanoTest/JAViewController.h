//
//  JAViewController.h
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAPanoView.h"

@interface JAViewController : UIViewController <JAPanoViewDelegate>

@property (nonatomic, copy) NSString *panoFileName;

@end
