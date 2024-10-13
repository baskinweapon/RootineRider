//
//  AI.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 16/09/2024.
//

import ChatGPTSwift



class AI {
    
    var key: String = Keys.aiKey
    

    public func getAnswer(_ text: String) async -> String {
        let api = ChatGPTAPI(apiKey: key)
        do {
            let response = try await api.sendMessage(text: text,
                                                     model: ChatGPTModel(rawValue: "gpt-3.5-turbo")!,
                                                     systemText: "You are a CS Professor",
                                                     temperature: 1)
            return response
        } catch {
            return error.localizedDescription
        }
    }
    
    
    public func getCategories(_ text: String) async -> String {
        let api = ChatGPTAPI(apiKey: key)
        
        do {
//            let text = "I send you names of task you need create a categories like 'mindset, motivation, productivity, sport, etc.' for each task, and return categories with their tasks like 'mindset: task1, task2, task3, etc. write it in format json. there is a task: " + text + ". one task only have one category. if you dont know with category task - add it to other category. write only inside {}"
            
            let response = try await api.sendMessage(text: text,
                                 model: ChatGPTModel(rawValue: "gpt-4o-mini")!,
                                 systemText: "ты плагин в моем приложении. твоя задача получать на вход техт с названиями задач, твоя задача для каждой задачи придумать категорию, и вернуть json где ключ это - категория, а значение - массив с её задачами. используй только английский язык",
                                 temperature: 1)
            return response
        } catch {
            return error.localizedDescription
        }
    }
    
    public func getTaskEmpjies(_ text: String) async -> String {
        let api = ChatGPTAPI(apiKey: key)
        
        do {
//            let text = "I send you names of task you need create a categories like 'mindset, motivation, productivity, sport, etc.' for each task, and return categories with their tasks like 'mindset: task1, task2, task3, etc. write it in format json. there is a task: " + text + ". one task only have one category. if you dont know with category task - add it to other category. write only inside {}"
            
            let response = try await api.sendMessage(text: text,
                                 model: ChatGPTModel(rawValue: "gpt-4o-mini")!,
                                 systemText: "ты плагин в моем приложении. твоя задача получать на вход техт с названиями задач, твоя задача для каждой задачи придумать категорию, и вернуть json где ключ это - задача, а значение -emoji.емодзи с тем как ты думаешь подходит для задачи",
                                 temperature: 1)
            return response
        } catch {
            return error.localizedDescription
        }
    }
    
    public func getTaskEmojie(_ text: String) async -> String {
        let api = ChatGPTAPI(apiKey: key)
        
        do {
//            let text = "I send you names of task you need create a categories like 'mindset, motivation, productivity, sport, etc.' for each task, and return categories with their tasks like 'mindset: task1, task2, task3, etc. write it in format json. there is a task: " + text + ". one task only have one category. if you dont know with category task - add it to other category. write only inside {}"
            
            let response = try await api.sendMessage(text: text,
                                 model: ChatGPTModel(rawValue: "gpt-4o-mini")!,
                                 systemText: "ты плагин в моем приложении. твоя задача получать на вход техт с названиям задачи, и возвращать только емоджи которое как ты считаешь подходит для задачи",
                                 temperature: 1)
            return response
        } catch {
            return error.localizedDescription
        }
    }
    
    //You are a plugin in my swiftUI app. you getting tasks from input, and return categories with their tasks. return only json where: key is category name, value is array of tasks. and in each task after name add emoji with how you think about the task.
        
}

