//Week 2 Coding Challenges by (Matthew) Sau Chung Loh
import UIKit

//Code Challenge: Write a function that determines how many words there are in a sentence

var sentence1 = "Hi my name is Matt."
var sentence2 = " Hi my name is Matt."
var sentence3 = "Hi my name is Matt. "
var sentence4 = "Hi my name is Matt ."

func countWordsinSentence(sentence: String) {
  
}

//Code Challenge: Write a function that returns all the odd elements of an array

var numbers : [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
var dogs : [String] = ["Fido", "Pup", "Scott", "Airbud", "Shiba", "Fatty"]

func returnOddElements(array : [AnyObject]) -> [AnyObject]{
  var length = array.count
  var arrayToReturn = [AnyObject]()
  for index in 0..<length {
    if index == 1 {
      arrayToReturn.append(array[index])
    } else if index % 2 == 1 {
      arrayToReturn.append(array[index])
    } else {
      
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
