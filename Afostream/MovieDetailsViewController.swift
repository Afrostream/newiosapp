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
import ExpandableLabel


class MovieDetailsViewController: UIViewController,UITableViewDataSource,ExpandableLabelDelegate {
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }

    @IBOutlet weak var imgMovie: UIImageView!
    
 
    @IBOutlet weak var bntPlay: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ViewT: UIView!
   
    @IBOutlet weak var lblDescription: ExpandableLabel!
    var Movie :MovieModel!
    
    
    @IBOutlet weak var tableView: UITableView!
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    var categories = [HomeCatMovie]()
    
    var videoDrm:Bool? = false
    var videoDuration:Int? = 0
    var videoMp4DownloadUrl:String? = ""
    var videoMp4Size:String? = ""
    var videoMp4DecipheredSize:String? = ""
    var videoMp4Trailer:String? = ""
    
    var videoDashUrl:String? = ""
    var videoHlsUrl:String? = ""
    var videoSmoothUrl:String? = ""
    
     var videoID:String? = ""
    
    var movieType :String? = ""
  
    @IBAction func BntPlayAction(_ sender: Any) {
        

        
        
        let videoPlayerViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        
          videoPlayerViewController.videoURL = self.videoHlsUrl!
        self.present(videoPlayerViewController, animated: true, completion: nil)

        
    }
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
                            
                            var IsFirstEpisode : Bool = true
                            
                            for elementMovie in episodes {
                                if let dataMovie = elementMovie as? [String: Any] {
                                    
                                    
                                    let dataVideo = dataMovie["video"]  as? [String: Any]
                                    
                                    let video_id = dataVideo?["_id"] as! String
                                    
                                    if self.movieType == "serie"
                                    {
                                    
                                        if IsFirstEpisode == true
                                        {
                                            IsFirstEpisode = false
                                            self.videoID = video_id
                                         self.MakeGetVideoInfo(access_token: GlobalVar.StaticVar.access_token, idVideo: video_id)
                                        }
                                    }
                                    
                                    let movileTitle = dataMovie["title"] as! String
                                    let episodeNumber = dataMovie["episodeNumber"] as? String
                                    
                                    let movileID = dataMovie["_id"] as! Int
                                    if let posterMovie = dataMovie ["poster"] as? [String: Any]
                                    {
                                    
                                    var urlImageMovie = posterMovie["imgix"] as! String
                                    
                                    urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                                    let mov : MovieModel = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: false,movieInfo: dataMovie)
                                    
                                    
                                    MoviesList.append(mov)
                                    }
                                    
                                    
                                    
                                    
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
    
    

    func MakeGetVideoInfo(access_token:String,idVideo:String)
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
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/videos/" + idVideo + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
          
                self.StopLoadingSpinner()
                
                
                
                if let JSONVideo = response.result.value as? [String: Any] {
                    
                    self.videoDrm = JSONVideo["drm"] as? Bool
                    self.videoDuration = JSONVideo["duration"] as? Int
                    
                    self.videoMp4DownloadUrl = JSONVideo["sourceMp4"] as? String
                    
                
                     self.videoMp4Size = JSONVideo["sourceMp4Size"] as? String
                    
                     self.videoMp4DecipheredSize = JSONVideo["sourceMp4DecipheredSize"] as? String

                    self.videoMp4Trailer = JSONVideo["sourceMp4Deciphered"] as? String
                    
                    if let JSON = JSONVideo["sources"] as? NSArray {
                    
                   
                    for element in JSON {
                        if let sr = element as? [String: Any] {
                            //let idcat = data["_id"] as! Int
                            let type = sr ["type"] as! String
                            
                            let src = sr["src"] as! String
                            print (src)
                            
                        if type == "application/dash+xml"
                        {
                            self.videoDashUrl = src
                            
                        }else if type == "application/vnd.apple.mpegurl"
                        {
                            
                            self.videoHlsUrl = src
                                
                        }else if type == "application/vnd.ms-sstr+xml"
                        {
                            self.videoSmoothUrl = src
                        }
                            
                         self.bntPlay.isHidden = false
                            
                            
                        }

                    
                    
                    
                    
                   }
                    
                 }
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
        
        self.bntPlay.isHidden = true
        
         let synopsis = Movie.movieInfo ["synopsis"] as! String
        
         self.movieType = Movie.movieInfo ["type"] as! String
        
        let isLive:Bool = Movie.movieInfo ["live"] as! Bool
        
        
        if self.movieType == "serie"
        {
            self.videoID = ""
        }else
        {
        self.videoID = Movie.movieInfo ["videoId"] as! String
        }
        
        
        
        if isLive
        {
            self.movieType = "live"
        }
        
        if synopsis != "null"
        {
        
        lblDescription.text = synopsis
        }
        
       
        if self.movieType != "serie"
        {
            if self.videoID != nil {
                self.MakeGetVideoInfo (access_token: GlobalVar.StaticVar.access_token,idVideo: self.videoID!)
            }
        }
        
        self.MakeGetSaisonEpisode(access_token: GlobalVar.StaticVar.access_token,idMovie: String(Movie.movieID))
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    

   

}
