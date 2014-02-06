//
//  XYZTakePhotoViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 05.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTakePictureViewController.h"
#import "XYZImageFullScreenViewController.h"
#import "XYZGlobalContainer.h"
#import "XYZToDoItem.h"


@interface XYZTakePictureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property BOOL photoTaken;
@property XYZGlobalContainer *globalContainer;


@end

@implementation XYZTakePictureViewController


- (IBAction)unwindToTakePictureController:(UIStoryboardSegue *)segue
{
    
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"FullScreenSegue"]) {
        XYZImageFullScreenViewController *destinationController = (XYZImageFullScreenViewController *)segue.destinationViewController;
        
        destinationController.imageToShow= self.imageView.image;
    }
    
    else if ([[segue identifier] isEqualToString:@"FinalizeShoppingSegue"]) {
        
        [self.globalContainer.toDoItems removeAllObjects];
        [self.globalContainer saveItemsToFile];
        [self.globalContainer.lists insertObject:self.globalContainer.listToBeArchived atIndex:0];
        [self.globalContainer updateBadge];
   
  
        if(self.photoTaken == YES){
            [self.globalContainer writeImage:self.imageView.image];
        }
        //If no photo is to be saved, change it's unique name in the list to be added to nul. Unique name was generated at the instance of listToBeArchived initialization.
        else{
            self.globalContainer.listToBeArchived.imageName = nil;
        }
        
        
        [self.globalContainer saveListsToFile];

    }
    
}

//touched on image view
//requires interaction enabled in storyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.imageView && self.imageView.image != nil && self.photoTaken)
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
    self.photoTaken = YES;
    
    
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

- (void)createCustomBackButton{
    UIImage *temp=nil;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        temp = [UIImage imageNamed:@"backButton.png"];
    }
    else
    {
        temp = [[UIImage imageNamed:@"backButton.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleBordered target:self action:@selector(popBack)];
    
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //swipe gesture for custom back button
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationBarTitleIcon{
    UIImage *temp = [UIImage imageNamed:@"cartSmall.png"];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, temp.size.width, temp.size.height)];
    [view setBackgroundColor:[UIColor colorWithPatternImage:temp]];
    
    self.navigationItem.titleView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoTaken = NO;
    [self createCustomBackButton];
    self.globalContainer = [XYZGlobalContainer globalContainer];
    
    [self setNavigationBarTitleIcon];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
