import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Cycles "mo:base/ExperimentalCycles";

actor  {

  /**
   * Challenge 1 : Write a function is_anonymous that takes no arguments but 
   * returns true is the caller is anonymous and false otherwise.
   * dfx canister call MotokoBootCampChallenges is_anonymous
   */
  public shared({caller}) func is_anonymous() : async Bool {
    Principal.equal(caller, Principal.fromText("2vxsx-fae"))
  };

  /**
   * Challenge 2 : Create an HashMap called favoriteNumber where 
   * the keys are Principal and the value are Nat.
   */
  let favoriteNumber = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);

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

  /**
   * Challenge 6 : Write a function deposit_cycles that allow anyone to deposit cycles 
   * into the canister. This function takes no parameter but returns n of type Nat 
   * corresponding to the amount of cycles deposited by the call.
   * dfx canister call MotokoBootCampChallenges balance
   * dfx canister call MotokoBootCampChallenges deposit_cycles
   */

  public func balance() : async Nat {
    Debug.print("My cycles test:");
    return(Cycles.balance());
  };

  public func deposit_cycles() : async Nat {
    // this is fake, I think
    let AMOUNT_TO_PAY : Nat = 100_000;

    let received = Cycles.accept(AMOUNT_TO_PAY);
    Debug.print(debug_show(received));
    Debug.print(debug_show(Cycles.available()));
    Debug.print(debug_show(Cycles.balance()));
    // result is always 0 ??
    return(received);
  };

  /**
   * Challenge 7 (hard ⚠️) : Write a function withdraw_cycles that takes a parameter n of type Nat corresponding to the number of 
   * cycles you want to withdraw from the canister and send it to caller asumming the caller has a 
   * callback called deposit_cycles()
   * Note : You need two canisters.
   * Note 2 : Don't do that in production without admin protection or your might be the target of a cycle draining attack.
   * 
   */
  public func withdraw_cycles (){
    // to less time to figure that out !!
  };

   /**
    * Challenge 8 : Rewrite the counter (of day 1) but this time the counter will be kept accross ugprades. 
    * Also declare a variable of type Nat called versionNumber that will keep track of how many times your canister has been upgraded.
    * 
    * dfx canister call MotokoBootCampChallenges increment_counter '(2)'
    * dfx canister call MotokoBootCampChallenges getCurrentCounter
    * dfx canister call MotokoBootCampChallenges getVersionNumber
    */

    // define it as mutale variable and stable
    stable var counter: Nat = 0; 
    stable var versionNumber: Nat = 1;

    public func increment_counter(n : Nat) : async Nat {
      counter += n;
      return counter;
    };

    public func clear_counter() : async Text {
      counter := 0;
      return ("counter set to 0.");
    };

    public query func getCurrentCounter() : async Nat {
      counter;
    };

    public query func getVersionNumber() : async Nat {
      versionNumber;
    };

  system func preupgrade() {
    // Do something before upgrade
    versionNumber += 1;
  };
}
