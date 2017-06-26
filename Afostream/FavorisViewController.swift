//
//  FavorisViewController.swift
//  Afostream
//
//  Created by Bahri on 10/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

import Alamofire
import SDWebImage

class FavorisViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var MenuBnt: UIBarButtonItem!
    
    
   

    @IBOutlet weak var tableView: UITableView!
    

    
    var ListFavMovies = [MovieModel]()
  
    
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    
    func StartLoadingSpinner()
    {
        laoding_spinner.center=self.view.center
        laoding_spinner.hidesWhenStopped=true
        laoding_spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.gray
        self.view.addSubview(laoding_spinner)
        laoding_spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func StopLoadingSpinner()
    {
        laoding_spinner.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    func ShowAlert(Title:String ,Message:String)
    {
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func MakeGetFavList(access_token:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token
            
        ]
        
        
        
        
        
        
        
        self.StartLoadingSpinner()
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/users/me/favoritesMovies/"  + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                
                self.StopLoadingSpinner()
                
                
                
                
                if let JSON = response.result.value as! NSArray? {
                    
                    self.ListFavMovies.removeAll()
                    
                    for elementMovie in JSON {
                        if let dataMovie = elementMovie as? [String: Any] {
                            
                            let movileTitle = dataMovie["title"] as! String
                            let movileLabel = dataMovie["genre"] as? String
                            
                            let movileID = dataMovie["_id"] as! Int
                            
                            
                           if let posterMovie = dataMovie ["poster"] as? [String: Any]
                           {
                            
                            var urlImageMovie = posterMovie["imgix"] as! String
                            
                            urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                            let mov : MovieModel = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: false,movieInfo: dataMovie)
                            
                            
                            self.ListFavMovies.append(mov)
                            
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
                
                
                
                
                
                
                
                
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ListFavMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavTableViewCell
        cell.Movie = self.ListFavMovies[indexPath.row]
        cell.imgMovie.sd_setImage(with: URL(string: self.ListFavMovies[indexPath.row].imageUrl), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
        cell.lblMovie.text = self.ListFavMovies[indexPath.row].title
        
      
            
        cell.favBnt.setImage(#imageLiteral(resourceName: "RemoveFromFavoritesButtonNormal"), for: UIControlState.normal)
            
     
        return cell
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil
        {
            MenuBnt.target=self.revealViewController()
            MenuBnt.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            self.MakeGetFavList(access_token: GlobalVar.StaticVar.access_token)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
