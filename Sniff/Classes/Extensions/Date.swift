//
//  NSDateExtension.swift
//  Line-Up-Promoter
//
//  Created by Andrea Ferrando on 09/11/2015.
//  Copyright © 2015 Line-Up. All rights reserved.
//

import Foundation

extension Date {
    
    func formatMessage() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEEEEE"
        var dateNameString : String = dateFormatter.string(from: self)
        dateNameString = dateNameString.lowercased()
        
        dateFormatter.dateFormat = "h:mm a"
        let timeString : String = dateFormatter.string(from: self)

        return String(format: "%@ %@", dateNameString,timeString)
    }
    
    func formatWithSuffix() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM"
        let monthString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "d"
        let dayString : String = dateFormatter.string(from: self)
        
        let suffix : String = daySuffix()
        
        dateFormatter.dateFormat = "yyyy"
        let yearString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "h:mm a"
        let timeString : String = dateFormatter.string(from: self)
        
        var dateString : String = ""
        
        if timeString == "00:00" {
            dateString = String(format: "%@ %@%@ %@", monthString,dayString,suffix,yearString)
        } else {
            dateString = String(format: "%@ %@%@ %@, %@", monthString,dayString,suffix,yearString,timeString)
        }
        
        return dateString
    }
    
    func formatWithoutTime() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        let monthString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "dd"
        let dayString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "yyyy"
        let yearString : String = dateFormatter.string(from: self)
        
        return String(format: "%@-%@-%@", yearString,monthString,dayString)
    }
    
    
    func formatDayMonth() -> String{
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        let monthString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "dd"
        let dayString : String = dateFormatter.string(from: self)
        
        
        return String(format: "%@/%@",dayString,monthString)
    }
    
    
    func formatDateAndTime() -> String{
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        let monthString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "dd"
        let dayString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "yyyy"
        let yearString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "h:mm aa"
        var timeString : String = dateFormatter.string(from: self)
        if timeString.characters.count > 2 && timeString.characters.first == "0" && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 1)] != "0" {
            timeString = timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 1))
        } else if timeString.characters.count >= 4 && timeString.characters.first == "0" && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 1)] == "0"
            && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 2)] == "0" && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 3)] == "0" {
            timeString = ""
        }
        timeString = timeString.lowercased()
        
        
        return String(format: "%@/%@/%@ %@", dayString,monthString,yearString,timeString)
    }
    
    
    func formatDateTTime() -> String{
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        let monthString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "dd"
        let dayString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "yyyy"
        let yearString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "hh:mm:ss"
        let timeString : String = dateFormatter.string(from: self)
        
        let returnString = String(format: "%@-%@-%@T%@",yearString,monthString,dayString,timeString)
        
        return returnString.replacingOccurrences(of: ":", with: "%3A")
    }
    
    func formatMessageId() -> String{
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        let monthString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "dd"
        let dayString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "yyyy"
        let yearString : String = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "hh:mm:ss"
        let timeString : String = dateFormatter.string(from: self)
        
        let returnString = String(format: "%@%@%@%@",dayString,monthString,yearString,timeString)
        
        return returnString.replacingOccurrences(of: ":", with: "")
    }
    
    
    func formatStartTime() -> String{
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        var timeString : String = dateFormatter.string(from: self)
        if timeString.characters.count > 2 && timeString.characters.first == "0" && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 1)] != "0" {
            timeString = timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 1))
        }else if timeString.characters.count >= 5 && timeString.characters.first == "0" && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 1)] == "0"
            && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 3)] == "0" && timeString[timeString.characters.index(timeString.startIndex, offsetBy: 4)] == "0" {
            timeString = "00:00"
        }
        timeString = timeString.lowercased()
        
        if timeString != "00:00" {
            switch (timeString.substring(to: timeString.characters.index(timeString.startIndex, offsetBy: 2)))
            {
            case "12":
                timeString = String(format:"12:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "13":
                timeString = String(format:"1:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "14":
                timeString = String(format:"2:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "15":
                timeString = String(format:"3:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "16":
                timeString = String(format:"4:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "17":
                timeString = String(format:"5:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "18":
                timeString = String(format:"6:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "19":
                timeString = String(format:"7:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "20":
                timeString = String(format:"8:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "21":
                timeString = String(format:"9:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "22":
                timeString = String(format:"10:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "23":
                timeString = String(format:"11:%@pm",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            case "00":
                timeString = String(format:"12:%@am",timeString.substring(from: timeString.characters.index(timeString.startIndex, offsetBy: 3)))
                break
            default:
                break
            }
            return String(format: "%@", timeString)
        }
        
        return ""
    }
    
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let dayOfMonth = (calendar as NSCalendar).component(.day, from: self)
        switch dayOfMonth {
        case 1: fallthrough
        case 21: fallthrough
        case 31: return "st"
        case 2: fallthrough
        case 22: return "nd"
        case 3: fallthrough
        case 23: return "rd"
        default: return "th"
        }
    }
    
    
}






