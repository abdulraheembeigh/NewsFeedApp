//
//  TaskStorage.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import Foundation
import UIKit
// MARK: - Thread-safe task storage 
final class TaskStorage: @unchecked Sendable {
    private let lock = NSLock()
    private var task: Task<Void, Never>?
    
    func store(_ task: Task<Void, Never>) {
        lock.withLock {
            self.task = task
        }
    }
    
    func cancel() {
        lock.withLock {
            task?.cancel()
            task = nil
        }
    }
    
    deinit {
        cancel()
    }
}

