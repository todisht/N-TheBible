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
    int currentStep;
}

@property (weak, nonatomic) IBOutlet UIImageView *overlayImage;

@property (weak, nonatomic) IBOutlet UIImageView *redCirc;

@property (nonatomic, strong) NSMutableArray *verses;

//@property (weak, nonatomic) IBOutlet UITextView *verseLabel;
@property (weak, nonatomic) IBOutlet UIWebView *verseLabel2;

@end
