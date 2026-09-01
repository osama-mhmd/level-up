# class_name InteractiveElement
extends Node2D

var activated_count = 0

@onready var boss := $"../Boss"

func trigger():
	print(boss)
	activated_count += 1
	if activated_count == 3:
		if boss and boss.has_method("damage"):
			boss.damage()
			print("H")
		activated_count = 0
		$"../LeverSwitch".reset()
		$"../LeverSwitch2".reset()
		$"../LeverSwitch3".reset()
