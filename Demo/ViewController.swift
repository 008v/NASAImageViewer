//
//  ViewController.swift
//  Demo
//
//  Created by 秦伟 on 2018/5/22.
//  Copyright © 2018 秦伟. All rights reserved.
//

import UIKit
import Kingfisher

public struct Item {
    var title: String
    var link: String
    var description: String
    var enclosureUrl: String
    var pubDate: String
}

class ViewController: UIViewController {
    
    var tableView: UITableView!
    var xmlParser: XMLParser!
    var isItem: Bool!
    var currentElementValue: String!
    var currentTitle: String!
    var currentLink: String!
    var currentDescription: String!
    var currentEnclosureUrl: String!
    var currentPubDate: String!
    var itemList: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupXmlParser()
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }
    
    func setupXmlParser() {
        xmlParser = XMLParser.init(contentsOf: URL(string: "https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss")!)
        xmlParser.delegate = self
        xmlParser.parse()
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        let leftIndex = indexPath.row * 2
        cell.leftImgView.kf.setImage(with: URL.init(string: itemList[leftIndex].enclosureUrl), placeholder: UIImage(named: "placeHolder"), options: [KingfisherOptionsInfoItem.backgroundDecode], progressBlock: nil, completionHandler: nil)
        let rightIndex = indexPath.row * 2 + 1
        if rightIndex <= itemList.count - 1 {
            cell.rightImgView.kf.setImage(with: URL.init(string: itemList[rightIndex].enclosureUrl), placeholder: UIImage(named: "placeHolder"), options: [KingfisherOptionsInfoItem.backgroundDecode], progressBlock: nil, completionHandler: nil)
        }else {
            cell.rightImgView.image = nil
        }
        cell.clickCallback = { (isLeft) in
            let pageVC = QWImagePageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageVC.dataArray = self.itemList
            if isLeft {
                pageVC.currentPage = indexPath.row * 2
            }else {
                pageVC.currentPage = indexPath.row * 2 + 1
            }
            self.present(pageVC, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            isItem = true
        }
        if elementName == "enclosure" {
            currentEnclosureUrl = attributeDict["url"]
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if isItem == true {
            if elementName == "title" {
                currentTitle = currentElementValue
            }else if elementName == "link" {
                currentLink = currentElementValue
            }else if elementName == "description" {
                currentDescription = currentElementValue
            }else if elementName == "pubDate" {
                currentPubDate = currentElementValue
            }
            if elementName == "item" {
                let item = Item.init(title: currentTitle, link: currentLink, description: currentDescription, enclosureUrl: currentEnclosureUrl, pubDate: currentPubDate)
                itemList.append(item)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElementValue = string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("解析错误")
    }
}

