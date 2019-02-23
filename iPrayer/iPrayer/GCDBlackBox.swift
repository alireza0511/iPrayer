//
//  GCDBlackBox.swift
//  iPrayer
//
//  Created by Al Khaki on 2/18/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
