//
//  ViewController.h
//  CLImageEditorDemo
//
//  Created by Kevin Siml - Appzer.de on 2015/11/14.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CLImageToolBase.h"

#import "GADBannerView.h"
#import "GADInterstitial.h"

@import Photos;

@class GADBannerView, GADInterstitial, GADRequest;

NSString *_imageDate;
NSString *_imageTime;
NSString *_imageLocation;
NSString *_imageLon;
NSString *_imageLat;


@interface ViewController : UIViewController <CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITabBarDelegate, UIActionSheetDelegate, UIScrollViewDelegate, SKProductsRequestDelegate,SKPaymentTransactionObserver, GADBannerViewDelegate, GADInterstitialDelegate>

{

    
    IBOutlet __weak UIScrollView *_scrollView;
    IBOutlet __weak UIImageView *_imageView;
    UIImageView *bgImageView;
    NSString *imagePath;
    NSString *sheetNo;
    NSString *imagePathInstagram;
    
    CLLocationManager *locationManager;

    SKProductsRequest *productsRequest;
    NSArray *validProducts;
    UIActivityIndicatorView *activityIndicatorView;
    IBOutlet UILabel *productTitleLabel;
    IBOutlet UILabel *productDescriptionLabel;
    IBOutlet UILabel *productPriceLabel;
    IBOutlet UIButton *purchaseButton;
    
    NSUserDefaults *prefs;
    
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
}

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;
-(GADRequest *)createRequest;

- (void)fetchAvailableProducts;
- (BOOL)canMakePurchases;
- (void)purchaseMyProduct:(SKProduct*)product;

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@end
