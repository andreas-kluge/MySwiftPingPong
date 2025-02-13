//
//  ArenaView.swift
//  PingPong
//
//  Created by Andreas Kluge on 02.01.25.
//

import SwiftUI

struct ArenaView: View {
    @ObservedObject var arena: ArenaViewModel = ArenaViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack{
            
            //Main Game Field
            ZStack{

                //The net
                Rectangle()
                    .frame(width: 1)
                    .opacity(0.5)
                
                GeometryReader { geometry in
                    
                    //The score board
                    HStack(spacing: 30){
                        Text("\(arena.scoreLeft)")
                            .font(.system(size: 60))
                            .foregroundStyle(arena.scoreLeft >= 10 ? Color.red : (colorScheme == .dark ? .white : .black))
                            .padding(10)
                        Text("\(arena.scoreRight)")
                            .font(.system(size: 60))
                            .padding(10)
                            .foregroundStyle(arena.scoreRight >= 10 ? Color.red : (colorScheme == .dark ? .white : .black))
                    }.position(x: geometry.size.width/2,y: 30)
                        
                    


                    
                    //Left Padel
                    Rectangle()
                        .frame(width: arena.leftPadelWidth, height: arena.leftPadelHeight)
                        .position(x: arena.leftPadelx, y: arena.leftPadely)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    //arena.leftPadelx = value.location.x
                                    arena.leftPadely = value.location.y
                                }
                        )
                    
                    //Right Padel
                    Rectangle()
                        .frame(width: arena.rightPadelWidth, height: arena.rightPadelHeight)
                        .position(x: arena.rightPadelx, y: arena.rightPadely)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    //print("x: \(value.location.x) y: \(value.location.y)")
                                    //arena.rightPadelx = value.location.x
                                    arena.rightPadely = value.location.y
                                }
                        )
                    
                    //Ball
                    Rectangle()
                        .frame(width: arena.ballSize, height: arena.ballSize)
                        .foregroundColor(.red)
                        .position(x:arena.ballx,
                                  y: arena.bally)
                        .onChange(of:geometry.size.width){
                            arena.setDimension(width: geometry.size.width, height: geometry.size.height)
                        }
                        .onChange(of:geometry.size.height){
                            arena.setDimension(width: geometry.size.width, height: geometry.size.height)
                        }
                        .onAppear{
                            //print("width: \(geometry.size.width) height: \(geometry.size.height)")
                            arena.setDimension(width: geometry.size.width, height: geometry.size.height)
                            arena.ballx = geometry.size.width / 2
                            arena.bally = geometry.size.height / 2
                        }
                        .animation(.easeIn, value: arena.ballx)
                        //.animation(.easeIn, value: arena.bally)
                    
                    //GameOver Message
                    Text(arena.gameOverMessage)
                        .font(.system(size: 30))
                        .background(.red)
                        .cornerRadius(6)
                        .bold()
                        .position(x:geometry.size.width/2 - 5, y: geometry.size.height/2)
                    
                }
            }.frame(maxHeight: .infinity)
                //.border(.white, width: 0.5)
            
            
            
            
            
            
            //Start / Stop Button
            HStack{
                Spacer()
                Button {
                    if !arena.isGameRunning{
                        arena.gameOverMessage = ""
                        arena.startBall()
                    } else {

                        
                        
                        arena.stopBall()
                    }
                    
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 100)
                            .foregroundStyle(.red)
                            .cornerRadius(10.0)
                        Text(!arena.isGameRunning ? "Start" : "Stop")
                            .foregroundStyle(.white)
                            .bold()
                    }.frame(height: 30)
                }
                Spacer()
            }
        }.padding()
    }
}

#Preview {
    ArenaView()
}
