import SwiftUI
import AVKit

struct ShuffleView: View {
    @StateObject private var vm = ShuffleViewModel()
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var completedStore: CompletedWorkoutsStore
    @EnvironmentObject private var favouritesStore: FavouritesStore
    
    @State private var currentCardIndex = 0
    @State private var timerRunning = false
    @State private var timeRemaining = 60
    @State private var showDetail = false
    @State private var player: AVPlayer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fitspinBackground.ignoresSafeArea()
                
                if vm.isLoading {
                    ProgressView().progressViewStyle(.circular).tint(.fitspinYellow)
                } else if let weather = vm.weather {
                    VStack(spacing: 20) {
                        header
                        weatherBlock(weather)
                        
                        if !vm.workouts.isEmpty {
                            workoutCard(vm.workouts[currentCardIndex])
                            timerDisplay
                            workoutControls
                        } else {
                            Text("No workouts available right now. Try again later.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showDetail) {
                        ExerciseDetailLoadedView(workout: vm.workouts[currentCardIndex])
                            .environmentObject(completedStore)
                    }
                    .onAppear {
                        setPlayer(for: currentCardIndex)
                    }
                    .onChange(of: currentCardIndex) { newIndex in
                        setPlayer(for: newIndex)
                    }
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.fitspinTangerine)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .onDisappear {
                player?.pause()
            }
            .onAppear {
                Task { await vm.fetchWeatherAndWorkouts() }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Image("fitspintext")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private func weatherBlock(_ weather: Weather) -> some View {
        VStack(spacing: 8) {
            Image(systemName: weather.condition.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.fitspinYellow)
            
            Text(vm.recommendation(for: weather.temperature))
                .font(.headline)
                .foregroundColor(.fitspinYellow)
        }
        .padding(.bottom, 6)
    }
    
    private func workoutCard(_ workout: Workout) -> some View {
        VStack(spacing: 16) {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            VStack(spacing: 8) {
                Text(workout.name)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                
                Text(workout.category.uppercased())
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.25))
                    .cornerRadius(10)
                
                Text("Equipment: \(workout.equipment.isEmpty ? "None" : workout.equipment.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Button(action: {
                    showDetail = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle.fill")
                        Text("More Info")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.fitspinBlue)
                    .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.black.opacity(0.15))
        .cornerRadius(20)
        .shadow(radius: 8)
        .padding(.horizontal)
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width < -50 && currentCardIndex < vm.workouts.count - 1 {
                    currentCardIndex += 1
                    resetTimer()
                } else if value.translation.width > 50 && currentCardIndex > 0 {
                    currentCardIndex -= 1
                    resetTimer()
                }
            }
        )
    }
    
    private var timerDisplay: some View {
        Text("⏰ \(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))")
            .font(.title3.bold())
            .foregroundColor(.fitspinYellow)
            .padding(.top, -8)
    }
    
    private var workoutControls: some View {
        let workout = vm.workouts[currentCardIndex]
        let isCompleted = completedStore.isCompletedToday(workout)
        let isFavourite = favouritesStore.isFavourite(workout)
        
        return HStack(spacing: 20) {
            controlButton(icon: nil, label: "Reset", bgColor: .fitspinTangerine) {
                resetTimer()
            }
            
            controlIcon(system: timerRunning ? "pause.fill" : "play.fill", bgColor: .green) {
                timerRunning.toggle()
                if timerRunning {
                    startTimer()
                }
            }
            
            controlIcon(system: isCompleted ? "checkmark.seal.fill" : "checkmark.seal",
                        bgColor: isCompleted ? .green : .orange) {
                if isCompleted {
                    completedStore.remove(workout)
                } else {
                    completedStore.add(workout)
                }
            }
            
            controlIcon(system: isFavourite ? "heart.fill" : "heart", bgColor: .red) {
                favouritesStore.toggle(workout)
            }
        }
        .padding(.top)
    }
    
    private func controlButton(icon: String?, label: String, bgColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(label)
            }
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(bgColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
    
    private func controlIcon(system: String, bgColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.title2)
                .padding(14)
                .background(bgColor)
                .clipShape(Circle())
                .foregroundColor(.white)
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 && timerRunning {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func resetTimer() {
        timeRemaining = 60
        timerRunning = false
    }
    
    private func setPlayer(for index: Int) {
        guard let url = vm.workouts[safe: index]?.videoURL else { return }
        player = AVPlayer(url: url)
        player?.isMuted = true
    }
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
