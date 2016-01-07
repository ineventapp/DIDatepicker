//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 46.;
const CGFloat kDIDatepickerSelectionLineWidth = 51.;
const CGFloat kDIDatepickerPaddingSize = 2.;

@interface DIDatepickerDateView ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (nonatomic, strong) UIView *selectionView;

@end


@implementation DIDatepickerDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupViews];

    return self;
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dateWasSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDate:(NSDate *)date
{
    _date = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];

    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", dayFormattedString, [dayInWeekFormattedString uppercaseString]]];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont systemFontOfSize:18],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(0, dayFormattedString.length)];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont systemFontOfSize:7],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];

    if ([self isWeekday:date]) {
        [dateString addAttribute:NSFontAttributeName
                           value:[UIFont boldSystemFontOfSize:7]
                           range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
    }

    self.dateLabel.attributedText = dateString;
}

- (void)setLabelState {
    
    // Background color
    _dateLabel.backgroundColor = (_isSelected) ? self.selectionView.backgroundColor : [UIColor clearColor];
    
    // String color
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:_dateLabel.attributedText];
    (_isSelected) ? [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _dateLabel.attributedText.length)] : [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, _dateLabel.attributedText.length)] ;
    _dateLabel.attributedText = attrStr;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    [self setLabelState];
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + kDIDatepickerPaddingSize, self.bounds.origin.y + kDIDatepickerPaddingSize, self.bounds.size.width - 2*kDIDatepickerPaddingSize, self.bounds.size.height - 2*kDIDatepickerPaddingSize)];
        _dateLabel.numberOfLines = 2;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = self.selectionView.backgroundColor;
        _dateLabel.layer.cornerRadius = _dateLabel.frame.size.width * 0.5f;
        _dateLabel.layer.masksToBounds = YES;
        [self addSubview:_dateLabel];
    }

    return _dateLabel;
}

- (UIView *)selectionView
{
    if (!_selectionView) {
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 51) / 2, self.frame.size.height - 3, 51, 3)];
        _selectionView.alpha = 0;
        _selectionView.backgroundColor = [UIColor colorWithRed:242./255. green:93./255. blue:28./255. alpha:1.];
        [self addSubview:_selectionView];
    }

    return _selectionView;
}

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
    self.selectionView.backgroundColor = itemSelectionColor;
    self.dateLabel.backgroundColor = self.selectionView.backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.dateLabel.alpha = self.isSelected ? 1 : .5;
    
    [self setLabelState];
}


#pragma mark Other methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];

    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;

    BOOL isWeekdayResult = day == kSunday || day == kSaturday;

    return isWeekdayResult;
}

- (void)dateWasSelected
{
    self.isSelected = YES;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
