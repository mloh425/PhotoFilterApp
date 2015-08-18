//Week 2 Coding Challenges by (Matthew) Sau Chung Loh
import UIKit

//Code Challenge: Write a function that determines how many words there are in a sentence

var sentence1 = "Hi my name is Matt."
var sentence2 = " Hi my name is Matt."
var sentence3 = "Hi my name is Matt. "
var sentence4 = "Hi my name is Matt ."

func countWordsinSentence(sentence: String) -> Int {
  var sentenceArray = split(sentence) {$0 == " "}
  return sentenceArray.count
}

countWordsinSentence(sentence1)
countWordsinSentence(sentence2)

//Code Challenge: Write a function that returns all the odd elements of an array

var numbers : [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
var dogs : [String] = ["Fido", "Pup", "Scott", "Airbud", "Shiba", "Fatty"]

func returnOddElements(array : [AnyObject]) -> [AnyObject]{
  var length = array.count
  var arrayToReturn = [AnyObject]()
  for index in 0..<length {
    if index % 2 == 1 { //Apparently 1 % 2 is equal to 1
      arrayToReturn.append(array[index])
    }
  }
  return arrayToReturn
}

returnOddElements(numbers)
returnOddElements(dogs)

//Code Challenge: Write a function that computes the list of the first 100 Fibonacci numbers.

func fibonacci (n : Int) -> Int {
  if n == 0 {
    return 0
  } else if n == 1 {
    return 1
  } else {
    var x = fibonacci(n-1) + fibonacci(n-2)
    println(x)
    return x
  }
}

//Do not want to do 100 because it runs forever and playground is glitchy
for index in 0...10 {
  println(fibonacci(index))
}

//Code Challenge: Write a function that tests whether a string is a palindrome

let word1 = "radar"
let word2 = "racecar"
let word3 = "adda"
let word4 = "itftgjyi"

println(word1.startIndex)
let i = 0
let index = advance(word1.startIndex, i)
println(word1[index])

func isPalindrome (word : String) -> Bool {

  var index = 0
  var startI = advance(word.startIndex, index)
  var endI = advance(word.endIndex, -(index + 1))
  
  while (endI > startI) {
    if word[startI] != word[endI] {
      return false
    }
    startI++
    endI--
    
  }
  return true
}

isPalindrome(word1)
isPalindrome(word4)
isPalindrome(word2)

//Implement a Stack Data Structure

//Data Structure Thursday - Implement a Queue

class IntStack { //Using ints for an example
  private var intStack = [Int]()
  //Adds a value to the end of the queue
  func push (integer : Int) {
    intStack.append(integer)
  }
  
  //Removes a value from the head of the queue
  func pop () -> Int? {
    if !intStack.isEmpty {
      return intStack.removeLast()
    }
    return nil
  }
  
  //Returns the value of the element at the head of the queue
  func peek () -> Int? {
    if !intStack.isEmpty {
      var value = intStack.removeLast()
      intStack.append(value)
      return value
    }
    return nil
  }
  
  func isEmpty() -> Bool {
    if intStack.isEmpty {
      return true
    }
    return false
  }
  
  func removeAll() -> [Int] {
    intStack = []
    return intStack
  }
  
  func printStack() {
    println(intStack)
  }
}

var testStack = IntStack()

//Testing the addition of ints
for i in 1...5 {
  testStack.push(i)
}
testStack.printStack()

//Testing the peek method

println(testStack.peek())
testStack.printStack()

//Testing the dequeue method

for i in 1...5 {
  testStack.pop()
  if !testStack.isEmpty() {
    testStack.printStack()
  }
  
}
testStack.printStack()

