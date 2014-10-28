require 'rspec'
require '06_joins_warmup'

describe "JOIN warmup" do
  describe "films_from_sixty_two" do
    it "selects films from the year 1962" do
      expect(films_from_sixty_two).to contain_exactly(
        [121, "To Kill a Mockingbird"],
        [479, "Dr. No"],
        [1082, "Music Man, The"],
        [1496, "What Ever Happened to Baby Jane?"],
        [1751, "Cape Fear"]
      )
    end
  end

  describe "year_of_kane" do
    it "selects the year that Citizen Kane was released" do
      expect(year_of_kane).to contain_exactly([1941.0])
    end
  end

  describe "trek_films" do
    it "selects all Star Trek films and orders them by year" do
      expect(trek_films).to eq([
        [402, "Star Trek: The Motion Picture", 1979.0],
        [209, "Star Trek: The Wrath of Khan", 1982.0],
        [438, "Star Trek III: The Search for Spock", 1984.0],
        [349, "Star Trek IV: The Voyage Home", 1986.0],
        [472, "Star Trek V: The Final Frontier", 1989.0],
        [410, "Star Trek VI: The Undiscovered Country", 1991.0],
        [280, "Star Trek: Generations", 1994.0],
        [68, "Star Trek: First Contact", 1996.0],
        [252, "Star Trek: Insurrection", 1998.0]
      ])
    end
  end

  describe "films_by_id" do
    it "selects the names of the films with the given IDs" do
      expect(films_by_id).to contain_exactly(
      )
    end
  end

  describe "glenn_close_id" do
    it "selects the ID of actress Glenn Close" do
      expect(glenn_close_id).to contain_exactly([104])
    end
  end

  describe "casablanca_id" do
    it "selects the ID of the film Casablanca" do
      expect(casablanca_id).to contain_exactly([27])
    end
  end

  describe "casablanca_cast" do
    it "selects the cast of the film Casablanca" do
      expect(casablanca_cast).to contain_exactly(
        ["Humphrey Bogart"],
        ["Ingrid Bergman"],
        ["Claude Rains"],
        ["Peter Lorre"],
        ["Paul Henreid"],
        ["John Qualen"],
        ["Curt Bois"],
        ["Conrad Veidt"],
        ["Madeleine LeBeau"]
      )
    end
  end

  describe "alien_cast" do
    it "selects the cast of the film Alien" do
      expect(alien_cast).to contain_exactly(
        ["Sigourney Weaver"],
        ["Ian Holm"],
        ["Harry Dean Stanton"],
        ["Tom Skerritt"],
        ["John Hurt"],
        ["Veronica Cartwright"],
        ["Yaphet Kotto"]
      )
    end
  end
end
