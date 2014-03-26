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
	// Do any additional setup after loading the view, typically from a nib.
    red = 177/255.0;
    green = 71/255.0;
    blue = 71/255.0;
    brush = 10.0;
    opacity = 1.0;
    currentStep = 0;
    
    // 2 - Load movie quotes from plist
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"verses" ofType:@"plist"];
    self.verses = [NSMutableArray arrayWithContentsOfFile:plistCatPath];
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
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(currentPoint.x, currentPoint.y, 19, 19)];
        imgView.image = [UIImage imageNamed:@"images/redCircle.png"];
        
        [self.view addSubview:imgView];
        
        NSString *book = self.verses[3][@"book"];
        NSString *chapterVerse = self.verses[3][@"chapterVerse"];
        NSString *verseText = self.verses[3][@"verseText"];
        NSString *formattedVerse = self.verses[3][@"formattedVerse"];
        
        NSString *fullVerse = [NSString stringWithFormat:@"%@\n%@ %@", verseText,book,chapterVerse];
        self.verseLabel.text = fullVerse;
        
        NSString *htmlString = @"<html><body>";
        htmlString = [htmlString stringByAppendingString:formattedVerse];
        htmlString = [htmlString stringByAppendingString:@"</body></html>"];
        // UIWebView uses baseURL to find style sheets, images, etc that you include in your HTML.
        NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [self.verseLabel2 loadHTMLString:htmlString baseURL:bundleUrl];
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
