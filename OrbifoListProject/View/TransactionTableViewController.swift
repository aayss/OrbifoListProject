//
//  TransactionTableViewController.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 4.12.2020.
//

import Foundation
import UIKit
import Alamofire
import AVFoundation
import OneSignal

class TransactionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var transactionVM = TransactionViewModel()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    
    private var pagination: Pagination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        // Push Status Methods
        let hasPrompted = status.permissionStatus.hasPrompted
        print("hasPrompted: ", hasPrompted)
        let userStatus = status.permissionStatus.status
        print("userStatus: ", userStatus)
        let isSubscribed = status.subscriptionStatus.subscribed
        print("isSubscribed: ", isSubscribed)
        let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
        print("userSubscriptionSetting: ", userSubscriptionSetting)
        if let userID = status.subscriptionStatus.userId{
            print("userID: ", userID)
        }
        if let pushToken = status.subscriptionStatus.pushToken {
            print("pushToken: ", pushToken)
        }
        // Email Status Methods
        if let emailPlayerId = status.emailSubscriptionStatus.emailUserId {
            print("emailPlayerId: ", emailPlayerId)
        }
        if let emailAddress = status.emailSubscriptionStatus.emailAddress {
            print("emailAddress: ", emailAddress)
        }
        let isEmailSubscribed = status.emailSubscriptionStatus.subscribed
        print("isEmailSubscribed: ", isEmailSubscribed)
        
//        if hasPrompted == true
//        {
//            self.performSegue(withIdentifier: "denemeSegue", sender: nil)
//        }

        
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        transactionVM.fetchTransactions(eraseData: false)
  
        transactionVM.updateTransactionList = { [weak self] in
            if self?.refreshControl.isRefreshing ?? false {
                self?.refreshControl.endRefreshing()
            }
            self?.tableView.reloadData()
        }
       
    }
  
    
    @objc func refresh(_ sender: AnyObject) {
       
       transactionVM.fetchTransactions(eraseData: true)
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionVM.itemsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCELL", for: indexPath) as? TransactionCell else {
            fatalError("TransactionCell not found!")
        }

        if let transaction = transactionVM.itemAt(indexPath: indexPath) {
            cell.transaction = transaction

        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        transactionVM.checkAndReloadIfNeeded(for: indexPath)
    }
 
}


protocol Routable: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }

    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }

    func asURLRequest() throws -> URLRequest
}

extension Routable {
    func asURLRequest() throws -> URLRequest {
        var url: URL = URL(string: "http://sp-staging.orbifo.com/api/transactions?limit=20&page=1")!
        if path.contains("https") {
            url = try "\(path)".asURL()
        }
        var urlRequest = URLRequest(url: url)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Custom Headers
        if let headers = headers {
            urlRequest.headers = headers
            var defaultLang = "en"

           
            urlRequest.headers.add(HTTPHeader(name: "Accept-Language", value: defaultLang))
        }
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
}

class GetTransactionsRouter: Routable {
    var method: HTTPMethod = .get

    var path: String
    var page: Int
    var limit: Int

    var parameters: Parameters?
    var headers: HTTPHeaders? = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzIsImZpcnN0TmFtZSI6ImF5c2UiLCJsYXN0TmFtZSI6ImNlbmdpeiIsInVzZXJuYW1lIjpudWxsLCJpYXQiOjE2MDcwODE0NTUsImV4cCI6MTY0MzA4MTQ1NX0.FUwzz9i2oFOUlg31e9PXqta_uQYtgGmNaQQaZN9y_v0"]

    init(page: Int, limit: Int) {
        self.page = page
        self.limit = limit
        self.path = "/transactions?limit=\(limit)&page=\(page)"
    }
}
