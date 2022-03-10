import Debug "mo:base/Debug";
import List "mo:base/List";

import Custom "custom";
import Animal "animal";

actor {

  /**
   * Challenge 1 : Create two files called custom.mo and main.mo, create your own type inside 
   * custon.mo and import it in your main.mo file. 
   * In main, create a public function fun that takes no argument but 
   * return a value of your custom type. Note : Be creative 
   * dfx canister call MotokoBootCampChallenges fun
   */
  public type Ship = Custom.Ship;
  public func fun () : async Text {
    let ship1 : Ship = {
      name = "Motoko-Bootcamp";
      size = 300;
    };
    return ship1.name;
  };

  /**
   * Challenge 2 : Create a new file called animal.mo with at least 2 property 
   * (specie of type Text, energy of type Nat), import this type in your main.mo 
   * and create a variable that will store an animal.
   * dfx canister call MotokoBootCampChallenges setAnimal
   */
  public type Animal = Animal.Animal;
  //public type Animal2 = Animal.Animal2;

  public func setAnimal ()  {
    let animal : Animal = {
      specie = "Ape";
      energy = 200;
    };
    Debug.print(debug_show(animal));
  };

  /**
   * Challenge 3 : In animal.mo create a public function called animal_sleep that 
   * takes an Animal and returns the same Animal where the field energy has been 
   * increased by 10. 
   * Note : As this is a public function of a module, you don't need to 
   * make the return type Async !
   * dfx canister call MotokoBootCampChallenges getSleepingAnimal '(record {specie="Wolf";energy=10})'
   */
  public func getSleepingAnimal(animal : Animal) : async Animal{
   return Animal.animal_sleep(animal);
  };

  /**
   * Challenge 4 : In main.mo create a public function called create_animal_then_takes_a_break 
   * that takes two parameter : a specie of type Text, an number of energy point of type Nat and 
   * returns an animal. This function will create a new animal based on the parameters passed and 
   * then put this animal to sleep before returning it !
   * dfx canister call MotokoBootCampChallenges create_animal_then_takes_a_break '("Wolf", 10)'
   */
  public func create_animal_then_takes_a_break(specie : Text, energy : Nat) : async Animal {
    var animal : Animal = {
       specie = specie;
       energy = energy;
    };
    // put this animal to sleep before returning it
    if(animal.energy > 0){
      animal := {
          specie = specie;
          energy = 0;
      };
    };

    return animal;
  };

  /**
   * Challenge 5 : In main.mo, import the type List from the base Library and 
   * create a list that stores animal.
   */

  var listOfAnimals = List.nil<Animal>();

  /**
   * Challenge 6 : In main.mo : create a function called push_animal that takes an animal as parameter 
   * and returns nothing this function should add this animal to your list created in challenge 5. 
   * Then create a second functionc called get_animals that takes no parameter but returns an 
   * Array that contains all animals stored in the list.
   * dfx canister call MotokoBootCampChallenges push_animal '(record {specie="Wolf";energy=10})'
   * dfx canister call MotokoBootCampChallenges get_animals
   */
  
  public func push_animal(animal : Animal) {
    listOfAnimals := List.push(animal, listOfAnimals);
  };
  
  public func get_animals() : async [Animal] {
    return List.toArray<Animal>(listOfAnimals);
  };


};