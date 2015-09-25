/*
Copyright (c) 2015 Kyohei Yamaguchi. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit
import KYDrawerController

class DrawerTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            let mainNavigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNavigation") as! UINavigationController
            
            let viewController = mainNavigation.viewControllers[0] as! KMLViewerViewController
            
            switch indexPath.row {
            case 0:
                viewController.title = "Total de Robos"
                viewController.nombre = "mapaTotalRobos"
            case 1:
                viewController.title = "Total de Homicidios"
                viewController.nombre = "mapaTotalHomicidios"
            case 2:
                viewController.title = "Total de Delitos de Lesiones"
                viewController.nombre = "mapaTotalLesiones"
            case 3:
                viewController.title = "Indice de Delincuencia"
                viewController.nombre = "mapaTotalDelincuencia"
            case 4:
                viewController.title = "Total de Delitos Patrimoniales"
                viewController.nombre = "mapaTotalPatrimoniales"
            case 5:
                viewController.title = "Otro Tipo de Delitos"
                viewController.nombre = "mapaTotalOtros"
            default:
                viewController.title = "Total de Lesiones"
                viewController.nombre = "mapaTotalOtros"
            }
            drawerController.mainViewController = mainNavigation
            drawerController.setDrawerState(.Closed, animated: true)
        }
    }

}
