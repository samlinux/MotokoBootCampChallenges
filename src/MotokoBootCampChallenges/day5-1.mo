import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Iter "mo:base/Iter";

actor {

  /**
   * Challenge 9 : In a new file, copy and paste the functionnalities you've created in challenges 2 to 5. 
   * This time the hashmap and all records should be preserved accross upgrades.
   *
   */

 /**
   * Challenge 2 : Create an HashMap called favoriteNumber where 
   * the keys are Principal and the value are Nat.
   */

  stable var favoriteNumberEntries : [(Principal, Nat)] = [];
  let favoriteNumber : HashMap.HashMap<Principal, Nat> = HashMap.fromIter<Principal, Nat>(favoriteNumberEntries.vals(), 10, Principal.equal, Principal.hash);

  /**
   * Challenge 3 : Write two functions :
   * - add_favorite_number that takes n of type Nat and stores this value in the HashMap where 
   *   the key is the principal of the caller. This function has no return value.
   *
   * - show_favorite_number that takes no argument and returns n of type ?Nat, n is the 
   *   favorite number of the person as defined in the previous function or null if 
   *   the person hasn't registered.
   * dfx canister call MotokoBootCampChallenges add_favorite_number '(1)'
   * dfx canister call MotokoBootCampChallenges show_favorite_number
   */
  public shared({caller}) func add_favorite_number(n : Nat) {
    //Debug.print(debug_show(caller));
    favoriteNumber.put(caller, n);
  };

  public shared({caller}) func show_favorite_number() : async ?Nat {
    Debug.print(debug_show(caller));
    return favoriteNumber.get(caller);
  };

  /**
   * Challenge 4 : Rewrite your function add_favorite_number so that if 
   * the caller has already registered his favorite number, the value in 
   * memory isn't modified. 
   * This function will return a text of type Text that indicates 
   * "You've already registered your number" in that case and 
   * "You've successfully registered your number" in the other scenario.
   * dfx canister call MotokoBootCampChallenges add_favorite_number2 '(1)'
   */
  public shared({caller}) func add_favorite_number2(n : Nat): async Text {
    var msg : Text = "You've already registered your number";
    let a = favoriteNumber.get(caller);
   
    if (Option.isNull(a)){
      favoriteNumber.put(caller, n);
      msg := "You've successfully registered your number";
    };
    return msg;
  };

  /**
   * Challenge 5 : Write two functions
   * - update_favorite_number
   * - delete_favorite_number
   * dfx canister call MotokoBootCampChallenges update_favorite_number '(4)'
   * dfx canister call MotokoBootCampChallenges show_favorite_number
   */

  public shared({caller}) func update_favorite_number(n : Nat): async Text {
     favoriteNumber.put(caller,n);
     return "You've successfully updated your number";
  };

  /**
   * dfx canister call MotokoBootCampChallenges delete_favorite_number
   * dfx canister call MotokoBootCampChallenges show_favorite_number
   */
  public shared({caller}) func delete_favorite_number(): async Text {
    favoriteNumber.delete(caller);
    return "You've successfully deleted your number";
  };

  system func preupgrade() {
    favoriteNumberEntries := Iter.toArray(favoriteNumber.entries());
  };

  system func postupgrade() {
    favoriteNumberEntries := [];
  };
  


}