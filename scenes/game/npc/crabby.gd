extends CharacterBody2D
## Clase que controla animación y configuración del NPC
##
## Setea la animación y comportamiento del NPC 


# Acciones del NPC
@export_enum(
	"idle",
	"run", 
) var animation: String

# Variable para control de animación
@onready var _animation := $NpcAnimation
@onready var _raycast := $Area2D/RayCast2D

var _gravity = 10
var _speed = 25
var moving_left = true


# Función de inicialización
func _ready():
	if not animation:
		return
	_animation.play(animation)
	
	
func _process(delta):
	_move_character()
	_turn()
	
	
func _move_character():
	velocity.y += _gravity 
	
	if moving_left:
		velocity.x = - _speed 
	else:	
		velocity.x = _speed 
			
	move_and_slide()


func _on_area_2d_body_entered(body):
	print("atacar")
	
	
func _turn():
	if not _raycast.is_colliding():
		moving_left = !moving_left
		scale.x = -scale.x
