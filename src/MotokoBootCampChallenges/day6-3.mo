
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import List "mo:base/List";

actor {

  type TokenIndex = Nat;
  type NextTokenIndex = Nat;
  type Result<Ok, Err> = {#ok : Ok; #err : Err};

  var next : NextTokenIndex = 0;

  stable var registryEntries : [(TokenIndex, Principal)] = [];
  let registry : HashMap.HashMap<TokenIndex, Principal> = HashMap.fromIter<TokenIndex, Principal>(registryEntries.vals(), 10,Nat.equal, Hash.hash);

  public shared ({caller}) func mint() : async Result<(), Text> {
    // tis is not working im 0.8.4 I think so !
    registry.put(next, caller);
    next += 1; 
    return #ok;
  };

  public shared ({caller}) func getTokenFromCaller (): async List.List<Nat> {
    var listOfTokenIndex = List.nil<Nat>();
    
    for ((k,v) in registry.entries()) {
      //Debug.print("> "#debug_show(v)#" == "#Principal.toText(caller));
      if( v == caller){
        listOfTokenIndex := List.push(k,listOfTokenIndex);
      };
    };
    return listOfTokenIndex;
  };

  // check your HashMap
  public func checkRegistry (): async [(Nat, Principal)] {
    return Iter.toArray<(Nat, Principal)>(registry.entries());
  };

  system func preupgrade() {
    // uncomment this for testing
    //Debug.print("test");
    registryEntries := Iter.toArray(registry.entries());
  };

  system func postupgrade() {
    registryEntries := [];
  };
}