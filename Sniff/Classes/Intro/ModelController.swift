//
//  ModelController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

protocol ProtocolChangePage {
    func setPage(indexPage: Int)
    func setTotalNumberOfPages(number: Int)
}

class ModelController: NSObject, UIPageViewControllerDataSource {

    var imageNames: [String] = []
    
    var stTutorial: [String] = ["Start sniffing out your interests","Start sniffing out your interests2","Start sniffing out your interests3",
                                "Start sniffing out your interests4","Start sniffing out your interests5"]
    var delegate: ProtocolChangePage?
    
    override init() {
        super.init()
    }
    
    init(delegate: ProtocolChangePage) {
        super.init()
        //set the right images for the current device
        imageNames = ["login_page1","login_page2","login_page3","login_page4","login_page5"];
        if DeviceType.IS_IPHONE_6P_7P {
            imageNames = ["login_page1","login_page2","login_page3","login_page4","login_page5"];
        } else if DeviceType.IS_IPHONE_5 {
            imageNames = ["login_page1","login_page2","login_page3","login_page4","login_page5"];
        } else if DeviceType.IS_IPHONE_4_OR_LESS {
            imageNames = ["login_page1","login_page2","login_page3","login_page4","login_page5"];
        }
        
        //set the delegate and the number of total pages
        self.delegate = delegate
        self.delegate!.setTotalNumberOfPages(number: imageNames.count)
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (self.imageNames.count == 0) || (index >= self.imageNames.count) {
            return nil
        }
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.stTutorial = self.stTutorial[index]
        dataViewController.view.bringSubview(toFront: dataViewController.lbTutorial)
        return dataViewController
    }

    func indexOfViewController(_ viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        for i in 0..<imageNames.count {
            if viewController.stTutorial == stTutorial[i] {
                if let delegate = delegate {
                    delegate.setPage(indexPage: i)
                }
                return i
            }
        }
        return NSNotFound
    }

    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) { return nil }
    
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound { return nil }
    
        index += 1
        if index == self.imageNames.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
}

