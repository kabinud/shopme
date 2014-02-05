//
//  XYZTakePhotoViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 05.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTakePictureViewController.h"
#import "XYZImageFullScreenViewController.h"


@interface XYZTakePictureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end

@implementation XYZTakePictureViewController

- (IBAction)unwindToTakePictureController:(UIStoryboardSegue *)segue
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"FullScreenSegue"]) {
        
        XYZImageFullScreenViewController *destinationController = (XYZImageFullScreenViewController *)segue.destinationViewController;
        
        destinationController.imageToShow= self.imageView.image;
        
        NSLog(@"prepareforsegue");
        
    }
}

//touched on image view
//requires interaction enabled in storyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.imageView && self.imageView.image != nil)
    {
         [self performSegueWithIdentifier: @"FullScreenSegue" sender: self];
    }
    
}





- (IBAction)takePictureButtonPressed:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
    else{
        UIImagePickerController *picker;
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
      UIImage * chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  
    
    
    
    
    
    
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
