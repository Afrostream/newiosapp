//
//  MainViewController.swift
//  Afostream
//
//  Created by Bahri on 09/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage




class MainViewController: UIViewController,UIScrollViewDelegate,UITableViewDataSource {

    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var MenuBnt: UIBarButtonItem!
    
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var SlideScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
      var categories = [HomeCatMovie]()
    var slidesMain = [Slide]()
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
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
                print(UIDevice.current.orientation.isLandscape)
        

        DispatchQueue.main.async {
            self.SlideScrollView.frame = self.viewScroll.frame
            
            self.SlideScrollView.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.SlideScrollView.frame.height)
            self.SlideScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(self.slidesMain.count), height: self.SlideScrollView.frame.height)
            
    
            
            
            
            for i in 0 ..< self.slidesMain.count {
                
                
                
                let xPosition = self.SlideScrollView.frame.size.width * CGFloat(i)
                self.slidesMain [i].frame = CGRect(x: xPosition, y: 0, width: self.SlideScrollView.frame.width, height: 200)
                
                self.SlideScrollView.contentSize.width = self.SlideScrollView.frame.width * CGFloat(i + 1)
                
                self.SlideScrollView.addSubview(self.slidesMain[i])
                
                
                
                
            }
            

        }
 
        
    }
    
    func SliderMoveToNextPage (sender: Timer){
        
          let dict = sender.userInfo as! NSDictionary
        
        let pageWidth:CGFloat = self.SlideScrollView.frame.width
        let slides : [Slide] = dict["sliders"] as! [Slide]
        let maxWidth:CGFloat = pageWidth * CGFloat(slides.count)
        let contentOffset:CGFloat = self.SlideScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.SlideScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.SlideScrollView.frame.height), animated: true)
    }
    func SetupSlidesInScrollView (slides: [Slide])
    {
        SlideScrollView.frame = viewScroll.frame
        
        SlideScrollView.frame = CGRect (x: 0, y: 0, width: view.frame.width, height: SlideScrollView.frame.height)
        SlideScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: SlideScrollView.frame.height)
        
        slidesMain = slides
        
   
        
        for i in 0 ..< slides.count {
           
           
            
            let xPosition = self.SlideScrollView.frame.size.width * CGFloat(i)
             slides [i].frame = CGRect(x: xPosition, y: 0, width: self.SlideScrollView.frame.width, height: 200)
            
            SlideScrollView.contentSize.width = SlideScrollView.frame.width * CGFloat(i + 1)
    
            SlideScrollView.addSubview(slides[i])
            
           
            
        
        }
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(SliderMoveToNextPage(sender:)), userInfo: ["sliders": slides], repeats: true)
        
        
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        cell.Movies = categories[indexPath.section].Movies
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
            
            self.MakeGetUserInfo(access_token:  GlobalVar.StaticVar.access_token)
            self.MakeGetCategories(access_token:  GlobalVar.StaticVar.access_token)
            self.MakeGetSlide(access_token: GlobalVar.StaticVar.access_token)
            
            self.MakeGetCategoriesHomeMovies(access_token: GlobalVar.StaticVar.access_token)
            
        
            SlideScrollView.isPagingEnabled = true
            SlideScrollView.showsHorizontalScrollIndicator = false
            SlideScrollView.showsVerticalScrollIndicator = false
            SlideScrollView.delegate = self
            
            viewScroll.bringSubview(toFront: PageControl)
            
           
            
        }
        
        // Do any additional setup after loading the view.
    }
    

    func MakeGetUserInfo(access_token:String)
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
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/users/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as? [String: Any] {
                    var user_id = JSON["_id"] as! Int
                    var user_first_name = JSON["first_name"] as! String
                    var user_last_name = JSON["last_name"] as! String
                    var user_picture_url = JSON["picture"] as! String
                    
                    var user_gender = JSON["gender"] as! String
                    var user_birthday = JSON["birthDate"] as! String
                    var user_postalAddressCountry = JSON["postalAddressCountry"] as! String
                    var user_postalAddressCity = JSON["postalAddressCity"] as! String
                     var user_postalAddressStreet = JSON["postalAddressStreet"] as! String
                    
                    var user_phone = JSON["telephone"] as! String
                    var user_email = JSON["email"] as! String
                   
              
                    if user_first_name == "null" {user_first_name = ""}
                    if user_last_name == "null" {user_first_name = ""}
                    if user_picture_url == "null" {user_first_name = ""}
                    if user_gender == "null" {user_first_name = ""}
                    if user_birthday == "null" {user_first_name = ""}
                    if user_postalAddressCountry == "null" {user_first_name = ""}
                    if user_postalAddressCity == "null" {user_first_name = ""}
                    
                    if user_postalAddressStreet == "null" {user_first_name = ""}
                    if user_phone == "null" {user_first_name = ""}
                    if user_email == "null" {user_first_name = ""}
                    
                    GlobalVar.StaticVar.user_id = user_id
                    GlobalVar.StaticVar.user_first_name = user_first_name
                    GlobalVar.StaticVar.user_last_name = user_last_name
                    GlobalVar.StaticVar.user_email = user_email
                    GlobalVar.StaticVar.user_phone = user_phone
                    GlobalVar.StaticVar.user_gender = user_gender
                    GlobalVar.StaticVar.user_birthday = user_birthday
                    GlobalVar.StaticVar.user_picture_url = user_picture_url
                    GlobalVar.StaticVar.user_postalAddressCity = user_postalAddressCity
                    GlobalVar.StaticVar.user_address = user_postalAddressStreet
                    GlobalVar.StaticVar.user_postalAddressCountry = user_postalAddressCountry
                    
                 
                    
               
                    
                    
                    
                }
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }
    
    
    
    func MakeGetCategories(access_token:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token
            
        ]
        
        let menu = [NSLocalizedString("Home", comment: "") ,NSLocalizedString("Favoris", comment: "") ,NSLocalizedString("Account", comment: "") ]
        GlobalVar.StaticVar.menuImgArr=[UIImage(named: "UserAccountIcon")!,UIImage(named: "UserAccountIcon")!,UIImage(named: "UserAccountIcon")!]
        
       
        
        
        

        self.StartLoadingSpinner()
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/categorys/menu" + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
               
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as! NSArray? {
                    
                    
                    
                    for element in JSON {
                        if let data = element as? [String: Any] {
                            let idcat = data["_id"] as! Int
                            let label = data ["label"] as! String
                            
                            GlobalVar.StaticVar.catIDArr.append(idcat)
                            GlobalVar.StaticVar.catNameArr.append(label)
                        }

                    }
                     let section1 = SectionData(title: "Afrostream", data: menu)
                    let section2 = SectionData(title: NSLocalizedString("CategoriesMenu", comment: "") , data: GlobalVar.StaticVar.catNameArr)
                    
                    
                GlobalVar.StaticVar.menuSections = [section1,section2]
                    
              
                    /*let label = JSON["label"] as! String
                    let id = JSON["_id"] as! Int
                    GlobalVar.StaticVar.catNameArr.append(label)
                    GlobalVar.StaticVar.catIDArr.append(id)
                    print (label)*/
                    
                    
                    
                    
                    
                    
                    
                }
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }
    
    
    func MakeGetCategoriesHomeMovies(access_token:String)
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
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/categorys/meas" + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                var HomeCatList = [HomeCatMovie]()
                self.StopLoadingSpinner()
                if let JSON = response.result.value as! NSArray? {
                    
                    
                    
                    for element in JSON {
                        if let data = element as? [String: Any] {
                            //let idcat = data["_id"] as! Int
                            let label = data ["label"] as! String
                            
                            let movies = data["movies"] as! NSArray
                            
                            var MoviesList = [MovieModel]()
                            
                            for elementMovie in movies {
                                if let dataMovie = elementMovie as? [String: Any] {
                                    
                                    let movileTitle = dataMovie["title"] as! String
                                    let movileLabel = dataMovie["genre"] as? String
                                    
                                    
                                    let posterMovie = dataMovie ["poster"] as? [String: Any]
                                    
                                    var urlImageMovie = posterMovie?["imgix"] as! String
                                    
                                    urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                                    let mov : MovieModel = MovieModel(title: movileTitle, imageUrl: urlImageMovie, label: "",movieInfo: dataMovie)
                                 

                                    MoviesList.append(mov)
                                    
                                    
                                    
                                    
                                    
                                }
                                
                             
                            }
                            
                            let homeCat : HomeCatMovie = HomeCatMovie(CatTitle: label, Movies: MoviesList )
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
    

    
    func MakeGetSlide(access_token:String)
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
        

        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/categorys" + GlobalVar.StaticVar.ApiUrlParams + "&type=carrousel&populate=adSpots,adSpots.logo,adSpots.poster,adSpots.thumb,adSpots.categorys", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                print (response.result)
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as! NSArray? {
                    
                    let js = JSON[0] as? [String: Any]
                    let jsa = js?["adSpots"] as! NSArray
                    var slides:[Slide] = [Slide]()
                    
                    for element in jsa {
                        if let movie = element as? [String: Any] {
                            
                            let title = movie ["title"] as! String
                            
                            let catArr = movie ["categorys"] as! NSArray
                            let cat = catArr[0] as? [String: Any]
                            let categorie = cat?["label"] as! String
                            
                            let posterMovie = movie ["poster"] as? [String: Any]
                            
                            var urlImageMovie = posterMovie?["imgix"] as! String
                            
                            urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=600&h=400&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)

                            
                            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options:nil)?.first as! Slide
                            
                            slide.lblLabel.text = categorie
                            slide.lblLabel.sizeToFit()
                            slide.movieInfo=movie
                            
                            slide.tag = slides.count
                    
                            
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.SlideClick(sender:)))
                            singleTap.numberOfTapsRequired = 1 // you can change this value
                            slide.isUserInteractionEnabled = true
                            slide.addGestureRecognizer(singleTap)
                            
                            
                            
                            slide.lblTitle.text = title
                            slide.lblTitle.sizeToFit()
                            
                            slide.imgMovie.sd_setImage(with: URL(string: urlImageMovie), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
                            slide.imgMovie.contentMode = .scaleAspectFill
                            
                        
                            slides.append(slide)

                           
                        }
                        
                    }
                    
            
                    self.PageControl.numberOfPages = slides.count
                    self.PageControl.currentPage = 0
                    self.SetupSlidesInScrollView(slides: slides)
                    
                    
                    
                    
                    
                    
                    
                }
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }
    

    func SlideClick (sender: UITapGestureRecognizer)
    {
      let slide = sender.view as! Slide
        print(slidesMain[slide.tag].movieInfo["title"] as! String)
    
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        PageControl.currentPage = Int(pageIndex)
        
    }


        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
