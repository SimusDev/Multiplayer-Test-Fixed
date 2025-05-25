extends Control

@export var team_button_scene: PackedScene
@onready var grid_container: GridContainer = $Panel/CenterContainer/GridContainer

func _ready() -> void:
	var teams: CSG_Teams = G_CounterStrike.instance.teams
	for team in teams.list:
		var button: Button = team_button_scene.instantiate()
		button.resource = team
		button.pressed.connect(_on_team_button_pressed.bind(teams, team))
		grid_container.add_child(button)

func _on_team_button_pressed(teams: CSG_Teams, team: R_CS_Team) -> void:
	$C_UIInterfaceComponent.close()
	teams.select_team(team)
