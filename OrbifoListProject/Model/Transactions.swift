//
//  Transactions.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 4.12.2020.
//

import Foundation

enum TransactionType: String, CaseIterableDefaultsLast {
    case QR
    case REFUND
    case TOPUP
    case SETTLEMENT
    case EMPLOYEE_TOPUP
    case CASHBACK
    case UNKNOWN
}

class Transactions: Codable {
    let id: Int
    let amount: Double?
    let type: TransactionType?
    let createdAt: Date?
    let merchant: MerchantSummary?
    let paidBy: String?
    let refNumber: String?
    let paidTo: String?
    let description: TrasnactionDescription?
    let isAddedToSource: Bool?
    let cashbackRate: Double?
}


struct TrasnactionDescription: Codable {
    let isRefunded: Bool?
    let refundTransaction: Transactions?
}

struct MerchantSummary: Codable {
    let logo: String?
    let name: String?
}


enum Status: String, CaseIterableDefaultsLast {
    case success
    case fail
    case uknown
}

class BaseResponse<T: Codable>: Codable {
    let status: Status?
    let message: String?
    let data: T?
}

struct PaginationBaseResponse<T: Codable>: Codable {
    let status: String
    let message: String
    let data: T?
    let limit: Int?
    let total: Int?
    let page: Int?
}



protocol CaseIterableDefaultsLast: Codable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

extension JSONDecoder {
    func isoDateDecoder() -> JSONDecoder {
        self.dateDecodingStrategy = .formatted(.isoDateFormatter)
        return self
    }
}

extension DateFormatter {
    static var isoDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXX" //2020-07-23T12:14:47.162Z
        return formatter
    }

    static var beautifiedDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        return formatter
    }
}


enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

enum ConstantValues: Int {
    case resendCodeTimeInterval = 90
}

enum AnimationTimes: Double {
    case passwordChangeAnimationTime = 0.2
}

enum UserDefaultKeys: String {
    case userToken = "usertoken"
    case fingerPrintEnabled = "fingerPrintEnabled"
}

enum ErrorMessages: String {
    case unknown = "Unknown Error"
}

struct ServerErrorResponse: Codable {
    let status: Status
    let message: String
    let data: ServerError
}

struct ServerError: Codable {
    let statusCode: Int
    let message: String?
}
extension NumberFormatter {
    static var amountNumberFormatter: NumberFormatter {

        let priceFormatter = NumberFormatter()
        priceFormatter.minimumFractionDigits = 0
        priceFormatter.maximumFractionDigits = 2
        priceFormatter.minimumIntegerDigits = 1
        return priceFormatter
    }
}


    // url http://sp-staging.orbifo.com/api/wallets
    
//    var method: HTTPMethod = .get
//
//    var path: String
//    var page: Int
//    var limit: Int
//
//    var parameters: Parameters?
//    var headers: HTTPHeaders? = ["Authorization": "Bearer \(UserService.sharedInstance.getUsertoken() ?? "")"]
//
//    init(page: Int, limit: Int) {
//        self.page = page
//        self.limit = limit
//        self.path = "/transactions?limit=\(limit)&page=\(page)"
//    }
    
    
    
//    aa url request http://sp-staging.orbifo.com/api/transactions?limit=20&page=1
//    aa url Optional(http://sp-staging.orbifo.com/api/wallets)
//    aa header Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzIsImZpcnN0TmFtZSI6ImF5c2UiLCJsYXN0TmFtZSI6ImNlbmdpeiIsInVzZXJuYW1lIjpudWxsLCJpYXQiOjE2MDcwODE0NTUsImV4cCI6MTY0MzA4MTQ1NX0.FUwzz9i2oFOUlg31e9PXqta_uQYtgGmNaQQaZN9y_v0
    
    
//    {"status":"success",
//    "message":"OK",
//    "data":
//    [{
//    "id":163,
//    "type":"QR",
//    "refNumber":"#35814834",
//    "createdAt":"2020-12-04T11:18:47.215Z",
//    "merchant":{"name":"Suadiye Marmaris (Metropol)",
//    "logo":"https://i.ibb.co/PT132GF/MARMARSI-S-LOGO.jpg",
//    "district":"Ataşehir",
//    "category":"CAFE"
//
//    },
//    "isAddedToSource":false,
//    "paidBy":"Personal Wallet",
//    "amount":70,
//    "cashbackRate":25,
//    "cashbackAmount":17.5},
//    {
//    "id":162,"type":"TOPUP","refNumber":"#43497409","createdAt":"2020-12-04T11:18:47.127Z","isAddedToSource":true,"paidBy":"ak bank, AXESS (435508***4358)","amount":70,"cashbackRate":0,"cashbackAmount":0},{"id":161,"type":"QR","refNumber":"#62973068","createdAt":"2020-12-04T11:18:19.358Z","merchant":{"name":"Sudi Restaurant","logo":"https://sudirestoran.com/wp-content/uploads/2019/08/sudi-150x150.png","district":"Ataşehir","category":"CAFE"},"isAddedToSource":false,"paidBy":"Personal Wallet","amount":40,"cashbackRate":25,"cashbackAmount":10},{"id":160,"type":"TOPUP","refNumber":"#27941666","createdAt":"2020-12-04T11:18:19.286Z","isAddedToSource":true,"paidBy":"ak bank, AXESS (435508***4358)","amount":40,"cashbackRate":0,"cashbackAmount":0},{"id":159,"type":"QR","refNumber":"#74247096","createdAt":"2020-12-04T11:17:41.292Z","merchant":{"name":"Suadiye Marmaris (Metropol)","logo":"https://i.ibb.co/PT132GF/MARMARSI-S-LOGO.jpg","district":"Ataşehir","category":"CAFE"},"isAddedToSource":false,"paidBy":"Personal Wallet","amount":150,"cashbackRate":25,"cashbackAmount":37.5},{"id":158,"type":"TOPUP","refNumber":"#39945604","createdAt":"2020-12-04T11:17:41.207Z","isAddedToSource":true,"paidBy":"ak bank, AXESS (435508***4358)","amount":150,"cashbackRate":0,"cashbackAmount":0},{"id":157,"type":"QR","refNumber":"#56286523","createdAt":"2020-12-04T11:17:02.136Z","merchant":{"name":"Sudi Restaurant","logo":"https://sudirestoran.com/wp-content/uploads/2019/08/sudi-150x150.png","district":"Ataşehir","category":"CAFE"},"isAddedToSource":false,"paidBy":"Personal Wallet","amount":50,"cashbackRate":25,"cashbackAmount":12.5},{"id":156,"type":"TOPUP","refNumber":"#60261606","createdAt":"2020-12-04T11:17:01.982Z","isAddedToSource":true,"paidBy":"ak bank, AXESS (435508***4358)","amount":50,"cashbackRate":0,"cashbackAmount":0}
//    ],
//    "total":8,
//    "page":1,
//    "limit":20,
//    "links":
//    {
//    "current":"http://sp-staging.orbifo.com/api/transactions?limit=20&page=1?",
//    "last":"http://sp-staging.orbifo.com/api/transactions?limit=20&page=1?",
//    "first":"http://sp-staging.orbifo.com/api/transactions?limit=20&page=1?"
//
//    }}
//
//

