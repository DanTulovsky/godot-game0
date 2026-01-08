extends "res://addons/godot_rl_agents/sync.gd"


func _ready():
    if Global.CONFIG.ai_training:
        print("setting control mode to TRAINING")
        control_mode = ControlModes.TRAINING
    else:
        print("setting control mode to ONNX_INFERENCE")
        control_mode = ControlModes.ONNX_INFERENCE

    super._ready()
