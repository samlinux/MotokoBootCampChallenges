import Debug "mo:base/Debug";
import List "mo:base/List";

actor {

  /**
   * Challenge 7 : Write a function is_null that takes l of type List<T> and 
   * returns a boolean indicating if the list is null . 
   * Tips : Try using a switch/case.
   * dfx canister call MotokoBootCampChallenges is_null '(opt record {12})'
   * dfx canister call MotokoBootCampChallenges is_null '(null)'
   */
  public type List<T> = ?(T, List<T>);
  public func is_null(l : List<Nat>) : async Bool {
    switch(l){
      case(null) {
          return false;
      };
      case(?l){
          return true;
      };
    }
  };

  /**
   * Challenge 8 : Write a function last that takes l of type List<T> and 
   * returns the optional last element of this list.
   * dfx canister call MotokoBootCampChallenges last
   */
  public func last() : async ?Nat {
    var list = List.nil<Nat>();
    
    // add some list values
    list := List.push(10, list);
    list := List.push(11, list);
    list := List.push(12, list);

    Debug.print("The last element seems the first in the list");
    return List.get(list,0);
  };

  /**
   * Challenge 9 : Write a function size that takes l of type List<T> and 
   * returns a Nat indicating the size of this list. 
   * Note : If l is null , this function will return 0.
   * dfx canister call MotokoBootCampChallenges size
   */

  public func size() : async Nat {
    var list = List.nil<Nat>();
    
    // add some list values
    list := List.push(10, list);
    list := List.push(11, list);
    list := List.push(12, list);

    return List.size(list);
  };

  /**
   * Challenge 10 : Write a function get that takes two arguments : 
   * l of type List<T> and n of type Nat this function should 
   * return the optional value at rank n in the list.
   * dfx canister call MotokoBootCampChallenges get '(1)'
   */
   public func get( n : Nat) : async ?Nat {
    var list = List.nil<Nat>();
    
    // add some list values
    list := List.push(10, list);
    list := List.push(11, list);
    list := List.push(12, list);

    return List.get(list,n);
  };

  /**
   * Challenge 11 : Write a function reverse that takes 
   * l of type List and returns the reversed list.
   * dfx canister call MotokoBootCampChallenges reverse 
   */

  public func reverse() : async List<Nat> {
    var list = List.nil<Nat>();
    
    // add some list values
    list := List.push(10, list);
    list := List.push(11, list);
    list := List.push(12, list);
    list := List.push(13, list);

    return List.reverse(list);
  }
}