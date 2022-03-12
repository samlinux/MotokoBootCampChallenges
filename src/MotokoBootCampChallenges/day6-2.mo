
actor Actor2 {

  // the Actor2 wants to call hello function from Actor1
  let other_canister : actor { hello : () -> async Text} = actor("rrkah-fqaaa-aaaaa-aaaaq-cai");

  public func test() : async Text {
    return(await other_canister.hello())
  };
}