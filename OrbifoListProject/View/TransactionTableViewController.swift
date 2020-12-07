//
//  TransactionTableViewController.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 4.12.2020.
//

import Foundation
import UIKit
import Alamofire


class TransactionTableViewController: UITableViewController {
    
    var transactionVM = TransactionViewModel()
    private var pagination: Pagination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionVM.fetchTransactions(eraseData: false)
  
        transactionVM.updateTransactionList = { [weak self] in
            
            self?.tableView.reloadData()
        }
       
    }
  

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionVM.itemsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCELL", for: indexPath) as? TransactionCell else {
            fatalError("TransactionCell not found!")
        }
        
       // let transactionViewModel = transactionVM.itemAt(indexPath: indexPath)
        
        if let transaction = transactionVM.itemAt(indexPath: indexPath) {
            cell.transaction = transaction
           // cell.Title.text = transaction.merchant?.name
            
        }
        
        return cell
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
