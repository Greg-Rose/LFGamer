class PropagateDatabase
  def self.initial_seed
    seed_starting_consoles
  end

  private

  def seed_starting_consoles
    starting_consoles = [
      ["PlayStation 4", "PS4"],
      ["PlayStation 3", "PS3"],
      ["Xbox One"],
      ["Xbox 360"]
    ]

    starting_consoles.each do |console|
      new_console = Console.new(name: console[0])
      new_console.abbreviation = console[1] if console[1]
      new_console.save
    end
  end
end
