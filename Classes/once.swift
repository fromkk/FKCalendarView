//
//  once.swift
//  FKCalendarView
//
//  Created by Kazuya Ueoka on 2016/05/27.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

private final class _OnceQueue
{
    private var queue: [AnyObject] = []
    private static let sharedInstance: _OnceQueue = _OnceQueue()
    private func add(once: AnyObject) -> _OnceQueue
    {
        if !self.has(once)
        {
            self.queue.append(once)
        }
        return self
    }
    private func has(once: AnyObject) -> Bool
    {
        return self.queue.contains({ (item) -> Bool in
            return once.isEqual(item)
        })
    }
    private func remove(once: AnyObject) -> _OnceQueue
    {
        let index: Int? = self.queue.indexOf {
            return once.isEqual($0)
        }
        if let index = index
        {
            self.queue.removeAtIndex(index)
            return self
        } else {
            return self
        }
    }
    private func clear() -> _OnceQueue
    {
        self.queue.removeAll()
        return self
    }
}

public protocol Once : class {}

public extension Once
{
    typealias OnceCompletion = () -> Void
    func once(@noescape completion: OnceCompletion) -> Void {
        if !_OnceQueue.sharedInstance.has(Self)
        {
            _OnceQueue.sharedInstance.add(Self)
            completion()
        }
    }
}