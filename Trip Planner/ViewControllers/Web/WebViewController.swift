//
//  WebViewController.swift
//  Trip Planner
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 22/3/18.
//  Copyright © 2018 Kohbroco. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    public static let singleton = WebViewController(nibName: "WebViewController", bundle: Bundle.main)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "WebViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("WebViewController", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("no implementation")
    }
    
    public func LoadPage(urlString : String)
    {
        let url = URL(string : urlString)!
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
    }
}
