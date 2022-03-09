import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

actor {
    /**
     * Challenge 1 : Write a private function swap that takes 3 parameters : 
     * a mutable array , an index j and an index i and returns 
     * the same array but where value at index i and index j have been swapped.
     *
     * Use a public function to call the private one
     * dfx canister call MotokoBootCampChallenges swap '(vec{1;2;3;4},3,4)'
     */
    public func swap(a : [Nat], j : Nat, i : Nat) : async [Nat] {
      // Debug.print(debug_show(a));
      // call a private function from dfx
      return _swap(a, j, i);
    };

    func _swap(a : [Nat], j : Nat, i : Nat) : [Nat]  {
      let array : [var Nat] = Array.thaw(a);
      let iValue : Nat = array[(i-1)];

      array[(i-1)] :=  array[(j-1)];
      array[(j-1)] :=  iValue;

      return Array.freeze(array);
    };

    /**
     * Challenge 2 : Write a function init_count that takes a Nat n and 
     * returns an array [Nat] where value is equal to it's corresponding index.
     * dfx canister call MotokoBootCampChallenges init_count '(2)'
     */
    public func init_count(a : Nat) : async [Nat] {
      let array : [Nat] = Array.tabulate<Nat>(a, func(i : Nat) : Nat {
         i;
      });
      //Debug.print(debug_show(array));
      return array;
     };

    /**
     * Challenge 3 : Write a function seven that takes an 
     * array [Nat] and returns "Seven is found" if one digit of ANY number is 7. 
     * Otherwise this function will return "Seven not found".
     * dfx canister call MotokoBootCampChallenges seven '(vec{1;7})'
     */
    public func seven(a : [Nat]) : async Text {
      var result : Text = "Seven not found";
      // loop over the array
      label loop1 for (x in a.vals()) {
        // if we catch 7 then exit the named loop and finish the func.
        if(x == 7){
          result := "Seven is found";
          break loop1;
        }
      };
      result;
    };

  /**
   * Challenge 4 : Write a function nat_opt_to_nat that takes two parameters : 
   * n of type ?Nat and m of type Nat . 
   * This function will return the value of n if n is not null and if n is null it will 
   * default to the value of m.
   * dfx canister call MotokoBootCampChallenges nat_opt_to_nat '(opt 4, 6)'
   * dfx canister call MotokoBootCampChallenges nat_opt_to_nat '(null, 6)'
   */
   public func nat_opt_to_nat(n : ?Nat, m : Nat) : async Text {
    switch(n){
      case(null)  {
        return ("The value is: "# Nat.toText(m));
      };
      case (?something){
        return ("The value is: "# Nat.toText(something));
      };
    };
   };

  /**
  * Challenge 5 : Write a function day_of_the_week that takes a Nat n and 
  * returns a Text value corresponding to the day. If n doesn't correspond to 
  * any day it will return null .
  * dfx canister call MotokoBootCampChallenges day_of_the_week '(1)'
  */
  public func day_of_the_week(n : Nat) : async  ?Text {
     switch (n) {
       case (1){
        return ?"Monday";
       };
       case (2){
        return ?"Tuesday";
       };
       case (3){
        return ?"Wednesday";
       };
       case (4){
        return ?"Thursday";
       };
       case (5){
        return ?"Friday";
       };
       case (6){
        return ?"Saturday";
       };
       case (7){
        return ?"Sunday";
       };
      case(something) {
        return null;
      };
     };
  };

  /**
   * Challenge 6 : Write a function populate_array that takes an array [?Nat] 
   * and returns an array [Nat] where all null values have been replaced by 0.
   * dfx canister call MotokoBootCampChallenges populate_array '(vec {opt 1; opt 2; null; opt 3})'
   */
  public func populate_array(a : [?Nat]) : async [Nat] {
    return Array.map<?Nat, Nat>(a, func(i : ?Nat) : Nat {
      switch(i){
        case (null) { return 0 };
        case (?something) { return something };
      };
    });
  };

  /**
   * Challenge 7 : Challenge 7 : Write a function sum_of_array that takes an array [Nat] 
   * and returns the sum of a values in the array.
   * Note : Do not use a loop.
   * dfx canister call MotokoBootCampChallenges sum_of_array '(vec{1;7;2})'
   */
  public func sum_of_array(a : [Nat]) : async Nat {
    return Array.foldLeft<Nat, Nat>(a, 0, func(acc, x){
      acc + x;
    })
  };

  /**
   * Challenge 8 : Write a function squared_array that takes an 
   * array [Nat] and returns a new array where each value has been squared.
   * Note : Do not use a loop.
   * dfx canister call MotokoBootCampChallenges squared_array '(vec{1;7;2})'
   */
  public func squared_array(a : [Nat]) : async [Nat]{
    return(Array.map<Nat, Nat>(a, func (n : Nat) : Nat {
      return(n * n);
    }));
  };
  
  /**
   * Challenge 9 : Write a function increase_by_index that takes an array [Nat] 
   * and returns a new array where each number has been increased by it's corresponding index.
   * Note : increase_by_index [1, 4, 8, 0] -> [1 + 0, 4 + 1 , 8 + 2 , 0 + 3] = [1,5,10,3]
   * Note 2 : Do not use a loop.
   * dfx canister call MotokoBootCampChallenges increase_by_index '(vec{1;4;8;0})'
   */
  public func increase_by_index(a : [Nat]) : async [Nat]{
    return(Array.mapEntries<Nat, Nat>(a, func (v : Nat, k : Nat) : Nat {
      return(v + k);
    }));
  };

  /**
   * Challenge 10 : Write a higher order function contains<A> that takes 3 parameters : 
   * an array [A] , a of type A and a function f that takes a tuple of 
   * type (A,A) and returns a boolean
   * This function should return a boolean indicating whether or not a is present in the array.
   * dfx canister call MotokoBootCampChallenges contains '(vec{"test1";"test2"}, "test1")'
   */
   public func contains(a: [Text], c: Text) : async Bool {
     return _contains<Text>(a, c, func (_a, c) {
       return (_a == c);
     });
   };

   func _contains<A>(xs: [A], a: A, f : (A,A)-> Bool):Bool {
     var i = 0;
     while (i < xs.size()) {
       if(f(xs[i],a)){
         return true;
       };
       i += 1;
     };
     return false;
   };
};

