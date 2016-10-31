//
//  RootViewController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate, ProtocolChangePage, UIScrollViewDelegate  {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var backgroundImageViews = [UIImageView]()
    var pageViewController: UIPageViewController?
    var currentPage = 0
    var nextPage = -1
    var didSetPage = false
    var lastContentOffsetX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        self.pageViewController!.dataSource = self.modelController
        self.addChildViewController(self.pageViewController!)
        self.view.insertSubview(self.pageViewController!.view, at: 2)
        
        pageControl.currentPage = 0
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMove(toParentViewController: self)
        
        for v in self.pageViewController!.view.subviews{
            if let vv = v as? UIScrollView {
                vv.delegate = self
            }
        }

        for i in 0..<modelController.imageNames.count {
            let imv = UIImageView(frame: view.frame)
            if i == 0 {
                imv.image = UIImage(named:modelController.imageNames[0])
            } else {
                imv.alpha = 0
            }
            imv.contentMode = .scaleAspectFill
            view.insertSubview(imv, at: 0)
            backgroundImageViews.append(imv)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SFAnalytics.addScreenTracking(screenName:"Intro")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        btnLogin.layer.borderWidth = 0.5
        btnLogin.layer.borderColor = SFColor.orange.cgColor
    }
    
    func setTotalNumberOfPages(number: Int) {
        pageControl.numberOfPages = number
    }
    
    func setPage(indexPage: Int) {
        pageControl.currentPage = indexPage
    }

    var modelController: ModelController {
        if _modelController == nil {
            _modelController = ModelController(delegate: self)
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

            self.pageViewController!.isDoubleSided = false
            return .min
        }
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        
        return .mid
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let dataVC = pendingViewControllers.first as? DataViewController {
            let index = modelController.indexOfViewController(dataVC)
            nextPage = index
            if nextPage < 0 {
                nextPage = 0
            }
            if nextPage > modelController.imageNames.count - 1 {
                nextPage = modelController.imageNames.count - 1
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x1 = scrollView.contentOffset.x - ScreenSize.SCREEN_WIDTH
        let alphaFactor = x1/ScreenSize.SCREEN_WIDTH
        if nextPage != -1 {
            if lastContentOffsetX.truncatingRemainder(dividingBy:scrollView.contentOffset.x) == 0 {
                currentPage = nextPage
            }
            if didSetPage == false || currentPage != nextPage {
                if nextPage < currentPage {
                    currentPage = nextPage + 1
                    if currentPage < 0 { currentPage = 0 }
                    if currentPage > modelController.imageNames.count - 1 { currentPage = modelController.imageNames.count - 1 }
                    if currentPage != 0 {
                        backgroundImageViews[currentPage].alpha = 1+alphaFactor
                        backgroundImageViews[nextPage].alpha = -alphaFactor
                    } else {
                        backgroundImageViews[currentPage].alpha = 1-alphaFactor
                    }
                } else {
                    currentPage = nextPage - 1
                    if currentPage > modelController.imageNames.count - 1 { currentPage = modelController.imageNames.count - 1 }
                    if currentPage < 0 { currentPage = 0 }
                    if currentPage < modelController.imageNames.count - 1 {
                        backgroundImageViews[currentPage].alpha = 1-alphaFactor
                        backgroundImageViews[nextPage].alpha = alphaFactor
                    } else {
                        backgroundImageViews[currentPage].alpha = 1+alphaFactor
                    }
                }
                
                backgroundImageViews[currentPage].image = UIImage(named:modelController.imageNames[currentPage])
                backgroundImageViews[nextPage].image = UIImage(named:modelController.imageNames[nextPage])
                
                for imv in backgroundImageViews {
                    if imv != backgroundImageViews[currentPage] && imv != backgroundImageViews[nextPage] {
                        imv.alpha = 0
                    }
                }
            } else {
//                if let dataVC = pageViewController?.viewControllers?.first as? DataViewController {
//                    if dataVC.stTutorial != modelController.stTutorial[currentPage] {
//                        currentPage = pageControl.currentPage - 1
//    //                    nextPage = currentPage
//                    }
//                }
            }
            didSetPage = true
            lastContentOffsetX = scrollView.contentOffset.x
        } else {
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}










