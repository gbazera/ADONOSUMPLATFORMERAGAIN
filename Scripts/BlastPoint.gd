extends Area2D

func _on_BlastPoint_body_entered(body:Node):
	if body is Player:
		body.blast_point += 1
		queue_free()