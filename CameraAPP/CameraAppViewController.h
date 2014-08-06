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



@interface CameraAppViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

NSURL *targetURL;
BOOL isCamera;
  
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, atomic) ALAssetsLibrary* libraryFolder;

- (IBAction)selectPhoto:(id)sender;
- (IBAction)TakePhoto:(id)sender;
- (IBAction)share:(id)sender;



@end
