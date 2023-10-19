extends Node2D
## Clase que controla los eventos de diálogos de parte de NPC 
## 
## Se controlan los eventos de inicio y finalización de diálogos de parte de NPC


# Definición de la señal del diálogo
signal talk()

# Definición de la señal del diálogo terminado
signal dialogue_ended()
# Señal que escucha cuando se selecciona una respuesta de diálogo
signal response_selected(response: String)

# El NPC, es el que tendrá un diálogo cargado, para comunicarse con el personaje principal
@export var dialogue_resource: DialogueResource
# Definición del inicio del diálogo
@export var dialogue_start: String = "start"
# Definición del template del diálogo
@export var Balloon: PackedScene
# Definición del template del diálogo
@export var area: Area2D
# Definición del personaje principal
@export var npc: CharacterBody2D

# Definimoa el nodo del personaje principal
var character: Node2D

# Función de inicialización
func _ready():
	# Inicialización del diálogo
	talk.connect(_show_dialogue)
	area.body_entered.connect(_body_entered)


# Seteamos un nuevo diálogo y lo mostramos
func set_and_show_dialogue(resource: DialogueResource):
	set_dialogue(resource)
	_show_dialogue()


# Seteamos un nuevo diálogo
func set_dialogue(resource: DialogueResource):
	dialogue_resource = resource


# Mostramos el diálogo
func _show_dialogue():
	# Inicialización del template del diálogo
	var balloon: Node = (Balloon).instantiate()
	# Agtregar el código inicaliazado a la escena
	get_tree().current_scene.add_child(balloon)
	# Abrir diálogo
	balloon.start(dialogue_resource, dialogue_start)

	# Escuchamos cuando el diálogo termine
	balloon.on_dialogue_ended(_npc_dialogue_ended)
	balloon.on_response_selected(_on_response_selected)
	# deshabilitamos al personaje principal
	character.set_disabled(true)
	character.set_idle()


# Se emite la señal de finalización del diálogo
func _npc_dialogue_ended():
	self.emit_signal("dialogue_ended")
	# Habilitamos al personaje principal
	character.set_disabled(false)


# Se emite la señal cuando se selecciona respuesta en el diálogo
func _on_response_selected(response: String):
	self.emit_signal("response_selected", response)


# Se añade evento para escuchar cuando el diálogo finalice
func on_dialogue_ended(fn):
	dialogue_ended.connect(fn)


# Se añade evento para escuchar cuando el diálogo finalice
func on_response_selected(fn):
	response_selected.connect(fn)


func _body_entered(body):
	# Validamos si la colisión es con el personaje principal
	if body.is_in_group("player"):
		# Accedemos al script
		character = body.get_node("MainCharacterMovement")
		# Mostramos el diálogo
		_show_dialogue()
		# Buscamos el nodo de animación
		var _npc_animation: AnimatedSprite2D = npc.find_child('Npc')
		# Giramos el personaje para ver hacia la izquierda o derecha
		if body.global_position.x < area.global_position.x:
			_npc_animation.flip_h = true
		else:
			_npc_animation.flip_h = false
