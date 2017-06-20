//
//  MenuViewController.swift
//  Afostream
//
//  Created by Bahri on 10/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import SDWebImage

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
 

    @IBOutlet weak var lblEmailUser: UILabel!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
               imgUser.sd_setImage(with: URL(string: GlobalVar.StaticVar.user_picture_url), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
        lblNameUser.text = GlobalVar.StaticVar.user_first_name + " " + GlobalVar.StaticVar.user_last_name
        lblEmailUser.text = GlobalVar.StaticVar.user_email

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GlobalVar.StaticVar.menuSections[section].numberOfItems
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GlobalVar.StaticVar.menuSections[section].title
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalVar.StaticVar.menuSections.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if indexPath.section  == 0 {
        let cell=tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.lblMenu.text! = GlobalVar.StaticVar.menuSections[indexPath.section][indexPath.row]
        
       
        cell.imgMenu.image = GlobalVar.StaticVar.menuImgArr[indexPath.row]
        
        return cell
            }
         else
         {
            
            let cell=tableView.dequeueReusableCell(withIdentifier: "CatTableViewCell") as! CatTableViewCell
            cell.lblCat.text! = GlobalVar.StaticVar.menuSections[indexPath.section][indexPath.row]
         return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
    if indexPath.section == 0
    {
        
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
  
        if cell.lblMenu.text! == NSLocalizedString("Home", comment: "")
        {
       
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        if cell.lblMenu.text! == NSLocalizedString("Favoris", comment: "")
        {
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "FavorisViewController") as! FavorisViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        if cell.lblMenu.text! == NSLocalizedString("Account", comment: "")
        {
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
    }else if indexPath.section == 1
    {
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "CategorieViewController") as! CategorieViewController
        let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
          newViewcontroller.title = GlobalVar.StaticVar.menuSections[indexPath.section][indexPath.row]
        newViewcontroller.catID = String (GlobalVar.StaticVar.catIDArr [indexPath.row])
        
        revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        
      
        
       // print (GlobalVar.StaticVar.menuSections[indexPath.section][indexPath.row])
        
    }


    }
}
