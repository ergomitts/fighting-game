extends Node

enum CollisionType {
	Hit,
	Hurt,
	Push,
	Grab,
	Proximity
}

const CollisionColors = {
	CollisionType.Hit : Color.RED,
	CollisionType.Hurt : Color.GREEN,
	CollisionType.Push : Color.YELLOW,
	CollisionType.Grab : Color.BLUE_VIOLET,
	CollisionType.Proximity : Color.BLUE
}

enum CharacterStance {
	Standing,
	Crouching,
	Aerial,
	Knockdown
}
