//
//  CLStickerTool.h
//
//  Created by Kevin Siml - Appzer.de on 2015/12/11.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLImageToolBase.h"
#import "ViewController.h"


@interface CLStickerTool : CLImageToolBase <UINavigationControllerDelegate, UIActionSheetDelegate, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;


@end

