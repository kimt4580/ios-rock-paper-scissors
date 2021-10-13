//
//  RockPaperScissors - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
//

// MARK: - Enums
enum Message {
    static let menu: String = "가위(1), 바위(2), 보(3)! <종료 : 0> : "
    static let exit: String = "게임 종료"
}

enum GameResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .draw:
            return "비겼습니다!"
        case .win:
            return "이겼습니다!"
        case .lose:
            return "졌습니다!"
        }
    }
    
    case draw
    case win
    case lose
}

enum GameError: Error, CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidInput:
            return "잘못된 입력입니다. 다시 시도해주세요."
        }
    }
    
    case invalidInput
}

enum ExpectedHand: String, CaseIterable, Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs == .paper, rhs == .scissors {
            return true
        }
        return lhs.rawValue < rhs.rawValue
    }
    
    case scissors = "1"
    case rock = "2"
    case paper = "3"
}

// MARK: - Functions
func readUserInput() throws -> ExpectedHand? {
    let input = readLine()
    
    switch input {
    case "0":
        return nil
    case .some(let input):
        if let userHand: ExpectedHand = ExpectedHand(rawValue: input) {
            return userHand
        }
        throw GameError.invalidInput
    case .none:
        throw GameError.invalidInput
    }
}

func generateComputerHand() -> ExpectedHand? {
    return ExpectedHand.allCases.randomElement()
}

func judgeGameResult(_ input: ExpectedHand) -> GameResult {
    guard let computerHand: ExpectedHand = generateComputerHand() else {
        fatalError()
    }
    
    if computerHand == input {
        return .draw
    } else if computerHand < input {
        return .win
    } else {
        return .lose
    }
}

func runProgram() {
    print(Message.menu, terminator: "")
    
    do {
        guard let userHand = try readUserInput() else {
            print(Message.exit)
            return
        }
        
        let gameResult: GameResult = judgeGameResult(userHand)
        
        switch gameResult {
        case .draw:
            print(gameResult)
            runProgram()
        case .win, .lose:
            print(gameResult)
        }
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        runProgram()
    } catch {
        fatalError()
    }
}

// MARK: - Program start
runProgram()
