//
//  ContentView.swift
//  AIChatBot
//
//  Created by Parth Kumar on 8/5/24.
//
import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var textInput = ""
    @State var aiResponse = "Hello! I am your personalized Random Meal Generator App!"
    @State var isGenerating = false
    @State var mealSuggestions: [String] = []
    @State var timeofDay = ""
    @State var backgroundImage: String = "DefaultImage"
    var body: some View {
        ZStack {

            VStack {
                ScrollView {
                    if isGenerating == true {
                        ProgressView()
                    }
                    Text(aiResponse)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(20)
                    Menu {
                        Button("Breakfast") {
                            withAnimation {
                                backgroundImage = "SunriseImage"
                            }
                            timeofDay = "Breakfast"

                            
                        }
                        Button("Lunch") {
                            withAnimation {
                                backgroundImage = "SunImage"
                            }
                            timeofDay = "Lunch"
                        }
                        Button("Dinner") {
                            withAnimation {
                                backgroundImage = "SunsetImage"
                            }
                            timeofDay = "Dinner"
                        }
                    } label: {
                        Text("Select an Option")
                    }
                }
            
                


                HStack {
                        
                    TextField("Calories: ", text: $textInput)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.white)
                    Button(action: sendMessage, label: {
                        Image(systemName: "paperplane.fill")
                    })
                }
            }
            .foregroundStyle(.blue)
            .padding()
            .background(
                ZStack {
                    Image(backgroundImage)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)

                }
            )
        }
    }


    func sendMessage() {
        aiResponse = ""
        Task {
            isGenerating = true
            do {
                let response: GenerateContentResponse
                if timeofDay == "Breakfast" {
                    response = try await model.generateContent("Breakfast items with exactly " + textInput + "calorie meals in a list. Separate each recommendation with a couple of empty lines to make it look clean. Do not use any special characters. Just want the name of the meal. Use - to start the meals off.")
                }else if timeofDay == "Lunch" {
                    response = try await model.generateContent("Dinner items with exactly " + textInput + "calorie meals in a list. Separate each recommendation with a couple of empty lines to make it look clean. Do not use any special characters. Just want the name of the meal. Use - to start the meals off.")
                }else if timeofDay == "Dinner" {
                    response = try await model.generateContent("Dinner items with exactly " + textInput + "calorie meals in a list. Separate each recommendation with a couple of empty lines to make it look clean. Do not use any special characters. Just want the name of the meal. Use - to start the meals off.")
                } else {
                    // Handle unexpected `timeofDay`
                    aiResponse = "Please select a valid time of day."
                    isGenerating = false
                    return
                }
                guard let text = response.text else {
                    textInput = "Sorry, I could not process that.\nPlease try again."
                    return
                }
                textInput = ""
                aiResponse = text
            } catch {
                aiResponse = "Something went wrong!\n\(error.localizedDescription)"
            }
            isGenerating = false
        }
    }
}
#Preview {
    ContentView()
}
