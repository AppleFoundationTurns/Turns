//
//  Router.swift
//  Turn
//
//  Created by dave on 08/07/24.
//

import Foundation
import SwiftUI

@Observable
class Router {
    var navigationPath = NavigationPath()

    func navigateTo(route: Route) {
        navigationPath.append(route)
    }
}
