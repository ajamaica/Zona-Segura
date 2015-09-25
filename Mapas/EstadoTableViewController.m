//
//  EstadoTableViewController.m
//  Mapas
//
//  Created by Arturo Jamaica Garcia on 25/09/15.
//  Copyright © 2015 Brounie SA de CV. All rights reserved.
//

#import "EstadoTableViewController.h"

@interface EstadoTableViewController ()

@end

@implementation EstadoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@",self.estado[@"Estado"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"Delitos";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ",self.estado[@"Delincuencia"]];
    }
    
    if(indexPath.row == 1){
        cell.textLabel.text = @"Robos";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ",self.estado[@"Robos"]];
    }
    
    if(indexPath.row == 2){
    
        cell.textLabel.text = @"Homicidios";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ",self.estado[@"Homicidios"]];
    }
    if(indexPath.row == 3){
        
        cell.textLabel.text = @"Delitos Patrimoniales";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ",self.estado[@"Patrimoniales"]];
    }
    if(indexPath.row == 4){
        
        cell.textLabel.text = @"Lesiones";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ",self.estado[@"Lesiones"]];
    }
    if(indexPath.row == 5){
        
        cell.textLabel.text = @"Otros";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ",self.estado[@"Otros"]];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
