//
//  TransactionCell.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 4.12.2020.
//

import Foundation
import UIKit

class TransactionCell: UITableViewCell
{
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var Title: UILabel!
    
    
    var transaction: Transactions? {
        didSet {
            if transaction?.type == TransactionType.TOPUP {
                logo.contentMode = .center
                logo.image = UIImage(named: "personalWalletMedium")
                logo.backgroundColor = .yellow
                
                Title?.text = "Top-up Personal Wallet"
            } else if transaction?.type == TransactionType.EMPLOYEE_TOPUP {
                logo.contentMode = .center
                logo.image = UIImage(named: "companyWalletMedium")
                logo.backgroundColor = .yellow
                Title?.text = "Top-up Company Wallet"
            } else if transaction?.type == .CASHBACK {
                logo.contentMode = .center
                logo.image = UIImage(named: "notifCashback")
                logo.backgroundColor = UIColor.white
                Title?.text = "Cashback"
            } else {
                logo.contentMode = .center
                logo.image = UIImage(named: "smallimageplaceholder")
                if let imageUrl = transaction?.merchant?.logo {
                    logo.contentMode = .scaleAspectFill
               
                }
                logo.backgroundColor = UIColor.green
                Title?.text = transaction?.merchant?.name ?? "Unknown Merchant"
            }

            if !(transaction?.isAddedToSource ?? false) {
                price?.text = "- \(NumberFormatter.amountNumberFormatter.string(from: NSNumber(value: transaction?.amount ?? 0)) ?? "0") TL"
                price.textColor = UIColor.gray
            } else {
                price?.text = "+ \(NumberFormatter.amountNumberFormatter.string(from: NSNumber(value: transaction?.amount ?? 0)) ?? "0") TL"
                price.textColor = UIColor.red
            }

            date?.text = DateFormatter.beautifiedDateFormatter.string(from: transaction?.createdAt ?? Date())
        }
    }
}
