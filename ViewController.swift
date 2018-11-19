//
//  ViewController.swift
//  WeatherFeedBase
//
//  Created by Mateo Olaya Bernal on 3/4/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let utils = Utils.sharedInstance
    var cities: [City] = [City]()
    var backgorunds: [UIImage] = [UIImage]()
    var lastXPosition = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.numberOfPages = cities.count
        self.configGesture()
        self.addNotifications()
        
        loadWeather("argentina")
        loadWeather("cordoba")
        loadWeather("tancacha")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Configuration
    
    func addNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onPlaceDeleted(_:)), name: "deletedPlace", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onPlaceAdded(_:)), name: "addedPlace", object: nil)
    }
    
    func addView(city: String, country: String, today: ForecastData, weathers: [Day]) -> WeatherView {
        let weatherView = NSBundle.mainBundle().loadNibNamed("WeatherViewXib", owner: nil, options: nil).first! as! WeatherView
        
        weatherView.cityLabel.text = city
        weatherView.backgroundImage.image = today.background
        weatherView.degreesLabel.text = "\(Int(today.maximumTemperature))°c"
        weatherView.countrylabel.text = country
        weatherView.weathers.appendContentsOf(weathers)
        weatherView.frame = self.view.frame
        
        return weatherView
    }
    
    func loadWeather(location: String) {
        utils.createLocation(location) { (place, image) in
            dispatch_async(dispatch_get_main_queue()) {
                self.backgorunds.append(image)
                self.cities.append(place)
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.cities.count
            }
        }
    }
    
    // MARK: ActionsListeners
    
    func onPlaceDeleted(notification: NSNotification) {
        let row = notification.object as! Int

        self.cities.removeAtIndex(row)
        self.backgorunds.removeAtIndex(row)
        self.collectionView.reloadData()
        self.pageControl.numberOfPages = self.cities.count
    }
    
    func onPlaceAdded(notification: NSNotification) {
        let data = notification.object as! [AnyObject]
        let place = data[0] as! City
        let image = data[1] as! UIImage
        
        self.backgorunds.append(image)
        self.cities.append(place)
        self.collectionView.reloadData()
        self.pageControl.numberOfPages = self.cities.count
    }
    
    // MARK: Gestures Recognizer
    
    func configGesture() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        recognizer.delegate = self
        self.collectionView.addGestureRecognizer(recognizer)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let width = collectionView.frame.size.width
        let currentPage = self.pageControl.currentPage
        
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self.collectionView)
            lastXPosition = translation.x
            self.collectionView.contentOffset = CGPoint(x: (CGFloat(currentPage * Int(width)) - translation.x), y: 0)
        }
        
        if recognizer.state == .Ended {
            if width + lastXPosition < width / 2 {
                collectionView.setContentOffset(CGPoint(x: ((currentPage + 1) * Int(width)), y: 0), animated: true)
                self.pageControl.currentPage += 1
                
            } else if width - lastXPosition < width / 2 {
                collectionView.setContentOffset(CGPoint(x: ((currentPage - 1) * Int(width)), y: 0), animated: true)
                self.pageControl.currentPage -= 1
                
            } else {
                collectionView.setContentOffset(CGPoint(x: (currentPage * Int(width)), y: 0), animated: true)
            }
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let width = collectionView.frame.size.width
        
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let translation = panGestureRecognizer.translationInView(self.collectionView)
        
        if self.pageControl.currentPage == 0 && translation.x > 0 {
            return false
        }
        
        let numOfPages = self.pageControl.numberOfPages
        let maxWidth = Int(width) * numOfPages
        
        if numOfPages == self.pageControl.currentPage + 1 && maxWidth - Int(translation.x) > maxWidth {
            return false
        }
        
        return true
    }
    
    // MARK: CollectionView Configuration
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as UICollectionViewCell
        let currentPlace = self.cities[indexPath.row]
        let newView = addView(currentPlace.name, country: currentPlace.country, today: currentPlace.today, weathers: currentPlace.weathers)
        cell.addSubview(newView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    // MARK: Page Control

    @IBAction func moveView(sender: UIPageControl) {
        let width = collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x: (sender.currentPage * Int(width)), y: 0), animated: true)
    }
    
    // MARK: Segues
    
    
    @IBAction func unwindForSegue(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "locationsSegue" {
            let nextVc = segue.destinationViewController as! WeatherViewController
            nextVc.image = backgorunds[self.pageControl.currentPage]
            nextVc.cities.appendContentsOf(self.cities)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

