//
//  SwipingPhotosController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/10.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import SDWebImage

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    var cardViewModel: CardViewModel! {
        didSet {
            cardViewModel.imageUrls
            controllers = cardViewModel.imageUrls.map({ url -> UIViewController in
                return PhotoController(imageUrl: url)
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
        }
    }
    
    var controllers = [UIViewController]()
    
//    let controllers = [
//        PhotoController(image: #imageLiteral(resourceName: "dismiss_circle")),
//        PhotoController(image: #imageLiteral(resourceName: "super_like_circle")),
//        PhotoController(image: #imageLiteral(resourceName: "like_circle")),
//        PhotoController(image: #imageLiteral(resourceName: "info_icon")),
//        PhotoController(image: #imageLiteral(resourceName: "boost_circle"))
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dataSource = self
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0  {return nil}
        return controllers[index - 1]
    }
}

class PhotoController: UIViewController {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "jane3"))

    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
