extends Resource 
class_name FighterInfo

enum Archetype {
	Rushdown,
	Shoto,
	Grappler,
	Zoner,
	Puppet
}

enum Difficulty {
	Beginner,
	Intermediate,
	Expert,
	Veteran
}

enum WeightClass {
	Normal,
	Slim,
	Heavy,
}

export var _c_About = 0
export(ImageTexture) var portrait = null
export(ImageTexture) var button_portrait = null
export(ImageTexture) var select_portrait = null
export(String) var name = ''
export(Difficulty) var difficulty = Difficulty.Beginner
export(Archetype) var archetype = Archetype.Rushdown
export(String) var description = ''

export var _c_Quotes = 0
export(Array, String) var battle_quotes = []
export(Array, String) var victory_quotes = []

export var _c_Command_List = 0
export(Array, Dictionary) var command_normals
export(Array, Dictionary) var command_specials
export(Array, Dictionary) var special_inputs
export(Array, Dictionary) var power_moves

export var _c_Stats = 0
export(int, 0, 20000) var health = 10000
export(WeightClass) var weight_class = WeightClass.Normal
export(int, 0, 5) var guts = 0
export(float, 0.0, 2.0) var defense = 1.0
export(float, 0.0, 2.0) var mana = 1.0
 
export var _c_Mods = 0
export(Array, ImageTexture) var pallettes = []
