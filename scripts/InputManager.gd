extends Node
#Control modes
enum ControlMode {
	GAMEPLAY,
	UI,
	INTERACTING,
	DISABLED
}

#current mode
var currentMode: ControlMode = ControlMode.DISABLED

#control change signal
signal control_mode_changed(new_mode: ControlMode)

func set_control_mode(mode: ControlMode) -> void:
	if mode != currentMode:
		currentMode = mode
		emit_signal("control_mode_changed", mode)

func is_mode_gameplay() -> bool:
	return currentMode == ControlMode.GAMEPLAY
