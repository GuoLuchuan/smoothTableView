//
//  MyCustomCell.m
//  SmoothTableView
//
//  Created by guoluchuan on 13-3-13.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "MyCustomCell.h"

@implementation MyCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        for ( UIView *subView in [self subviews] ) {

                [subView removeFromSuperview];
            
        }

        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 80 - 10 - 10)];
        [self addSubview:_customImageView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleString:(NSString *)titleString
{
    if ([_titleString isEqualToString:titleString]) {
        return;
    }
    
    _titleString = titleString;
    [self setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect
{
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 2.5,[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor);
    
//    [[UIColor redColor] set];
//    
//    [_titleString drawAtPoint:CGPointMake((10 + 50 + 10), 10)  forWidth:(320 - 10 - (10 + 50 + 10)) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByWordWrapping];

}


@end
