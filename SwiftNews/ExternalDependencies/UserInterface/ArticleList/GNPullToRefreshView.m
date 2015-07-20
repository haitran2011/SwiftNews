#import "GNPullToRefreshView.h"

@interface GNPullToRefreshView ()

@property (nonatomic) CGFloat progress;
@property (nonatomic) UIColor *barColor;
@property (nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation GNPullToRefreshView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _barColor = [UIColor darkGrayColor];
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicator setHidesWhenStopped:YES];
        [self addSubview:_indicator];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.indicator.center = CGPointMake(floorf(self.bounds.size.width / 2.0f),
                                        floorf(self.bounds.size.height / 2.0f));
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] set];
    CGContextFillRect(context, self.bounds);
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat barHeight = 5;
    CGFloat barWidth = (width / 2.0) * self.progress;
    
    CGFloat barY = height - barHeight;
    
    CGRect leftRect = CGRectMake(0, barY, barWidth, barHeight);
    [self.barColor set];
    CGContextFillRect(context, leftRect);
    
    CGFloat rightX = width - barWidth;
    CGRect rightRect = CGRectMake(rightX, barY, barWidth, barHeight);
    CGContextFillRect(context, rightRect);
}

- (void)setState:(SSPullToRefreshViewState)state
    withPullToRefreshView:(SSPullToRefreshView *)view
{
    switch (state) {
        case SSPullToRefreshViewStateNormal:
            self.barColor = [UIColor darkGrayColor];
            break;
            
        case SSPullToRefreshViewStateLoading:
            [self.indicator startAnimating];
            self.barColor = [UIColor greenColor];
            break;
            
        case SSPullToRefreshViewStateReady:
            self.barColor = [UIColor redColor];
            break;
            
        case SSPullToRefreshViewStateClosing:
            [self.indicator stopAnimating];
            self.barColor = [UIColor greenColor];
            break;
            
        default:
            break;
    }
}

- (void)setPullProgress:(CGFloat)pullProgress {
    self.progress = pullProgress;
    [self setNeedsDisplay];
}

@end
