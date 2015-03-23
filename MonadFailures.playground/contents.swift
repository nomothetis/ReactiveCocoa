//: Playground - noun: a place where people can play

import Cocoa
import ReactiveCocoa

let sp1 = SignalProducer<Int, NSError>(values:[0, 1])
let sp2 = SignalProducer<Int, NSError>(error:NSError())

let arr = [sp2, sp1]

let sp = SignalProducer<SignalProducer<Int, NSError>, NSError>(values:arr)

let concatSp = joinMap(JoinStrategy.Latest, {
    SignalProducer<SignalProducer<Int, NSError>, NSError>(value:$0)
})(producer:sp)

let vals:SignalProducer<[SignalProducer<Int, NSError>], NSError> = concatSp |> collect

var resultingArr:[SignalProducer<Int, NSError>] = []


vals.start(next: {
    println("called!")
    resultingArr = $0
})

var resultingNumArr = [Int]()
for p in resultingArr {
    p.start(next: { resultingNumArr += [$0] })
}
println(resultingNumArr)

var numArr = [Int]()
for p in arr {
    p.start(next: { numArr += [$0] })
}
println(numArr)


//let a = arr
//let b = resultingArr
