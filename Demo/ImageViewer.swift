//
//  ImageViewer.swift
//  Demo
//
//  Created by 秦伟 on 2018/5/23.
//  Copyright © 2018 秦伟. All rights reserved.
//

import UIKit

class QWImagePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var dataArray: [Item] = Array()
    var currentPage: Int = 0
    var allViewControllers: [QWImageViewer] = Array()
    let indexLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for data in dataArray {
            let vc = QWImageViewer()
            vc.item = data
            allViewControllers.append(vc)
        }
        
        setViewControllers([allViewControllers[currentPage]], direction: .forward, animated: true, completion: nil)
        indexLabel.text = "\(currentPage+1)" + " / " + "\(dataArray.count)"
        indexLabel.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - 100) / 2, y: 40, width: 100, height: 80)
        indexLabel.font = UIFont.systemFont(ofSize: 17)
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.white
        view.addSubview(indexLabel)
        
        dataSource = self
        delegate = self
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! QWImageViewer
        if vc == allViewControllers.first {
            return nil
        }
        currentPage -= 1
        let index = allViewControllers.index(of: vc)! - 1
        return allViewControllers[index]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! QWImageViewer
        if vc == allViewControllers.last {
            return nil
        }
        currentPage += 1
        let index = allViewControllers.index(of: vc)! + 1
        return allViewControllers[index]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let nextVC = pendingViewControllers.first
        let index = allViewControllers.index(of: nextVC as! QWImageViewer)
        currentPage = index!
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        indexLabel.text = "\(currentPage+1)" + " / " + "\(dataArray.count)"
    }
    
}

class QWImageViewer: UIViewController, UIScrollViewDelegate {
    
    var item: Item!
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var infoView: UIView!
    var titleLabel: UILabel!
    var descriptorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(goBack)))
        scrollView.frame = self.view.bounds
        view.addSubview(scrollView)
        imageView.kf.setImage(with: URL(string: item.enclosureUrl), placeholder: nil, options: nil, progressBlock: nil) { [weak self](img, error, type, url) in
            if let webImg = img {
                self?.imageView.image = webImg
            }
        }
        imageView.frame = self.view.bounds
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        scrollView.contentSize = self.imageView.bounds.size
        scrollView.delegate = self
        scrollView.maximumZoomScale = 10.0
        scrollView.minimumZoomScale = 1
        
        infoView = UIView.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200))
        infoView.backgroundColor = UIColor.init(white: 0.4, alpha: 0.25)
        view.addSubview(infoView)
        titleLabel = UILabel.init(frame: CGRect.init(x: 4, y: 0, width: infoView.bounds.size.width - 8, height: 50))
        titleLabel.text = item.title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        titleLabel.numberOfLines = 2
        infoView.addSubview(titleLabel)
        descriptorLabel = UILabel.init(frame: CGRect.init(x: 4, y: 50, width: infoView.bounds.size.width - 8, height: infoView.bounds.size.height - 50))
        descriptorLabel.text = item.description
        descriptorLabel.textColor = UIColor.white
        descriptorLabel.font = UIFont.systemFont(ofSize: 14.0)
        descriptorLabel.numberOfLines = 0
        infoView.addSubview(descriptorLabel)
    }
    
    @objc func goBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
