@tool
@icon ("res://addons/at-icons/node2d/dot_grid.svg")
class_name EnemyGroup extends Node2D

# Perguntar sobre isso aqui
enum EnemyType { REGULAR, LIGHTING_SHOOTER, CROSS_SHOOTER }
const EnemyTypeScene: Dictionary[EnemyType, PackedScene] = {
	EnemyType.REGULAR: preload("res://scenes/entities/enemies/regular_enemy.tscn"),
	EnemyType.LIGHTING_SHOOTER: preload("res://scenes/entities/enemies/shooters/lightning_shooter.tscn"),
	EnemyType.CROSS_SHOOTER: preload("res://scenes/entities/enemies/shooters/cross_shooter.tscn")
}

@export_category("Position Preview")
@export var show_position_preview: bool = true:
	set(new_show_position_preview):
		show_position_preview = new_show_position_preview
		if show_position_preview:
			show_calculated_positions()
		else:
			if is_instance_valid(preview_node):
				preview_node.queue_free()

@export var show_position_preview_logs: bool = true

@export_category("Configuration")
@export var enemy_type: EnemyType = EnemyType.REGULAR:
	set(new_enemy_type):
		enemy_type = new_enemy_type
		if Engine.is_editor_hint():
			show_calculated_positions()


@export_category("Group Characteristics")
@export var rows: int = 2:
	set(new_rows):
		rows = new_rows
		if Engine.is_editor_hint():
			show_calculated_positions()

@export var enemies_per_row:int = 10:
	set(new_enemies_per_row):
		enemies_per_row = new_enemies_per_row
		if Engine.is_editor_hint():
			show_calculated_positions()

@export var horizontal_gap_size: int = 60:
	set(new_horizontal_gap_size):
		horizontal_gap_size = new_horizontal_gap_size
		if Engine.is_editor_hint():
			show_calculated_positions()

@export var vertical_gap_size: int = 40:
	set(new_vertical_gap_size):
		vertical_gap_size = new_vertical_gap_size
		print("mudou vertical_gap_size")
		if Engine.is_editor_hint():
			show_calculated_positions()


var preview_node: Node2D = null


func _ready() -> void:
	if Engine.is_editor_hint():
		show_calculated_positions()
		visibility_changed.connect(_on_visibility_changed)
	if not Engine.is_editor_hint():
		spawn_enemies()


func _exit_tree() -> void:
	if visibility_changed.is_connected(_on_visibility_changed):
		visibility_changed.disconnect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if not is_instance_valid(preview_node):
		return
	for node in preview_node.get_children():
		node.visible = visible


func calculate_initial_position() -> Vector2:
	# A explicação do cálculo feito aqui, leva em conta o cenário para as variáveis
	# rows = 2, enemies_per_row = 10, h_gap_size = 60 e v_gap_size = 40
	
	# O primeiro termo (enemies_per_row/2) tem essa divisão pois nós centralizamos
	# o grupo de inimigos com metade para cada lado do eixo Y (5 a esquerda, 5 a direita)
	# E então fazemos o produto entre a quantidade de inimigos do lado inicial (da esquerda)
	# e o espaço horizontal entre cada inimigo, de 60 pixels.
	
	# Invertemos o valor fazendo (valor * -1), assim temos a posição inicial à esquerda
	# do eixo X.
	# ((enemies_per_row/2.0) * horizontal_gap_size) * -1
	var initial_x_position = ((enemies_per_row/2.0) * horizontal_gap_size) * -1
	
	# Como eu quero mostrar os inimigos centralizados no eixo Y, ainda precisamos
	# adicionar o valor do gap horizontal divido por 2 (horizontal_gap_size/2.0), 
	# para compensar o fato de que o ultimo inimigo à esquerda do eixo X vai estar 60 pixels 
	# a esquerda do eixo Y, fazendo com que o primeiro inimigo do lado direito do eixo X 
	# apareça colado ao eixo, o que não é estéticamente agradável.
	# e.g: 
	# Como apareceria sem essa compensação: X  X  |X  X
	# Como deve aparecer depois de compensar o gap: X  X | X  X
	#                                                   -^-
	#                                                   perceba que aqui temos
	#                                                   um espaço de 30 pixels
	#                                                   para cada lado
	# + (horizontal_gap_size/2.0)
	var initial_x_position_compensation = (horizontal_gap_size/2.0)
	
	# Assim, temos que a posição do primeiro inimigo no canto superior esquerdo
	# é de -270.0 no eixo X, assim como na versão anterior que a posição é chumbada no EnemySwarm
	var initial_x = initial_x_position + initial_x_position_compensation
	
	# O cálculo da posição Y inicial segue a mesma lógica do cálculo anterior,
	# apenas invertendo as variáveis necessárias
	var initial_y_position = rows * (vertical_gap_size/2.0) * -1
	var initial_y_position_compensation = (vertical_gap_size/2.0)
	var initial_y = initial_y_position + initial_y_position_compensation
	
	var initial_position = Vector2(initial_x, initial_y)
	return initial_position


func execute_function_for_each_calculated_position(function: Callable) -> void:
	# A ideia aqui é basicamente executar uma função durante cada posição calculada
	# dos inimigos
	# Fiz isso pois estou usando o cálculo da posição para fazer gizmos, como
	# o preview de como vai ficar os inimigos em cada posição 
	# e para treinar a parte de tooling com esse projeto
	var initial_position = calculate_initial_position()
	var current_x = initial_position.x
	var current_y = initial_position.y
	for index_y in range(0, rows):
		for index_x in range(0, enemies_per_row):
			var enemy_position = Vector2(current_x,current_y)
			function.call(enemy_position)
			current_x += horizontal_gap_size
		current_y += vertical_gap_size
		current_x = initial_position.x


func spawn_enemies() -> void:
	var initial_position = calculate_initial_position()
	print("Posicao inicial do primeiro inimigo do tipo %s: %s" % [
		EnemyType.find_key(enemy_type), initial_position
	])
	execute_function_for_each_calculated_position(spawn_enemy_at_position)


func spawn_enemy_at_position(enemy_position: Vector2) -> void:
	print("Criando inimigo do tipo %s na posicao %s " % [
		EnemyType.find_key(enemy_type), enemy_position
	])
	var enemy: Enemy = EnemyTypeScene.get(enemy_type).instantiate()
	add_child(enemy)
	enemy.position = enemy_position


func add_preview_enemy_in_position(enemy_position: Vector2) -> void:
	var enemy: Enemy = EnemyTypeScene.get(enemy_type).instantiate()
	var enemy_preview: Sprite2D = enemy.get_node("Sprite2D").duplicate()
	enemy_preview.position = enemy_position
	preview_node.add_child(enemy_preview)


func show_calculated_positions() -> void:
	if not EditorInterface.get_edited_scene_root():
		return
	if not show_position_preview or not show_position_preview_logs:
		return
	print("=====show_calculated_positions=====")
	# Valida se o nó que segura todas os sprites para preview (preview_node)
	# já existe e precisa ser limpo para não ter os sprites antes de alguma mudança 
	# de variável, ou se precisa ser criado e adicionado como filho de enemy group
	if not is_instance_valid(preview_node):
		print("Adicionando node de Preview em %s" % self.name)
		preview_node = Node2D.new()
		preview_node.name = "Enemy Group Preview Node"
		add_child.call_deferred(preview_node)
	else:
		var nodes: Array[Node] = preview_node.get_children()
		print("Limpeza e Redraw do node de preview")
		print("Qtd de Nós antes: %s" % nodes.size())
		for node in nodes:
			node.queue_free()
		preview_node.queue_redraw()
	
	# Aguarda o esvaziamento do nó a cada 0.5sec para evitar que mostre algum inimigo
	# a mais do que deveria (fiz isso defensivamente com medo de o queue_free não limpar
	# a tempo de os próximos nós serem adicionados. 
	# Nota: Parei pra pensar depois que eu poderia ter simplesmente
	# chamado um queue_redraw() no fim da função em vez de fazer isso 😋
	print("Aguardando o esvaziamento do preview_node")
	while(preview_node.get_child_count() != 0):
		await EditorInterface.get_editor_main_screen().get_tree().create_timer(0.5).timeout
	print("Preview_node esvaziado")
	
	# Auto descritivo
	print("Adicionando novos inimigos")
	execute_function_for_each_calculated_position(add_preview_enemy_in_position)
	print()
	preview_node.print_tree_pretty()
	print("Qtd de Nós atualmente: %s" % preview_node.get_child_count())
	print("=====show_calculated_positions=====")
	print()
