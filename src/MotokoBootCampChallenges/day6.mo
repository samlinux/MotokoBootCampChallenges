import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Text "mo:base/Text";
import Option "mo:base/Option";
import HTTP "http";


actor {
  /**
   * Challenge 1 : Create an actor in main.mo and declare the following types.
   **/

  type TokenIndex = Nat;
  type Error = {
    #Error1;
    #Error2;
  };

  /**
   * Challenge 2 : Declare an HashMap called registry with Key of type TokenIndex and 
   * value of type Principal. This will keeep track of which 
   * principal owns which TokenIndex.
   */
   // let registry = HashMap.HashMap<TokenIndex, Principal>(0, Nat.equal, Hash.hash);

   // Change from challenge 7
   stable var registryEntries : [(TokenIndex, Principal)] = [];
   let registry : HashMap.HashMap<TokenIndex, Principal> = HashMap.fromIter<TokenIndex, Principal>(registryEntries.vals(), 10,Nat.equal, Hash.hash);
 

  /**
   * Challenge 3 : Declare a variable of type Nat called nextTokenIndex, initialized at 0 that 
   * will keep track of the number of minted NFTs.
   * Write a function called mint that takes no argument. This function should :
   *
   * - Returns a result of type Result and indicate an error in case the caller is anonymous.
   * - If the user is authenticated : associate the current TokenIndex with the caller 
   *   (use the HashMap we've created) and increase nextTokenIndex.
   *
   * dfx canister call MotokoBootCampChallenges mint
   * dfx canister call MotokoBootCampChallenges checkRegistry
   */
  
  type NextTokenIndex = Nat;
  var next : NextTokenIndex = 0;

  type Result<Ok, Err> = {#ok : Ok; #err : Err};

  public shared ({caller}) func mint() : async Result<(), Text> {
    if(Principal.isAnonymous(caller)){
      return #err("You need to be authenticated to register");
    } else {
       registry.put(next, caller);
       next += 1; 
      return #ok;
    }
  };
  
  // check your HashMap
  public func checkRegistry (): async [(Nat, Principal)] {
    return Iter.toArray<(Nat, Principal)>(registry.entries());
  };

  /**
   * Challenge 4 : Write a function called transfer that takes two arguments :
   * - to of type Principal.
   * - tokenIndex of type Nat.
   * This function will transfer ownership of tokenIndex to the specified principal.
   * > qlc5m-nfncz-rn3n7-ls2ko-djee3-jxsvd-xgdsg-ggnf7-dfsvm-xpiln-3a
   * > 5in2y-xhapa-hpn6f-msbxi-gchar-qhvyk-272zn-rdoal-z52ah-adyie-tqe
   * dfx canister call MotokoBootCampChallenges transfer '(principal "5in2y-xhapa-hpn6f-msbxi-gchar-qhvyk-272zn-rdoal-z52ah-adyie-tqe",0)'
   */

  public func transfer (to : Principal, tokenIndex : Nat): async Result<(), Text> {
    let check = registry.get(tokenIndex);
    switch check {
      case null return #err("tokenId does not exists");
      case (?Principal) {
        registry.put(tokenIndex, to);
        return #ok;
      }
    }  
  };

  /**
   * Challenge 5 : Write a function called balance that takes no arguments but 
   * returns a list of tokenIndex owned by the called.
   * dfx canister call MotokoBootCampChallenges balance
   * dfx canister call MotokoBootCampChallenges balance2 '(principal "5in2y-xhapa-hpn6f-msbxi-gchar-qhvyk-272zn-rdoal-z52ah-adyie-tqe")'
   */  
  public shared ({caller}) func balance (): async List.List<Nat> {
    var listOfTokenIndex = List.nil<Nat>();
    
    for ((k,v) in registry.entries()) {
      //Debug.print("> "#debug_show(v)#" == "#Principal.toText(caller));
      if( v == caller){
        listOfTokenIndex := List.push(k,listOfTokenIndex);
      };
    };
    return listOfTokenIndex;
  };

  public func balance2 (p:Principal): async  [Nat]{
    var listOfTokenIndex = List.nil<Nat>();

    for ((k,v) in registry.entries()) {
      //Debug.print("> "#debug_show(v)#" == "#Principal.toText(p));
      if( v == p){
        listOfTokenIndex := List.push(k,listOfTokenIndex);
      };
    };
    let arrayOfTokenIndex = List.toArray<Nat>(listOfTokenIndex);
    return arrayOfTokenIndex;
  };


  /**
   * Challenge 6 : Write a function called http_request that should return a message indicating the number of nft 
   * minted so far and the principal of the latest minter. 
   * (Use the section on http request in the daily guide).
   * call it in the browser: http://127.0.0.1:8000/?canisterId=rrkah-fqaaa-aaaaa-aaaaq-cai
   */
  public query func http_request(request : HTTP.Request) : async HTTP.Response {
    let numberMintNft : Nat = registry.size();

    if(numberMintNft > 0){
      let lastMint = registry.get(numberMintNft-1);
      switch lastMint {
        case null {
          let response = {
            body = Text.encodeUtf8("No NFT minted right now.");
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200 : Nat16;
            streaming_strategy = null
          };
          return(response);  
        };
        case (?Principal) {
          let lastMintPrincipal = Option.get(lastMint, Principal);
          let lastMintPrincipalText : Text = debug_show(lastMintPrincipal);

          //Debug.print(debug_show(lastMintPrincipal));
          //Debug.print(debug_show(numberMintNft));
          //Debug.print(debug_show(lastMint));
          let response = {
            body = Text.encodeUtf8("Number of NFT mint "# Nat.toText(numberMintNft) #"<br>last mint principal: "#lastMintPrincipalText);
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200 : Nat16;
            streaming_strategy = null
          };
          return(response)
        };  
      };
    }
    else {
      let response = {
        body = Text.encodeUtf8("No NFT minted right now.");
        headers = [("Content-Type", "text/html; charset=UTF-8")];
        status_code = 200 : Nat16;
        streaming_strategy = null
      };
      return(response);  
    };
  };

  /**
   * Challenge 7 : Modify the actor so that you can safely upgrade it without loosing any state.
   */
  system func preupgrade() {
    // uncomment this for testing
    //Debug.print("test");
    registryEntries := Iter.toArray(registry.entries());
  };

  system func postupgrade() {
    registryEntries := [];
  };

/**
 * Bonus : intercanister calls.
 * Challenge 8 : Create another canister and use to mint a NFT by calling the mint method of your first canister.
 * Well... you just created your own on-chain wallet. 🔒
 * Bonus optional (Only take on those challenges if you have nothing else to do today...)
 * see day6-1.mo and day6-2.mo
 */ 


}