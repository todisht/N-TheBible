//
//  ViewController.h
//  N-TheBible
//
//  Created by Tim Todish on 3/13/14.
//  Copyright (c) 2014 Tim Todish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

@property (weak, nonatomic) IBOutlet UIImageView *overlayImage;

@end
