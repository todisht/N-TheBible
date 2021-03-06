//
//  ViewController.m
//  N-TheBible
//
//  Created by Tim Todish on 3/13/14.
//  Copyright (c) 2014 Tim Todish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    red = 177/255.0;
    green = 71/255.0;
    blue = 71/255.0;
    brush = 10.0;
    opacity = 1.0;
    currentStep = 0;
    
    // 2 - Load movie quotes from plist
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"verses" ofType:@"plist"];
    self.verses = [NSMutableArray arrayWithContentsOfFile:plistCatPath];
    
    
    NSString *htmlString = @"<html><body style='color:#fff'>";
    htmlString = [htmlString stringByAppendingString:@"What does it say 'N' the Bible about how to get to Heaven?"];
    htmlString = [htmlString stringByAppendingString:@"</body></html>"];
    // UIWebView uses baseURL to find style sheets, images, etc that you include in your HTML.
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.verseLabel2 loadHTMLString:htmlString baseURL:bundleUrl];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.overlayImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.overlayImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.overlayImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!mouseSwiped) {
        BOOL updateText = NO;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        UIImageView *imgView;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(currentPoint.x-15, currentPoint.y-15, 30, 30)];
            imgView.image = [UIImage imageNamed:@"images/redCircle.png"];
            NSLog(@"iphone");
        } else {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(currentPoint.x-15, currentPoint.y-15, 80, 80)];
            imgView.image = [UIImage imageNamed:@"redCircle-iPad.png"];
            NSLog(@"ipad");
        }
        
        
        [self.view addSubview:imgView];
        
                                                        
        if((currentPoint.x > 59 && currentPoint.x < 80) && (currentPoint.y > 444 && currentPoint.y < 484)){
            currentStep = 0;
            updateText = YES;
        } else if ((currentPoint.x > 43 && currentPoint.x < 87) && (currentPoint.y > 194 && currentPoint.y < 230)) {
            currentStep = 1;
            updateText = YES;
        } else if ((currentPoint.x > 213 && currentPoint.x < 254) && (currentPoint.y > 444 && currentPoint.y < 484)) {
            currentStep = 2;
            updateText = YES;
        } else if ((currentPoint.x > 213 && currentPoint.x < 254) && (currentPoint.y > 194 && currentPoint.y < 230)) {
            currentStep = 3;
            updateText = YES;
        } else {
            updateText = NO;
        }

        if(updateText) {
            NSString *formattedVerse = self.verses[currentStep][@"formattedVerse"];
            NSString *htmlString = @"<html><body style='color:#fff'>";
            htmlString = [htmlString stringByAppendingString:formattedVerse];
            htmlString = [htmlString stringByAppendingString:@"</body></html>"];
            // UIWebView uses baseURL to find style sheets, images, etc that you include in your HTML.
            NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
            [self.verseLabel2 loadHTMLString:htmlString baseURL:bundleUrl];
        }
        
    }
}

//shake to clear screen
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        self.overlayImage.image = nil;
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

@end
