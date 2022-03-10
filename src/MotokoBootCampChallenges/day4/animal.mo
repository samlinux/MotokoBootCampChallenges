module {
  public type Animal = {
    specie : Text;
    energy : Nat;
  };
  
  

  // challenge 3
  public func animal_sleep(animal : Animal) : Animal{
    var _animal : Animal = {
      specie = animal.specie;
      energy = animal.energy + 10;
    };
    return _animal;
  }
}