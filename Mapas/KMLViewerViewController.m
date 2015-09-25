/*
     File: KMLViewerViewController.m 
 Abstract: 
 Displays an MKMapView and demonstrates how to use the included KMLParser class to place annotations and overlays from a parsed KML file on top of the MKMapView.
  
  Version: 1.3 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2012 Apple Inc. All Rights Reserved. 
  
 */

#import "KMLViewerViewController.h"
@import KYDrawerController;
@import Social;
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "EstadoTableViewController.h"

@implementation KMLViewerViewController{
    NSArray *overlays;
    int siguiente;
    PFObject *siguientepf;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.valor = 0;
    
    if(self.nombre == nil){
        
        self.nombre = @"mapaTotalRobos";
    }
    
    [self agregaOverlays:self.nombre];
}

-(void) agregaOverlays:(NSString*) ruta {
    // Locate the path to the route.kml file in the application's bundle
    // and parse it with the KMLParser.
    NSString *path = [[NSBundle mainBundle] pathForResource:ruta ofType:@"kml"];
    NSURL *url = [NSURL fileURLWithPath:path];
    kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    overlays = [kmlParser overlays];
    
    for (id <MKOverlay> overlay in overlays) {
        [map addOverlay:overlay];
    }
    
    //[map addOverlays:overlays];
    
    [map addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)]];
    
    
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kmlParser points];
    [map addAnnotations:annotations];
    
    map.delegate = self;
    
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    //map.visibleMapRect = flyTo;
}





- (void)mapTapped:(UITapGestureRecognizer *)recognizer
{
    //;
    
    MKMapView *mapView = (MKMapView *)recognizer.view;
    if (recognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [recognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    
    int i = 0;
    for (id <MKOverlay> overlay in overlays) {
        MKPolygonView *overlayView = [kmlParser viewForOverlay:overlay];
        if([self coordInPolygon:touchMapCoordinate and:overlayView]){
            break;
        }
        i++;
    }
    
    if(i == 32){
        return;
    }
    


    
    
    siguiente = i;
    NSLog(@"%d",i);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Delincuencia"];
    [query whereKey:@"Id" equalTo:@(siguiente)];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            siguientepf = object;
            [self performSegueWithIdentifier:@"tabla" sender:nil];
            
        }else{
            
        }
    }];
    

    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"tabla"]){
        EstadoTableViewController *vc = [segue destinationViewController];
        vc.estado = siguientepf; 
    }
}


- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (IBAction)didOpen:(id)sender {
    
    KYDrawerController *drawerController = (KYDrawerController *) self.navigationController.parentViewController;
    [drawerController setDrawerState:DrawerStateOpened animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark MKMapViewDelegate

-(BOOL)coordInPolygon:(CLLocationCoordinate2D)coord and:(MKPolygonView *) polygonRenderer {
    
    MKMapPoint mapPoint = MKMapPointForCoordinate(coord);
    return [self pointInPolygon:mapPoint and:polygonRenderer];
}

-(BOOL)pointInPolygon:(MKMapPoint)mapPoint and:(MKPolygonView *) polygonRenderer {
    
    CGPoint polygonViewPoint = [polygonRenderer pointForMapPoint:mapPoint];
    return CGPathContainsPoint(polygonRenderer.path, NULL, polygonViewPoint, NO);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
    
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView *overlayView = [kmlParser viewForOverlay:overlay];
        
        
        NSString *hex = [self hexStringFromColor:overlayView.fillColor];
        
        if(self.valor == 1){
            
            if(![hex isEqualToString:@"#0D6D0C"] &&  ![hex isEqualToString:@"#AAD1B7"]){
                return nil;
            }
            
        }else if(self.valor == 2){
            
            if(![hex isEqualToString:@"#FFE20F"]){
                return nil;
            }
            
        }else if(self.valor == 3){
            
            if(![hex isEqualToString:@"#FF3101"] &&  ![hex isEqualToString:@"#FF5D58"]){
                return nil;
            }
            
        }
        
        //overlayView.fillColor      = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        overlayView.strokeColor    = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        overlayView.lineWidth      = 2;
        
        return overlayView;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [kmlParser viewForAnnotation:annotation];
}

- (IBAction)valueChange:(id)sender {
    
    self.valor = self.segmented.selectedSegmentIndex;
    
    [map removeOverlays:[map overlays]];
    [self agregaOverlays:self.nombre];
}
- (IBAction)share:(id)sender {
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(nil, screenSize.width, screenSize.height, 8, 4*(int)screenSize.width, colorSpaceRef, kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(ctx, 0.0, screenSize.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    [(CALayer*)self.view.layer renderInContext:ctx];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(ctx);
   //[UIImageJPEGRepresentation(image, 1.0) writeToFile:@"screen.jpg" atomically:NO];
    
    SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweet setInitialText:@"Te compartimos datos de seguridad de tu estado. #ZonaSegura #Semanai"];
    [tweet addImage:image];

    [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         if (result == SLComposeViewControllerResultCancelled)
         {
             NSLog(@"The user cancelled.");
         }
         else if (result == SLComposeViewControllerResultDone)
         {
             NSLog(@"The user sent the tweet");
         }
     }];
    [self presentViewController:tweet animated:YES completion:nil];
}
@end
