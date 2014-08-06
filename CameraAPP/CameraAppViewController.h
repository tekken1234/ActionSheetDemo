//
//  CameraAppViewController.h
//  CameraAPP
//
//  Created by admin on 14/8/4.
//  Copyright (c) 2014年 YEHKUO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface CameraAppViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate> {

NSURL *targetURL;
BOOL isCamera;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)selectPhoto:(id)sender;
- (IBAction)TakePhoto:(id)sender;
- (IBAction)share:(id)sender;



@end
