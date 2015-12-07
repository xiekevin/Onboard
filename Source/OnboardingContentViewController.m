//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"

static NSString * const kDefaultOnboardingFont = @"Helvetica-Light";

#define DEFAULT_TEXT_COLOR [UIColor whiteColor];

static CGFloat const kContentWidthMultiplier = 0.5;
static CGFloat const kDefaultImageViewSize = 100;
static CGFloat const kDefaultTopPadding = 60;
static CGFloat const kDefaultUnderTitlePadding = 30;
static CGFloat const kDefaultBottomPadding = 0;
static CGFloat const kDefaultUnderPageControlPadding = 0;
static CGFloat const kDefaultTitleFontSize = 38;
static CGFloat const kDefaultBodyFontSize = 28;
static CGFloat const kDefaultButtonFontSize = 24;

static CGFloat const kActionButtonHeight = 50;
static CGFloat const kMainPageControlHeight = 35;

@interface OnboardingContentViewController ()

@end

@implementation OnboardingContentViewController

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body image:image buttonText:buttonText action:action];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    self = [super init];
    
    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _titleText = title;
    _body = body;
    _image = image;
    _buttonText = buttonText;
    
    self.buttonActionHandler = action;
    
    // default auto-navigation
    self.movesToNextViewController = NO;
    
    // default icon properties
    if(_image) {
        self.iconHeight = _image.size.height;
        self.iconWidth = _image.size.width;
    }
    
    else {
        self.iconHeight = kDefaultImageViewSize;
        self.iconWidth = kDefaultImageViewSize;
    }
    
    // default title properties
    self.titleFontName = kDefaultOnboardingFont;
    self.titleFontSize = kDefaultTitleFontSize;
    
    // default body properties
    self.bodyFontName = kDefaultOnboardingFont;
    self.bodyFontSize = kDefaultBodyFontSize;
    
    // default button properties
    self.buttonFontName = kDefaultOnboardingFont;
    self.buttonFontSize = kDefaultButtonFontSize;
    
    // default padding values
    self.topPadding = kDefaultTopPadding;
    self.underTitlePadding = kDefaultUnderTitlePadding;
    self.bottomPadding = kDefaultBottomPadding;
    self.underPageControlPadding = kDefaultUnderPageControlPadding;
    
    // default colors
    self.titleTextColor = DEFAULT_TEXT_COLOR;
    self.bodyTextColor = DEFAULT_TEXT_COLOR;
    self.buttonTextColor = DEFAULT_TEXT_COLOR;
    
    // default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded we can generate the content
    [self generateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a delegate set, mark ourselves as the next page now that we're
    // about to appear
    if (self.delegate) {
        [self.delegate setNextPage:self];
    }
    
    // call our view will appear block
    if (self.viewWillAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillAppearBlock();
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if we have a delegate set, mark ourselves as the current page now that
    // we've appeared
    if (self.delegate) {
        [self.delegate setCurrentPage:self];
    }
    
    // call our view did appear block
    if (self.viewDidAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidAppearBlock();
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // call our view will disappear block
    if (self.viewWillDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillDisappearBlock();
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // call our view did disappear block
    if (self.viewDidDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidDisappearBlock();
        });
    }
}

- (void)setButtonActionHandler:(dispatch_block_t)action {
    _buttonActionHandler = action ?: ^{};
}

- (void)generateView {
    // we want our background to be clear so we can see through it to the image provided
    self.view.backgroundColor = [UIColor clearColor];
    if (_maskOpacity > 0) {
        UIView *backgroundMaskView = [[UIView alloc] initWithFrame: self.view.frame];
        backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskOpacity];
        [self.view addSubview:backgroundMaskView];
    }
    
    // do some calculation for some common values we'll need, namely the width of the view,
    // the center of the width, and the content width we want to fill up, which is some
    // fraction of the view width we set in the multipler constant
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat contentTitleWidth = viewWidth * kContentWidthMultiplier;
    CGFloat contentBodyWidth = viewWidth * kContentWidthMultiplier * 1.5;
    
    // create the image view with the appropriate image, size, and center in on screen
//    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    _imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [_imageView setImage:_image];
//    [self.view addSubview:_imageView];
//    [self.view sendSubviewToBack:_imageView];
    
    // create and configure the main text label to be on the left hand slightly below center
    _mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.view.frame) / 2, contentTitleWidth, 0)];
    _mainTextLabel.text = _titleText;
    _mainTextLabel.textColor = self.titleTextColor;
    _mainTextLabel.font = [UIFont fontWithName:self.titleFontName size:self.titleFontSize];
    _mainTextLabel.numberOfLines = 0;
    _mainTextLabel.textAlignment = NSTextAlignmentLeft;
    [_mainTextLabel sizeToFit];
    [self.view addSubview:_mainTextLabel];
    
    // create and configure the sub text label
    _subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_mainTextLabel.frame) + self.underTitlePadding, contentBodyWidth, 0)];
    _subTextLabel.text = _body;
    _subTextLabel.textColor = self.bodyTextColor;
    _subTextLabel.font = [UIFont fontWithName:self.bodyFontName size:self.bodyFontSize];
    _subTextLabel.numberOfLines = 0;
    _subTextLabel.textAlignment = NSTextAlignmentLeft;
    [_subTextLabel sizeToFit];
    [self.view addSubview:_subTextLabel];
    
    // create the action button if we were given button text
    if (_buttonText) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentTitleWidth / 2), CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - kMainPageControlHeight - kActionButtonHeight - self.bottomPadding, contentTitleWidth, kActionButtonHeight)];
        _actionButton.titleLabel.font = [UIFont fontWithName:self.buttonFontName size:self.buttonFontSize];
        [_actionButton setTitle:_buttonText forState:UIControlStateNormal];
        [_actionButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionButton];
    }
}


#pragma mark - Transition alpha

- (void)updateAlphas:(CGFloat)newAlpha {
    _imageView.alpha = newAlpha;
    _mainTextLabel.alpha = newAlpha;
    _subTextLabel.alpha = newAlpha;
    _actionButton.alpha = newAlpha;
}

- (UIImage *)currentImage {
    return _image;
}

#pragma mark - action button callback

- (void)handleButtonPressed {
    // if we want to navigate to the next view controller, tell our delegate
    // to handle it
    if (self.movesToNextViewController) {
        [self.delegate moveNextPage];
    }
    
    // call the provided action handler
    if (_buttonActionHandler) {
        _buttonActionHandler();
    }
}

@end
