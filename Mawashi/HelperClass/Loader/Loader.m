//
//  Loader.m
//  VideoTag
//
//  Created by Amit Saini on 16/04/14.
//
//

#import "Loader.h"

@implementation Loader

- (void)showLoader: (UIColor*) colorCode
{
    if(loaderView)
    {
        [loaderView setHidden:NO];
        return;
    }
    
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [delegate window];
    loaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [loaderView setBackgroundColor: [UIColor clearColor]];//colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8]];
    loaderView.layer.cornerRadius = 7.0;
    [loaderView setCenter:window.center];//.rootViewController.view.center
    
//    IndicatorView
    UIActivityIndicatorView *indicatorView = [self getActivityIndicator];
    [indicatorView setColor:colorCode];
    [loaderView addSubview:indicatorView];
    loaderView.tag = 10000;
   
    [self addBasicConstraintsOnSubView:indicatorView onSuperView:loaderView];
    [window addSubview:loaderView];
}

-(void)addBasicConstraintsOnSubView:(UIView *)subView onSuperView:(UIView *)superView
{
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[subView]-0-|",subView.frame.origin.y] options: NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(subView)]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-%f-[subView]-%f-|",subView.frame.origin.x,subView.frame.origin.x] options: NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(subView)]];
}

- (void)hideLoader
{
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [delegate window];
    
    NSArray *subViewArray = [window subviews];
    for (id obj in subViewArray)
    {
        if ([obj tag] == 10000)
        {
            [obj removeFromSuperview];
        }
    }
//    [loaderView setHidden:YES];
}

-(UIActivityIndicatorView *)getActivityIndicator
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView startAnimating];
    return indicatorView;
}

- (void)dealloc
{
    
}

@end
