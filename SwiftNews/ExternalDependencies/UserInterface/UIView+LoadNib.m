#import "UIView+LoadNib.h"

@implementation UIView (LoadNib)

+ (UIView *)loadViewFromNibName:(NSString *)nibName {
    __block UIView *view = nil;    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                             owner:self
                                                           options:nil];
    
    [topLevelObjects enumerateObjectsUsingBlock:^(id currentObject, NSUInteger index, BOOL *stop) {
        if ([currentObject isKindOfClass:[UIView class]]) {
            view = (UIView *)currentObject;
            *stop = YES;
        }
    }];
    
    return view;
}

@end
