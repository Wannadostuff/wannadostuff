//
//  GroupedTableHeader.m
//  InstagramFollowers

#import "GroupedTableHeader.h"

@implementation GroupedTableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.textLabel           = [[UILabel alloc] init];
        self.textLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        
        UIFont *font = [UIFont fontWithName:@"Avenir-Heavy" size:15.0];
        self.textLabel.font      = font;
        
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGRect textLabelFrame;
    textLabelFrame.size.height = [self.textLabel.text sizeWithAttributes:@{ NSFontAttributeName : self.textLabel.font }].height;
    textLabelFrame.origin.x    = 10;
    textLabelFrame.origin.y    = (bounds.size.height - textLabelFrame.size.height - 5.0);
    textLabelFrame.size.width  = (bounds.size.width - 10);
    
    self.textLabel.frame = textLabelFrame;
}

@end
