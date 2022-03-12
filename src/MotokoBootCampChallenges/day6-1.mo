import Principal "mo:base/Principal";

/**
 * change dfx.json, create two canisters
 "canisters": {
    "day61": {
      "main": "src/day3/day6-1.mo",
      "type": "motoko"
    },
    "day62": {
      "main": "src/day3/day6-2.mo",
      "type": "motoko"
    }
  }
**/
actor Actor1 {

  public shared ({caller}) func hello() : async Text {
    return("I was called by "#Principal.toText(caller))
  };
  
}
