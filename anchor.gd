## URLs starting with a hash character are searched for as anchors in
## the document.  Eg:
##
##    `...[url=#id]link text[/url]...[anchor=id][/anchor]...`
##
## URLs starting with `http://mkp.ca/raceteroids/event?` are
## interpreted as game configurations and get plugged into the
## interface.

extends RichTextLabel
class_name AnchoredLabel

const anchor_template:String = "[anchor id={0}]"
const test_text:String = "\
[url=#anchor0]This is a link[/url]
[url=#anchor1]This is a link[/url]
[url=#anchor2]This is a link[/url]
[url=#anchor3]This is a link[/url]
[url=#anchor4]This is a link[/url]
[url=#anchor5]This is a link[/url]
[url=#anchor6]This is a link[/url]
[url=#anchor7]This is a link[/url]
[url=#anchor8]This is a link[/url]
[url=#anchor9]This is a link[/url]
[anchor id=anchor0]This is an anchor[/anchor]
[anchor id=anchor1]This is an anchor[/anchor]
[anchor id=anchor2]This is an anchor[/anchor]
[anchor id=anchor3]This is an anchor[/anchor]
[anchor id=anchor4]This is an anchor[/anchor]
[anchor id=anchor5]This is an anchor[/anchor]
[anchor id=anchor6]This is an anchor[/anchor]
[anchor id=anchor7]This is an anchor[/anchor]
[anchor id=anchor8]This is an anchor[/anchor]
[anchor id=anchor9]This is an anchor[/anchor]"

class RichTextAnchor:
	extends RichTextEffect
	# Syntax: [anchor id=id][/anchor]
	const bbcode := "anchor"
	func _process_custom_fx(_char_fx):
		return true

func _ready():
	# The [anchor] tag has the same effect as the [url] tag on the
	# character offsets, but commenting out the following line does
	# not fix the character offsets
	install_effect(RichTextAnchor.new())
	meta_clicked.connect(_on_meta_clicked)
	text = test_text

func _on_meta_clicked(meta:String):
	if meta[0] == '#':
		scroll_to_anchor(meta.substr(1))

func scroll_to_anchor(anchor) -> void:
	var index := text.find(anchor_template.format([anchor]))
	if index < 0:
		assert(index >= 0, "Missing anchor")
		return

	# Both of these result in incorrect offsets, possibly -1
	var line := get_character_line(index)
	var para := get_character_paragraph(index)

	assert(line != -1, "Anchor has no line")
	assert(para != -1, "Anchor has no paragraph")

	# Neither of these will find the correct locataion even when not given -1
	#scroll_to_line(line)
	scroll_to_paragraph(para)
