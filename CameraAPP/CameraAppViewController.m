//
//  CameraAppViewController.m
//  CameraAPP
//
//  Created by admin on 14/8/4.
//  Copyright (c) 2014年 YEHKUO. All rights reserved.
//

#import "CameraAppViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraAppViewController ()

@end

@implementation CameraAppViewController

- (void)viewDidLoad
{
    targetURL = [[NSURL alloc] init];
    isCamera = FALSE;
    useNewAddedAlbum = FALSE;
    

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  
    
    // add custom photo album name with app
    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
    [libraryFolder addAssetsGroupAlbumWithName:@"燁光相機APP" resultBlock:^(ALAssetsGroup *group)
    {
        NSLog(@"Adding Folder:'燁光相機APP', success: %s", group.editable ? "Success" : "Already created: Not Success");
    } failureBlock:^(NSError *error)
    {
        NSLog(@"Error: Adding on Folder");
    }];

}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    // assets contains ALAsset objects.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)TakePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  //      picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        isCamera = TRUE;
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:NULL];
      
        
    }
}

- (IBAction)share:(id)sender {
    UIActivityViewController *controller = [[UIActivityViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)createAlbum:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add New Album", @"new_list_dialog")
                                                          message:@"Plasse name it below" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-DD"];
    NSString *locationString = [df stringFromDate:nowDate];
    [[alert textFieldAtIndex:0] setText:locationString];
    [alert show];
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        
        textField =  [alertView textFieldAtIndex: 0];
       
        NSLog(@"buttonindex is : %i", buttonIndex);
        NSLog(@"string entered=%@", textField);
        if (buttonIndex == 1) {
        ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
        NSString *newAlbumName =[[NSString alloc]initWithFormat:@"%@", textField.text];
        [libraryFolder addAssetsGroupAlbumWithName:newAlbumName resultBlock:^(ALAssetsGroup *group)
         {
             NSLog(@"Adding Folder:%@, success: %s", newAlbumName , group.editable ? "Success" : "Already created: Not Success");
         } failureBlock:^(NSError *error)
         {
             NSLog(@"Error!");
         }];

        }else{
            return;
        }
    }

- (IBAction)switch:(id)sender {
    {
        UISwitch *switchView = (UISwitch *)sender;
        if ([switchView isOn])  {
            useNewAddedAlbum = TRUE;
     //     NSLog(@"textfield is : %@", textField.text);
        } else {
            useNewAddedAlbum = FALSE;
        }
    }
}


- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldShowAssetsGroup:(ALAssetsGroup *)group
{
    // Do not show empty albums
    return ((![[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]) && (group.numberOfAssets > 0) && (1 == 1));
}
- (IBAction)selectPhoto:(id)sender {
  
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
    /*
    // select photo from camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
   
   */




}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSLog(@"info = %@",info);
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	/*
	if([mediaType isEqualToString:@"public.movie"])			//如果是影像檔案
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
		targetURL = url;		//檔案的路徑
		
		if (!(isCamera))
		{
			//保存到
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
			
		}
		
		//get one pixel from video
       // [self getPreViewImg:url];
	} */
	if ([mediaType isEqualToString:@"public.image"])	//如果是照片
    {
        //取得照片
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
        NSString *fileName = [[NSString alloc] init];
        
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
            fileName = [self getFileName:fileName];
        }
        else
        {
            fileName = [self timeStampAsString];
        }
		NSLog(@"filename is %@",fileName);
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        
        [myDefault setValue:fileName forKey:@"fileName"];
		NSLog(@"filename now is : %@",fileName);
        
        if (useNewAddedAlbum) {
            albumName = [NSString stringWithString:textField.text];
        }
        else{
            albumName = [NSString stringWithFormat:@"燁光相機APP"];
        }
        
        if (isCamera) //判定，避免重复保存
		{
		
      
      // new method discover on the net
      
      
      
      ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
      __block ALAssetsGroup* foder;
      
      [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
      //    NSLog(@"textfield is : %@ again", textField.text);
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
        foder = group;
        }
      }
      
      failureBlock:^(NSError* error) {
      
      }];
            
            [library writeImageToSavedPhotosAlbum:[image CGImage]
									  orientation:(ALAssetOrientation)[image imageOrientation]
								  completionBlock:^(NSURL* assetURL, NSError* error)
           
       {
            if (error.code == 0)
            {
      
            // try to get the asset
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                // assign the photo to the album
                [foder addAsset:asset];
                }
                failureBlock:^(NSError* error) {
            }
            ];
            }
            else {
            }
        }
       ];
			
		}
		[self performSelector:@selector(saveImg:) withObject:image afterDelay:0.0];
		
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
	isCamera = FALSE;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"Cancle it");
	isCamera = FALSE;
    useNewAddedAlbum = FALSE;
	[picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark -
#pragma mark userFunc

/*
-(void)getPreViewImg:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    [self performSelector:@selector(saveImg:) withObject:img afterDelay:0.1];
    
}
*/

-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	
	NSString *name = [temp lastObject];
	
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

-(void)saveImg:(UIImage *) image
{
	NSLog(@"Review Image");
	self.imageView.image = image;
}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-DD"];
    NSString *locationString = [df stringFromDate:nowDate];
    return [locationString stringByAppendingFormat:@".png"];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All good
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}

@end