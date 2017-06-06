//
//  MovieDetailsViewController.swift
//  Afostream
//
//  Created by Bahri on 29/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage



class MovieDetailsViewController: UIViewController,UITableViewDataSource,ExpandableLabelDelegate {
    @IBOutlet weak var imgMovie: UIImageView!
    
 
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ViewT: UIView!
    @IBOutlet weak var lblDescription: ExpandableLabel!
    var Movie :MovieModel!
    
    
    @IBOutlet weak var tableView: UITableView!
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    var categories = [HomeCatMovie]()
    
    
  
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

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].CatTitle
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRowSaisonEpisode
        cell.Movies = categories[indexPath.section].Movies
        cell.myViewController = self
        return cell
    }
    
    func MakeGetSaisonEpisode(access_token:String,idMovie:String)
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
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/movies/" + idMovie + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                var HomeCatList = [HomeCatMovie]()
                self.StopLoadingSpinner()
                
                
                
                if let JSONMovie = response.result.value as? [String: Any] {
                    
                     let JSON = JSONMovie["seasons"] as! NSArray
                    
                    for element in JSON {
                        if let saison = element as? [String: Any] {
                            //let idcat = data["_id"] as! Int
                            let title = saison ["title"] as! String
                            
                            let episodes = saison["episodes"] as! NSArray
                            
                            var MoviesList = [MovieModel]()
                            
                            for elementMovie in episodes {
                                if let dataMovie = elementMovie as? [String: Any] {
                                    
                                    let movileTitle = dataMovie["title"] as! String
                                    let episodeNumber = dataMovie["episodeNumber"] as? String
                                    
                                    let movileID = dataMovie["_id"] as! Int
                                    let posterMovie = dataMovie ["poster"] as? [String: Any]
                                    
                                    var urlImageMovie = posterMovie?["imgix"] as! String
                                    
                                    urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                                    let mov : MovieModel = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "",movieInfo: dataMovie)
                                    
                                    
                                    MoviesList.append(mov)
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            let homeCat : HomeCatMovie = HomeCatMovie(CatTitle: title, Movies: MoviesList )
                            HomeCatList.append(homeCat)
                            
                            
                        }
                        
                    }
                    self.categories = HomeCatList
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
    
    


    

    override func viewWillAppear(_ animated: Bool) {
         self.imgMovie.sd_setImage(with: URL(string: Movie.imageUrl), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
    }
    func willExpandLabel(_ label: ExpandableLabel) {
          ViewT.frame.size.height = scrollView.contentSize.height
         tableView.reloadData()
        
    }
    func didExpandLabel(_ label: ExpandableLabel) {
        
    }
    func didCollapseLabel(_ label: ExpandableLabel) {
        ViewT.frame.size.height = scrollView.contentSize.height
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblDescription.delegate = self
        lblDescription.numberOfLines = 3
        lblDescription.collapsed = true
        lblDescription.collapsedAttributedLink = NSAttributedString(string: NSLocalizedString("ReadMore", comment: "") )
         lblDescription.expandedAttributedLink = NSAttributedString(string: NSLocalizedString("ReadLess", comment: "") )
        lblDescription.setLessLinkWith(lessLink: NSLocalizedString("ReadLess", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.red], position: nil)
        
         let synopsis = Movie.movieInfo ["synopsis"] as! String
        
        if synopsis != "null"
        {
        
        lblDescription.text = synopsis
        }
        
        self.MakeGetSaisonEpisode(access_token: GlobalVar.StaticVar.access_token,idMovie: String(Movie.movieID))
       
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    

   

}
