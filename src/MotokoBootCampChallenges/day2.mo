import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Debug "mo:base/Debug";
import List "mo:base/List";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Blob "mo:base/Blob";

actor {
    /**
     * Challenge 1 : Write a function nat_to_nat8 that converts a Nat n to a Nat8. 
     * Make sure that your function never trap. 
     * dfx canister call MotokoBootCampChallenges nat_to_nat8 '(1)'
     */
    public func nat_to_nat8(n : Nat) : async Nat8 {
      var a : Nat8 = 0;

      if( n <= 255 ){
        a := Nat8.fromNat(n);
         return a;
      } else {
         return a;
      }
    };

  /**
   * Challenge 2 : Write a function max_number_with_n_bits that takes a Nat n and 
   * returns the maximum number than can be represented with only n-bits.
   * dfx canister call MotokoBootCampChallenges max_number_with_n_bits '(4)'
   */
  public func max_number_with_n_bits(n : Nat) : async Nat {
    // create a helper array like that [1,1,1,1]
    var bits : [var Nat] = Array.init<Nat>(n,1);

    // result max decimal value
    var dec : Nat = 0;

    // loop over the bits array and calc the max decimal number
    // according to the input value which is representing n-bits
    for (i in bits.vals()) {
      //Debug.print(debug_show("> "# Nat.toText(i)));
      dec := dec * 2;
      dec := dec + i;
    };

    return dec;
  };

  /**
   * Challenge 3 : Write a function decimal_to_bits that takes a Nat n and 
   * returns a Text corresponding to the binary representation of this number.
   * Note : decimal_to_bits(255) -> "11111111".
   * dfx canister call MotokoBootCampChallenges decimal_to_bits '(12)'
   */

  public func decimal_to_bits(n : Nat) : async Text {
    // finale text string
    var bitText : Text = "";
    
    // collect all
    var listOfBits = List.nil<Nat>();
    
    // use n as divided and set later the quotient as dividend
    var quotient : Nat = n;

    while (quotient > 0) {
      // get the result 0 or 1
      var r : Nat = quotient % 2;
      
      // set the new quotient as new divided
      quotient := quotient / 2;

      // push the result to a list (because I don't know a way to reverse a array!)
      listOfBits := List.push(r, listOfBits);
    };

    // Debug.print("> "#debug_show(listOfBits));  

    // convert the list to an array = reverse the list what is nice in this situation
    var arrayOfBits : [Nat] = List.toArray(listOfBits);

    // Debug.print("> "#debug_show(arrayOfBits));

    // loop over the arrayOfBits and concat the final text string
    for (value in arrayOfBits.vals()){
      bitText := bitText # Nat.toText(value);
    };

    return bitText;
  };

  /**
   * Challenge 4 : Write a function capitalize_character that 
   * takes a Char c and returns the capitalized version of it.
   * dfx canister call MotokoBootCampChallenges capitalize_character '("a")'
   */
  public func capitalize_character(c : Text) : async Text {
    // finale result
    var upperCase : Text = "";

    // loop over the text
    for(char in c.chars()){
      // get the ASCII char number
      var a : Nat32 = Char.toNat32(char);

      //Debug.print("> "#debug_show(char));
      //Debug.print(">> "#debug_show(a));

      // Capital letters starts at number 65
      // Small letters starts at number 97

      // get the difference from the starting point small letters
      var b : Nat32 = a - 97;

      // add the difference to the starting point capital letters
      b := b + 65;

      // get the capital letter
      var b2 : Char = Char.fromNat32(b);

      // parse the chat to text
      var b3 : Text = Char.toText(b2);

      //Debug.print(">> "#debug_show(b2));
      // concat the finale result
      upperCase := upperCase # b3;
    };
    
    return(upperCase);
  };

  /**
   * Challenge 5 : Write a function capitalize_text that takes a 
   * Text t and returns the capitalized version of it.
   * same as Challenge 4
   * dfx canister call MotokoBootCampChallenges capitalize_character '("aztr")'
   */
  
  /**
   * Challenge 6 : Write a function is_inside that takes two arguments : 
   * a Text t and a Char c and returns a Bool indicating if c is inside t .
   * dfx canister call MotokoBootCampChallenges is_inside '("RockStar", "o")'
   */
   public func is_inside(t : Text, c : Text) : async Bool {
    let check : Bool = Text.contains(t, #text c);
    check;
   };

  /**
   * Challenge 7 : Write a function trim_whitespace that takes a 
   * text t and returns the trimmed version of t. 
   * Note : Trim means removing any leading and trailing spaces from the text : 
   * trim_whitespace(" Hello ") -> "Hello".
   * dfx canister call MotokoBootCampChallenges trim_whitespace '(" RockStar ")'
   */
   public func trim_whitespace(t : Text) : async Text {
    let trimedText : Text = Text.trim(t, #text " ");
    trimedText;
   };

  /**
   * Challenge 8 : Write a function duplicated_character that takes a 
   * Text t and returns the first duplicated character in t converted to Text. 
   * Note : The function should return the whole Text if there is no duplicate character : 
   * duplicated_character("Hello") -> "l" & duplicated_character("World") -> "World".
   * dfx canister call MotokoBootCampChallenges duplicated_character '("Hello")'
   * dfx canister call MotokoBootCampChallenges duplicated_character '("World")'
   */
   public func duplicated_character(t : Text) : async Text {
    // the final result
    var result : Text = t;

    // my internal counter 
    var num : Nat = 0;
    
    // loop over the chars
    label loop1 for(char in t.chars()){
      // set num to 0
       num := 0;

       // do an ther loop, maybe not the best way !
       for(char2 in t.chars()){
         // if we have a match
         if(char == char2){
           // count the match
           num += 1;
         }; 
       };
       // if we have the first 2 matches
       // we are finished
       if(num == 2){
           result := Char.toText(char);
           break loop1;
        };

        //Debug.print(">> "#debug_show(num));
    };

    // otherwise return the original text
    return result;
   };

  /**
   * Challenge 9 : Write a function size_in_bytes that takes Text t and 
   * returns the number of bytes this text takes when encoded as UTF-8.
   * dfx canister call MotokoBootCampChallenges size_in_bytes '("World")'
   */
  public func size_in_bytes(t : Text) : async Nat {
    // encode text to utf8 blob
    var utf8Text : Blob = Text.encodeUtf8(t);
    // get blob size in bytes
    var size : Nat = utf8Text.size();
    return size;
  };

  /**
   * Challenge 10 : Implement a function bubble_sort 
   * that takes an array of natural numbers and returns the sorted array.
   * dfx canister call MotokoBootCampChallenges bubble_sort 'vec {3;1;10}'
   */
  public func bubble_sort(a : [Nat]) : async [Nat] {
    // transform an immutable array into a mutable array
    let array : [var Nat] = Array.thaw(a);
    
    // internal counter
    var i : Nat = 0;
    
    // loop over the array until size is reached
    while (i < array.size()){

      var min : Nat = i;
      var j : Nat = i + 1;
      
      // loop over the array until size is reached
      while (j < array.size()){
        if (array[j] < array[min]) {
          min := j;
        };
        j += 1;
      };
      
      // do the reorder
      if (min != i) {
        var temp : Nat = array[i];
        array[i] := array[min];
        array[min] := temp;
      };

      i += 1;
    };

    // transform mutable array back into immutable array
    return Array.freeze(array);
  }
}