//
//  CategorieViewController.swift
//  Afostream
//
//  Created by Bahri on 17/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CategorieViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MenuBnt: UIBarButtonItem!
    
    var MoviesList = [MovieModel]()
    
    var ListFavMovies = [MovieModel]()
    var catID :String = ""
    
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
    
    func IsContainFav (idMovie:Int) -> Bool
    {
     
        
        for i in 0 ..< self.ListFavMovies.count 
        {
            if ListFavMovies[i].movieID == idMovie
            {
                
                return true
            }
            
        }
        return false
    }

    
    func MakeGetCategoriesMovies(access_token:String,idCat:String)
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
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/categorys/" + idCat + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
        
                self.StopLoadingSpinner()
                
                let dt = response.result.value as? [String: Any]
                
                
                if let JSON = dt?["movies"] as! NSArray? {
                    self.MoviesList.removeAll()
                    
                    
                            for elementMovie in JSON {
                                if let dataMovie = elementMovie as? [String: Any] {
                                    
                                    let movileTitle = dataMovie["title"] as! String
                                    let movileLabel = dataMovie["genre"] as? String
                                    
                                    let movileID = dataMovie["_id"] as! Int
                                    
                                    
                                    let posterMovie = dataMovie ["poster"] as? [String: Any]
                                    
                                    var urlImageMovie = posterMovie?["imgix"] as! String
                                    
                                    urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                                    
                                    var mov:MovieModel
                                    
                                    if self.IsContainFav(idMovie: movileID)
                                    {
                                     mov = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: true,movieInfo: dataMovie)
                                    }else
                                    {
                                       mov = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: false,movieInfo: dataMovie)
                                    }
                                    
                                    self.MoviesList.append(mov)
                                    
                                    
                                    
                                    
                                    
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
                            
                            
                            let posterMovie = dataMovie ["poster"] as? [String: Any]
                            
                            var urlImageMovie = posterMovie?["imgix"] as! String
                            
                            urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                            let mov : MovieModel = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: false,movieInfo: dataMovie)
                            
                            
                            self.ListFavMovies.append(mov)
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    self.MakeGetCategoriesMovies (access_token: GlobalVar.StaticVar.access_token, idCat: self.catID)
                    
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
        return self.MoviesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCatTableViewCell
        cell.Movie = self.MoviesList[indexPath.row]
        cell.imgMovie.sd_setImage(with: URL(string: self.MoviesList[indexPath.row].imageUrl), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
        cell.lblTitle.text = self.MoviesList[indexPath.row].title
        
        if self.MoviesList[indexPath.row].isFav
        {
            
            cell.bntFav.setImage(#imageLiteral(resourceName: "RemoveFromFavoritesButtonNormal"), for: UIControlState.normal)
            
        }else
        {
            cell.bntFav.setImage(#imageLiteral(resourceName: "AddToFavoritesButtonNormal"), for: UIControlState.normal)
        }
        

     
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
