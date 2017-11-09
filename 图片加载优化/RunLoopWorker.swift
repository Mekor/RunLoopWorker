//
//  RunLoopWorker.swift
//  图片加载优化
//
//  Created by Mekor on 2017/11/9.
//  Copyright © 2017年 Honghuotai. All rights reserved.
//

import Foundation

class RunLoopWorker {
    
    typealias RunloopBlock = (()-> Bool)
    
    static let shared = RunLoopWorker()
    
    var maxQueueLength: Int
    var tasks = [[IndexPath:RunloopBlock]]()
    private var timer: Timer
    private init() {
        
        maxQueueLength = 40
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in })
        addRunloopObserver()
    }
    
    func add(task unit: @escaping RunloopBlock, with key: IndexPath){
        self.tasks.append([key: unit])
        if self.tasks.count > maxQueueLength {
            self.tasks.removeFirst()
        }
    }
}

extension RunLoopWorker{
    func addRunloopObserver() {
        autoreleasepool {
            guard let runloop = CFRunLoopGetCurrent() else {return}
            let unmanaged = Unmanaged.passRetained(self)
            let uptr = unmanaged.toOpaque()
            let vptr = UnsafeMutableRawPointer(uptr)
            var content = CFRunLoopObserverContext(version: 0, info: vptr, retain: nil, release: nil, copyDescription: nil)
            guard let obserber = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, Int.max - 999, observerCallbackFunc(), &content) else {return}
            CFRunLoopAddObserver(runloop, obserber, CFRunLoopMode.defaultMode)
        }
    }
    
    
    func observerCallbackFunc() -> CFRunLoopObserverCallBack {
        
        return {(observer, activity, context) -> Void in
            guard let context = context else {
                return
            }
            let work = Unmanaged<RunLoopWorker>.fromOpaque(context).takeUnretainedValue()
            
            if work.tasks.count == 0 { return }
            var result = false
            while result == false && work.tasks.count > 0 {
                // 取出任务
                if let unit = work.tasks.first,unit.values.count > 0 {
                    result = unit.values.first!()
                    work.tasks.removeFirst()
                }
            }
        }
    }
}
