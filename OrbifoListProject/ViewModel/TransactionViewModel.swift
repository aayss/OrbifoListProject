//
//  TransactionViewModel.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 4.12.2020.
//

import Foundation
import Alamofire

class TransactionViewModel
{
    private var transaction = [Transactions]()
    private var pagination: Pagination?
    
    var updateTransactionList: (() -> Void)?
    
    func itemAt(indexPath: IndexPath) -> Transactions? {
        if transaction.count > indexPath.row {
            return transaction[indexPath.row]
        }
        return nil
    }
  
    func itemsCount() -> Int
    {
        return transaction.count
    }
    
    func addTransactionViewModel(_ vm: Transactions) {
       self.transaction.append(vm)
   }
    
 
   
    func fetchTransactions(eraseData: Bool) {
       
    
        let page = ((pagination != nil) ? pagination?.page : 1)!

        getTransactions(page: page, limit: pagination?.limit ?? 20) { [weak self] (result, _) in
          
            switch result {
            case .success(let response):
                if let data = response.data {

                    self?.pagination = Pagination(limit: response.limit ?? 20, total: response.total ?? 10000, page: response.page ?? 1)
                    self?.transaction.append(contentsOf: data)
                    self?.updateTransactionList?()
                }

            case .failure:
                print("Failed to get transactions")
            }
            
        }
        
        
    }

    func getTransactions(page: Int, limit: Int, completion: @escaping (AFResult<PaginationBaseResponse<[Transactions]>>, ServerErrorResponse?) -> Void) {
        performRequest(route: GetTransactionsRouter(page: page, limit: limit), completion: completion)
    }
    
    let queue = DispatchQueue(label: "com.sigma.apithread", qos: .userInitiated, attributes: .concurrent)

    private  func performRequest<T: Decodable>(route: Routable, decoder: JSONDecoder = JSONDecoder().isoDateDecoder(), completion:@escaping (AFResult<T>, ServerErrorResponse?) -> Void) {
        print("===========>>>>>>>>> Service : ", route.urlRequest?.url ?? "", ":::", route.parameters as Any, route.headers as Any)
        AF.request(route)
            .responseDecodable(queue: queue, decoder: decoder) { (response: DataResponse<T, AFError>) in
                var responseError: ServerErrorResponse?
                //expr print(variable)
                print("===========>>>>>>>>>", String(decoding: response.data ?? Data(), as: UTF8.self))
                switch response.result {
                case .failure:
                    print("EEEERRRRROOOORRRRR", response.result)

                    if let data = response.data {
                        responseError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data)
                    }
                    switch responseError?.data.statusCode {
                    case 403:
                        print("forbidden") //Any additional error handling goes here
                        DispatchQueue.main.async {
                            completion(response.result, responseError)
                        }
                        return
                    case 401:
                        print("Not found") //Any additional error handling goes here
                      //  AppUtility.handleUnauthenticateUser()
                        return
                    default:
                        DispatchQueue.main.async {
                            completion(response.result, responseError)
                        }
                    }

                case .success:
                    DispatchQueue.main.async {
                        completion(response.result, responseError)
                    }
                }
        }
    }

}
