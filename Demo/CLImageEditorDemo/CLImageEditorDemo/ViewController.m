//
//  ViewController.m
//  CLImageEditorDemo
//
//  Created by Kevin Siml - Appzer.de on 2015/11/14.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "ViewController.h"
#import "CLImageEditor.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Scale.h"

#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "GADRequest.h"
#import "AdmobID.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#define kTutorialPointProductID @"de.appzer.PhotoXo.iAP"

@interface ViewController ()
<CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>
@property (nonatomic, retain) UIPopoverController *activityPopoverController;
@end

@implementation ViewController

@synthesize bannerView = bannerView_;
@synthesize interstitial = interstitial_;

UIScrollView *_menuScroll;
NSString *loadImg = @"NO";
BOOL checkZoomImage;
BOOL restoreMyProductBool;


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.progressView.hidden = YES;
    
    prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs stringForKey:@"PurchasedPro"] isEqualToString: @"YES"]){
        NSLog(@"Is Pro");
    } else {
        NSLog(@"Is not Pro");
        
    }
    
    //Set a black theme rather than a white one
	[[CLImageEditorTheme theme] setToolbarTextColor:[UIColor blackColor]];
	[[CLImageEditorTheme theme] setToolIconColor:@"black"];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationGetActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Listen for Double Tap Zoom
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [_scrollView addGestureRecognizer:doubleTap];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-118, self.view.frame.size.width, 70)];
    _menuScroll.backgroundColor = [UIColor clearColor];
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_menuScroll];
    _menuScroll.alpha=0;

    [self refreshImageView];
    
    //Banner admob integration
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    self.bannerView.adUnitID = MyBannerAdUnitID;
    self.bannerView.delegate = self;
    [self.bannerView setRootViewController:self];
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[self createRequest]];
}

//Banner admob
- (GADRequest *)createRequest{
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
}

- (void) adViewDidReceiveAd:(GADBannerView *)view{
    NSLog(@"Ad Received");
    [UIView animateWithDuration:1.0 animations:^{
        view.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    }];
}

//Interstitial admob
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad due to: %@", error.localizedFailureReason);
}
-(void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"on screen");
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
    //self.interstitial = nil;
}
/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
    self.interstitial = nil;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImagesFromLibrary];
}

- (void)orientationChanged:(NSNotification *)notification{
    NSLog(@"Orientation changed");
    [self performSelector:@selector(refreshImageView) withObject:self afterDelay:0.5 ];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale && _scrollView.zoomScale == _scrollView.maximumZoomScale){
        checkZoomImage = YES;
    }
    if (_scrollView.zoomScale < _scrollView.maximumZoomScale && _scrollView.zoomScale == _scrollView.minimumZoomScale) {
        checkZoomImage = NO;
    }
    
    
    if (checkZoomImage) {
        [_scrollView setZoomScale:_scrollView.zoomScale *0.1 animated:YES];
    }else{
        [_scrollView setZoomScale:_scrollView.zoomScale *10 animated:YES];
    }
}

- (void)ApplicationGetActive {
    [self hideImagePanel];
    [self performSelector:@selector(loadImagesFromLibrary) withObject:self afterDelay:0.5 ];

}
/*--------------------------------------------------------------
-- get the metadata of the image from a PHAsset
--------------------------------------------------------------*/

- (NSDictionary *)grabImageDataFromAsset:(PHAsset *)asset
{
    __block NSMutableDictionary *imageAssetInfo = [NSMutableDictionary new];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:
     ^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
         if ([info[@"PHImageResultIsInCloudKey"] isEqual:@YES]) {
             // in the cloud
             NSLog(@"in the cloud (sync grabImageDataFromAsset)");
         }
         imageAssetInfo = [info mutableCopy];
         if (imageData) {
             imageAssetInfo[@"IMAGE_NSDATA"] = imageData;
         }
     }];
    return imageAssetInfo;
}

/*--------------------------------------------------------------
-- get the UIImage instance from a PHAsset
--------------------------------------------------------------*/

- (UIImage*)grabImageThumbFromAsset:(PHAsset *)asset
{
    __block UIImage *returnImage;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(210, 210)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:
     ^(UIImage *result, NSDictionary *info) {
         returnImage = result;
     }];
    return returnImage;
}

/*--------------------------------------------------------------
-- get all images from library from a PHAsset
--------------------------------------------------------------*/
-(void)loadImagesFromLibrary{
    
    CGFloat __block W = 70;
    CGFloat __block H = _menuScroll.height;
    CGFloat __block x = 0;
    CGFloat __block counter = 0;
    
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if(asset && counter<30){
            UIImage *img = [self grabImageThumbFromAsset:asset];
            //NSLog(@"%@",asset);
            if(img){
                CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedImagePanel:) toolInfo:nil];
                view.iconImage = [img aspectFit:CGSizeMake(210, 210)];
                view.userInfo = @{@"TappedImageNumber" : [@(counter) stringValue]};
                [_menuScroll addSubview:view];
                x += W;
                counter+=1;
            }
        }
        [_menuScroll setContentSize:CGSizeMake(x, H)];
    }];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(-300, 0, x+1200, H);
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [_menuScroll.layer insertSublayer:gradient atIndex:0];
    _menuScroll.alpha=0;
    _menuScroll.top=self.view.frame.size.height+118;
    if(counter==0){
        _menuScroll.hidden=YES;
    }
    
    [self showImagePanel];
}


- (void)tappedImagePanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    int imgNumber = [view.userInfo[@"TappedImageNumber"] intValue];
    
    UIActivityIndicatorView *indicator = [CLImageEditorTheme indicatorView];
    indicator.center = CGPointMake(super.view.width/2, super.view.height/2);
    [super.view addSubview:indicator];
    [indicator startAnimating];
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.networkAccessAllowed = YES;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *getImageAsset;
    getImageAsset = [fetchResult objectAtIndex:imgNumber];
    [[PHImageManager defaultManager]requestImageForAsset:getImageAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info){
        if ([info objectForKey:PHImageErrorKey] == nil && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            
            if ([info valueForKey:PHImageResultIsInCloudKey]) {
                // Image is in iCloud
                if (result) {
                    // Image is downloaded
                    loadImg=@"YES";
                    _imageView.image = result;
                    [self refreshImageView];
                    [indicator removeFromSuperview ];
                }
            }
            
        }
    }];
}

- (void)hideImagePanel
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.alpha = 0;
                         _menuScroll.top = self.view.frame.size.height+118;
                         _menuScroll.width = self.view.frame.size.width;
                     }
     ];
}

- (void)showImagePanel
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.alpha = 1;
                         _menuScroll.top = self.view.frame.size.height-118;
                         _menuScroll.width = self.view.frame.size.width;
                     }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

/*- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}*/

- (void)pushedNewBtn
{
        sheetNo=@"1";
        NSLog(@"New Image");
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TXT_Camera", nil), NSLocalizedString(@"TXT_PhotoLibrary", nil), nil];
        //[sheet showInView:self.view.window];
        CGRect cellRect = _imageView.bounds;
        cellRect.size.width = _imageView.frame.size.width * 2;
        cellRect.origin.x = -(_imageView.frame.size.width/2)-219;
        cellRect.origin.y = (_imageView.frame.size.height + 40.0);
        [sheet showFromRect:cellRect inView: _imageView animated:YES];
}

- (void)pushedEditBtn
{
        if(_imageView.image){
            [self hideImagePanel];
            CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:_imageView.image delegate:self];
            [self presentViewController:editor animated:YES completion:nil];
        } else {
            [self pushedNewBtn];
        }
}

- (void)pushedSaveBtn
{
        if(_imageView.image){
            
            // WATERMARK
            UIImage *WaterImage = [UIImage imageNamed:@"made_with_photoxo.png"];
            UIImage *Image2Save = _imageView.image;
            CGSize newSize = CGSizeMake(Image2Save.size.width, Image2Save.size.height);
            UIGraphicsBeginImageContext( newSize );
            
            float waterwidth = Image2Save.size.width/4;
            float ratio = WaterImage.size.width/WaterImage.size.height;
            float waterheight = waterwidth/ratio;
            
            [Image2Save drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            if(![[prefs stringForKey:@"PurchasedPro"] isEqualToString: @"YES"]){
               [WaterImage drawInRect:CGRectMake(20,20,waterwidth,waterheight)]; // draw watermark if not purchased PRO
            }
            
            UIImage *Image2Save2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // End WATERMARK

            //NSArray *excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypeAddToReadingList];
            NSArray *excludedActivityTypes = @[UIActivityTypeAddToReadingList];
            
            //NSURL *url = [NSURL URLWithString:@"http://www.appzer.de/PhotoXo.html"];
            //NSString *text = NSLocalizedString(@"TXT_CopyNote", nil);
            
            NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            
            NSString *fileName = [NSString stringWithFormat:@"PhotoXo_%@.jpg", timestamp];
            NSString *tempDir = NSTemporaryDirectory();
            imagePath = [tempDir stringByAppendingPathComponent:fileName];
            
            NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(Image2Save2,0.90)];
            [imageData writeToFile:imagePath atomically:YES];
            
            NSURL *url = [NSURL URLWithString:imagePath];
            
            UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[Image2Save2,url] applicationActivities:nil];
            
            activityView.excludedActivityTypes = excludedActivityTypes;
            activityView.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) { // DeploymentTarget >= iOS 8.0
                if(completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
                    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TXT_Saved", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"TXT_OK", nil) otherButtonTitles:nil];
                    //[alert show];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TXT_Saved", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"TXT_OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        // action 1
                        
                        if (self.interstitial)
                            return;
                        
                        self.interstitial = [[GADInterstitial alloc] init] ;
                        
                        self.interstitial.delegate = self;
                        
                        self.interstitial.adUnitID = @"ca-app-pub-8838429886793205/8436980971";   // this key is working in admob //
                        
                        GADRequest *request = [GADRequest request];
                        request.testing = NO;//-temp
                        [self.interstitial loadRequest: request];

                    }]];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    [self hideImagePanel];
                    [self performSelector:@selector(loadImagesFromLibrary) withObject:self afterDelay:0.5 ];
                }
            };
            
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [self presentViewController:activityView animated:YES completion:nil];
            }
            //if iPad
            else
            {
                // Change Rect to position Popover
                UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityView];
                NSLog(@"%f",self.view.frame.size.width/2);
                [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, _imageView.frame.size.height+103, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
        } else {
            [self pushedNewBtn];
        }
}

- (void)pushedStoreBtn
{
    sheetNo=@"2";
    NSLog(@"Sheet Buy");
    UIActionSheet *sheet2 = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"TXT_Buy_Info", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TXT_Buy", nil),NSLocalizedString(@"TXT_Restore", nil), nil];
    CGRect cellRect = _imageView.bounds;
    cellRect.size.width = _imageView.frame.size.width * 2;
    cellRect.origin.x = -(_imageView.frame.size.width/2)+110;
    cellRect.origin.y = (_imageView.frame.size.height + 40.0);
    [sheet2 showFromRect:cellRect inView: _imageView animated:YES];
}

- (void)pushedInfoBtn
{
    sheetNo=@"3";
    NSLog(@"Sheet Info");
    UIActionSheet *sheet3 = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"TXT_Select_Info", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TXT_Support", nil), NSLocalizedString(@"TXT_Rate", nil), NSLocalizedString(@"TXT_MoreApps", nil), nil];
    CGRect cellRect = _imageView.bounds;
    cellRect.size.width = _imageView.frame.size.width * 2;
    cellRect.origin.x = -(_imageView.frame.size.width/2)+219;
    cellRect.origin.y = (_imageView.frame.size.height + 40.0);
    [sheet3 showFromRect:cellRect inView: _imageView animated:YES];
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imageDate=@"";
    _imageTime=@"";
    _imageLat=@"";
    _imageLon=@"";
    _imageLocation=@"";


    // Read Exif/TIFF/MetaData from cameras image
    NSDictionary *metadata1 = [info objectForKey:UIImagePickerControllerMediaMetadata];
    if(metadata1){
        //NSLog(@"Metadata library: %@",metadata1);
        NSString *IMG_date = [[metadata1 objectForKey: @"{TIFF}"] valueForKey:@"DateTime"];
        NSArray* DateTime = [IMG_date componentsSeparatedByString: @" "];
        _imageDate = [[DateTime objectAtIndex: 0] stringByReplacingOccurrencesOfString:@":" withString:@"-"];
        _imageTime = [DateTime objectAtIndex: 1];
        NSLog(@"Date: %@ ### Time: %@", _imageDate, _imageTime);
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }

    // Read Exif/TIFF/MetaData from librarys image
    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    if(referenceURL){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            NSDictionary *metadata2 = rep.metadata;
        
            NSString *IMG_date = [[metadata2 objectForKey: @"{TIFF}"] valueForKey:@"DateTime"];
            if(IMG_date){
                NSArray* DateTime = [IMG_date componentsSeparatedByString: @" "];
                _imageDate = [[DateTime objectAtIndex: 0] stringByReplacingOccurrencesOfString:@":" withString:@"-"];
                _imageTime = [DateTime objectAtIndex: 1];
                NSLog(@"Date: %@ ### Time: %@", _imageDate, _imageTime);
                NSLog(@"Metadata library: %@",metadata2);
                _imageLat = [[metadata2 objectForKey: @"{GPS}"] valueForKey:@"Latitude"];
                _imageLon = [[metadata2 objectForKey: @"{GPS}"] valueForKey:@"Longitude"];
                //NSLog(@"Lat: %@ ### Lon: %@", _imageLat, _imageLon);
                [self getLocation];
            }
        } failureBlock:^(NSError *error) {
            // error handling
        }];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
    
    [self hideImagePanel];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _imageLat =  [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    _imageLon =  [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    //NSLog(@"Lat: %@ ### Lon: %@", _imageLat, _imageLon);
    [locationManager stopUpdatingLocation];
    [self getLocation];
}

- (void) getLocation
{
    CLLocation *NewLocation=[[CLLocation alloc] initWithLatitude:[_imageLat doubleValue] longitude:[_imageLon doubleValue]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:NewLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             _imageLocation = [NSString stringWithFormat:@"%@", locatedAt];
             NSLog(@"%@",_imageLocation);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    _imageView.image = image;
    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [self refreshImageView];
}

#pragma mark- Tapbar delegate

- (void)deselectTabBarItem:(UITabBar*)tabBar
{
    tabBar.selectedItem = nil;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self performSelector:@selector(deselectTabBarItem:) withObject:tabBar afterDelay:0.2];
    
    //NSLog(@"Item.x %f",tabBar.subviews[item.tag].frame.origin.x);
    
    switch (item.tag) {
        case 0:
            [self pushedNewBtn];
            break;
        case 1:
            [self pushedEditBtn];
            break;
        case 2:
            [self pushedSaveBtn];
            break;
        case 3:
            [self pushedStoreBtn];
            break;
        case 4:
            [self pushedInfoBtn];
            break;
        default:
            break;
    }
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

{
    
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    if([sheetNo isEqual:@"1"]){
    
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
        if([UIImagePickerController isSourceTypeAvailable:type]){
            if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                type = UIImagePickerControllerSourceTypeCamera;
            }
        
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = NO;
            picker.delegate   = self;
            picker.sourceType = type;
        
            [self presentViewController:picker animated:YES completion:nil];
        
        }
    } else if([sheetNo isEqual:@"3"]){
        
        if(buttonIndex==actionSheet.cancelButtonIndex){
            return;
        } else if(buttonIndex==0){
            // Support
            NSURL* url = [[NSURL alloc] initWithString:@"http://www.appzer.de/PhotoXo.html"];
            [[UIApplication sharedApplication] openURL:url];
            
        } else if(buttonIndex==1){
            // Rate
            NSURL* url = [[NSURL alloc] initWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1060209631&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
            [[UIApplication sharedApplication] openURL:url];
            
        } else if(buttonIndex==2){
            // More Apps
            NSURL* url = [[NSURL alloc] initWithString:@"http://www.appzer.de"];
            [[UIApplication sharedApplication] openURL:url];
            
        } else {
            return;
        }

    } else {
        
        if(buttonIndex==actionSheet.cancelButtonIndex){
            return;
        } else if(buttonIndex==0){
            NSLog(@"Buy");
            // IAP
            // Adding activity indicator
            activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicatorView.center = self.view.center;
            [activityIndicatorView hidesWhenStopped];
            [self.view addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            restoreMyProductBool=FALSE;
            [self fetchAvailableProducts];
            // END IAP
        } else if(buttonIndex==1){
            NSLog(@"Restore");
            // IAP
            // Adding activity indicator
            activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicatorView.center = self.view.center;
            [activityIndicatorView hidesWhenStopped];
            [self.view addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            restoreMyProductBool=TRUE;
            [self fetchAvailableProducts];
            // END IAP
        } else {
            return;
        }
        
    }
}

#pragma mark- ScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.superview.frame.size.width;
    CGFloat H = _imageView.superview.frame.size.height;
    
    CGRect rct = _imageView.superview.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.superview.frame = rct;
}

- (void)resetImageViewFrame
{
    _imageView.frame = self.view.bounds;

    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    _imageView.frame = CGRectMake(0, 0, W/1.1, H/1.1);
    _imageView.superview.bounds = _imageView.bounds;
    
    // Shadow to image view
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOpacity = 1.0f;
    _imageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _imageView.layer.shadowRadius = 5.0f;
    _imageView.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_imageView.bounds];
    _imageView.layer.shadowPath = path.CGPath;

    // background Image with image and blurred effect
    [bgImageView removeFromSuperview];

    // Scale the Image for better performance
    UIImage *scaledImage = [_imageView.image scaleToSize:CGSizeMake(self.view.width/2, self.view.height/2)];
    
    // do blur effect
    bgImageView = [[UIImageView alloc] initWithImage:[scaledImage applyLightEffect]];
    
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    bgImageView.alpha = 0.5;
    _imageView.alpha = 0.5;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
            animations:^{
                bgImageView.alpha = 1;
                _imageView.alpha = 1;
            }
            completion:^(BOOL finished) {
            }
     ];
    
    // Background Paralax
    /*bgImageView.frame = CGRectMake(-251, -251, self.view.frame.size.width+251, self.view.frame.size.height+251);
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(0);
    verticalMotionEffect.maximumRelativeValue = @(250);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(0);
    horizontalMotionEffect.maximumRelativeValue = @(250);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [bgImageView addMotionEffect:group];*/
    
    
}

- (void)resetZoomScaleWithAnimate:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

- (void)refreshImageView
{
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimate:NO];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController isKindOfClass:[UIImagePickerController class]] && [viewController isKindOfClass:[CLImageEditor class]]){
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidPush:)];
    }
}

- (void)cancelButtonDidPush:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

// IAP
-(void)fetchAvailableProducts{
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:kTutorialPointProductID,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (BOOL)restorePurchases
{
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    return true;
}

- (void)purchaseMyProduct:(SKProduct*)product{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)restoreMyProduct:(SKProduct*)product{
    if ([self restorePurchases]) {
        [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier isEqualToString:kTutorialPointProductID]) {
                    NSLog(@"Purchased");
                    
                    [prefs setObject:@"YES" forKey:@"PurchasedPro"];
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TXT_Buy_Success", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_OK", nil) otherButtonTitles: nil];
                    [alertView show];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored");
                if ([transaction.payment.productIdentifier isEqualToString:kTutorialPointProductID]) {
                    
                    [prefs setObject:@"YES" forKey:@"PurchasedPro"];
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TXT_Restored", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_OK", nil) otherButtonTitles: nil];
                    [alertView show];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                break;
            default:
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if (count>0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        if ([validProduct.productIdentifier isEqualToString:kTutorialPointProductID]) {
            NSLog(@"Product Title: %@",validProduct.localizedTitle);
            NSLog(@"Product Desc: %@",validProduct.localizedDescription);
            NSLog(@"Product Price: %@",validProduct.price);
            if(restoreMyProductBool==TRUE){
                [self restoreMyProduct:[validProducts objectAtIndex:0]];
            } else {
                [self purchaseMyProduct:[validProducts objectAtIndex:0]];
            }
        }
    }
    [activityIndicatorView stopAnimating];
}
// END IAP

@end
