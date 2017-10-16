//
//  Date+LFExtension.swift
//  WeiBo
//
//  Created by 刘丰 on 2017/9/25.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import Foundation

extension Date {
    
    /// 从秒数转成媒体式字符串
    ///
    /// - Parameter timeInterval: 描述
    /// - Returns: 媒体式字符串
    public static func mediaString(second timeInterval: TimeInterval) -> String {
        
        if timeInterval <= 0 {
            return "00:00"
        }
        
        let second = round(timeInterval) //四舍五入
        let dateFormatter = DateFormatter()
        if second < 60*60 {//1小时以内
            dateFormatter.dateFormat = "mm:ss"
        }else if second < 60*60*24 {//24小时以内
            dateFormatter.dateFormat = "HH:mm:ss"
        }else {//大于一天
            return "23:59:59";
        }
        
        let date = Date(timeIntervalSince1970: second)
        return dateFormatter.string(from: date)
    }
    
    public static func second(with mediaString: String) -> TimeInterval {
        
        if mediaString == "" {
            return 0
        }
        
        let hms = mediaString.components(separatedBy: ":")
        if hms.count == 3 {
            let h = TimeInterval(hms[0]) ?? 0
            let m = TimeInterval(hms[1]) ?? 0
            let s = TimeInterval(hms[2]) ?? 0
            return h*60*60 + m*60 + s
        }else if hms.count == 2 {
            let m = TimeInterval(hms[0]) ?? 0
            let s = TimeInterval(hms[1]) ?? 0
            return m*60 + s
        }else {
            return 0
        }
    }
}
