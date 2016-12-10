//
//  NotificationHandler
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

protocol MessageHandler {
    func process(data: Dictionary<String, NSObject>)
}
