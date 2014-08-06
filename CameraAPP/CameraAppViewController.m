//
//  CameraAppViewController.m
//  CameraAPP
//
//  Created by admin on 14/8/4.
//  Copyright (c) 2014年 YEHKUO. All rights reserved.
//

#import "CameraAppViewController.h"

@interface CameraAppViewController ()

@end

@implementation CameraAppViewController

- (void)viewDidLoad
{
    targetURL = [[NSURL alloc] init];
    isCamera = FALSE;
    

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
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

- (IBAction)selectPhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [picker setAllowsEditing:YES];
        NSLog(@"testttt");
        NSLog(@"added this line after branch added (newbranchtest)");
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}



    

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSLog(@"info = %@",info);
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	/*
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
		targetURL = url;		//视频的储存路径
		
		if (!(isCamera))
		{
			//保存视频到相册
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
			
		}
		
		//获取视频的某一帧作为预览
       // [self getPreViewImg:url];
	} */
	if ([mediaType isEqualToString:@"public.image"])	//被选中的是图片
    {
        //获取照片实例
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
        if (isCamera) //判定，避免重复保存
		{
			//保存到相册
            
			UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
			
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