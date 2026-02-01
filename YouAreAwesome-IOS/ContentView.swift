//
//  ContentView.swift
//  YouAreAwesome-IOS
//
//  Created by ZM on 2/1/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var message = ""
    @State private var imageTitle = ""
    @State private var lastMessageNumber = -1
    @State private var lastImageNumber = -1 // will never be a real number
    @State private var audioPlayer : AVAudioPlayer!
    @State private var lastSoundNumber = -1
    @State private var soundName = ""
    @State private var soundIsOn = true

    let numberOfImages = 10
    let numberOfSounds = 6
    
    
    var body: some View {
        
        VStack {
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.red)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(height: 130)
            
            Spacer()
            
            Image(imageTitle) // use shift+command+L to pull library
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 30)
                // hold option key for params to be entered
                .animation(.easeInOut(duration: 0.15), value: message)

            
            Spacer()
            
            
            HStack {
                Text("Sound On: ")
                Toggle("", isOn: $soundIsOn)
                    .labelsHidden()
                    .onChange(of: soundIsOn) {
                        if audioPlayer != nil && audioPlayer.isPlaying{
                            audioPlayer.stop()
                        }
                    }
                
                Spacer()
                
                Button("Show Message") {
                    let messages = ["You Are Awesome!" ,
                                    "You Are Great!",
                                    "I am really proud of myself and everyone else should be proud of you as well.",
                                    "You Are Fantastic!",
                                    "Fabulous? That's You!",
                                    "You Make Me Smile!",
                                    "When the Genius Bar Needs Help, They Call You!"]
                    
                    
                    lastMessageNumber = nonRepeatingRandom(lastNumber: lastMessageNumber, upperBound: messages.count-1)
                    
                    message = messages[lastMessageNumber]
                    
                    lastImageNumber = nonRepeatingRandom(lastNumber: lastImageNumber, upperBound: numberOfImages-1)
                    
                    imageTitle = "image\(lastImageNumber)"
                    
                    lastSoundNumber = nonRepeatingRandom(lastNumber: lastSoundNumber, upperBound: numberOfSounds-1)
                    
                    if soundIsOn {
                        playSound(soundName: "sound\(lastSoundNumber)")
                    }
                    
                    
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                
            }
            .tint(.accentColor)
            
        }
        .padding()
        
    }
    
    func playSound(soundName: String) {
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 Error: \(error.localizedDescription) creating audioPlayer")
        }
    }
    
    func nonRepeatingRandom(lastNumber: Int, upperBound: Int) -> Int {
        var newNumber : Int
        
        repeat {
            newNumber = Int.random(in: 0...upperBound)
        } while newNumber == lastNumber
        return newNumber
    }
    
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}

