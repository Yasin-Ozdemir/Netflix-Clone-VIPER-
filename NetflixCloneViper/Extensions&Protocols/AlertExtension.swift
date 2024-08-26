//
//  AlertExtension.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation
import UIKit

extension UIViewController{
    func presentAlert(title: String , message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
       
    }
    
}
