//
//  User.swift
//  InstaClone
//
//  Created by Relorie on 6/12/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit

final class CurrentUser  {
    static var sharedInstance = User()
    private init () { }
}
