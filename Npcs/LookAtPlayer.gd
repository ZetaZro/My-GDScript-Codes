extends Node3D

##Player Here
@export var Plr : CharacterBody3D

##BoneAttachment
@export var BoneAT : BoneAttachment3D

##Area 3D
@export var Ar3d: Area3D

##Can Look At Player?
@export var LookAtPlr : bool = true

##OFFSETS For making the head not turn 180 unless you want that :b
@export var NEGATIVERotOffSetY = -1.5
@export var POSITIVERotOffSetY = 1.5

@export var NEGATIVERotOffSetX = -1.5
@export var POSITIVERotOffSetX = 0.7

##Optionals
@export var UpDirection : Vector3 = Vector3.UP
@export var FrontOfModel : bool = true


var ResetPose
var Error = false
var PlayerEntered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if not Plr or not BoneAT or not Ar3d:
		Error = true
		print("WARNING : NO PLAYER OR BONE AT")
	else:
		ResetPose = Ar3d.rotation
		Ar3d.body_entered.connect(self.BodyEnt)
		Ar3d.body_exited.connect(self.BodyExit)
func BodyExit(body):
	if body != null:
		if body == Plr:

			PlayerEntered = false
func BodyEnt(body):
	if body != null:
		if body == Plr:
			PlayerEntered = true

func _process(delta: float) -> void:
	if LookAtPlr and not Error:

		if PlayerEntered == true:
			if BoneAT.override_pose == false:
				BoneAT.override_pose = true
			var Exp = BoneAT.global_transform.looking_at(Plr.global_position,UpDirection,FrontOfModel)
			BoneAT.global_transform = BoneAT.global_transform.interpolate_with(Exp,0.05)
			var ClampX = clampf(BoneAT.rotation.x,NEGATIVERotOffSetX,POSITIVERotOffSetX)
			var ClampY = clampf(BoneAT.rotation.y,NEGATIVERotOffSetY,POSITIVERotOffSetY)
			BoneAT.rotation.x = ClampX
			BoneAT.rotation.y = ClampY
		else:
			BoneAT.rotation = BoneAT.rotation.lerp(ResetPose,0.05)
	elif not LookAtPlr:
		if BoneAT.override_pose == true:
			BoneAT.rotation = ResetPose
			BoneAT.override_pose = false
			
