import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat "mo:base/Nat";

actor {
    /**
     * Challenge 1 : Write a function add that takes two natural numbers n and m and returns the sum.
     * dfx canister call MotokoBootCampChallenges add '(1,2)'
     */
    public func add(n : Nat, m : Nat) : async Nat {
      return n + m;
    };

   /**
    * Challenge 2 : Write a function square that takes a natural 
    * number n and returns the area of a square of length n.
    * dfx canister call MotokoBootCampChallenges square '(2)'
    */
    public func square(n : Nat) : async Nat {
      return n * n;
    };
    
    /**
     * Challenge 3 : Write a function days_to_second that takes 
     * a number of days n and returns the number of seconds.
     * dfx canister call MotokoBootCampChallenges days_to_second '(1)'
     */
    public func days_to_second(n : Nat) : async Nat {
      // 1d = 24 h * 60 m * 60 s
      return n * 86400;
    };

    /**
     * Challenge 4 : Write two functions increment_counter & clear_counter. 
     * - increment_counter returns the incremented value of counter by n.
     * - clear_counter sets the value of counter to 0.
     * - get the current counter value as query function
     * dfx canister call MotokoBootCampChallenges increment_counter '(1)'
     * dfx canister call MotokoBootCampChallenges clear_counter
     * dfx canister call MotokoBootCampChallenges getCurrentCounter
     */
    var counter: Nat = 0; // define it as mutale variable but not stable

    public func increment_counter(n : Nat) : async Nat {
      counter += n;
      return counter;
    };

    public func clear_counter() : async Text {
      counter := 0;
      return ("counter set to 0")
    };

    public query func getCurrentCounter() : async Nat {
      counter;
    };

  /**
   * Challenge 5 : Write a function divide that takes two natural numbers n and m and 
   * returns a boolean indicating if n divides m.
   * dfx canister call MotokoBootCampChallenges divide '(3,2)'
   */
    public func divide(n:Nat, m:Nat): async Bool {
      if (m != 0) {
        return true;
      } else {
        return false;
      }
    };

    /**
     * Challenge 6 : Write a function is_even that takes a 
     * natural number n and returns a boolean indicating if n is even.
     * dfx canister call MotokoBootCampChallenges is_even '(2)'
     */
     public func is_even(n : Nat) : async Bool {
      if( n % 2 == 0){
        return true;
      } else {
        return false;
      }
    };

    /**
     * Challenge 7 : Write a function sum_of_array that takes an array of natural numbers and 
     * returns the sum. This function will returns 0 if the array is empty.
     * dfx canister call MotokoBootCampChallenges sum_of_array 'vec{1;2}'
     * dfx canister call MotokoBootCampChallenges sum_of_array 'vec{}'
     */
     public func sum_of_array(numbers : [Nat]) : async Nat {
      var sum:Nat = 0;
      //Debug.print(debug_show(sum));
      if(numbers.size() == 0){
        return sum;
      } else {
        for (value in numbers.vals()){
          //Debug.print(debug_show(value));
          sum += value;
        };
        return sum;
      }
    };

    /**
     * Challenge 8 : Write a function maximum that takes an array of natural numbers and 
     * returns the maximum value in the array. This function will returns 0 if the array is empty.
     * dfx canister call MotokoBootCampChallenges maximum 'vec{3;2}'
     * dfx canister call MotokoBootCampChallenges maximum 'vec{}'
     */
     public func maximum(numbers : [Nat]) : async Nat {
      if(numbers.size() == 0){
        return 0;
      } else {
        var max:Nat = 0;
        for (value in numbers.vals()){
          //Debug.print(debug_show(value));
          if(value > max){
            max := value;
          }
        };
        return max;
      }
    };

   /**
    * Challenge 9 : Write a function remove_from_array that takes 2 parameters : 
    * an array of natural numbers and a natural number n and returns a new array 
    * where all occurences of n have been removed (order should remain unchanged).
    * dfx canister call MotokoBootCampChallenges remove_from_array '(vec{2;4;6}, 2)'
    */
    public func remove_from_array(numbers : [Nat], num : Nat) : async [Nat] {
      // using the filter function from Array
      return Array.filter(numbers, func (_value : Nat) : Bool {
        return _value != num;
      });
    };

    /**
     * Challenge 10 : Implement a function selection_sort that takes an 
     * array of natural numbers and returns the sorted array.
     * dfx canister call MotokoBootCampChallenges selection_sort 'vec{4;1;6}'
     */
    public func selection_sort(numbers : [Nat]) : async [Nat] {
      // using the sort function from Array and compare function from Nat
      return Array.sort(numbers, Nat.compare);
    };


};
