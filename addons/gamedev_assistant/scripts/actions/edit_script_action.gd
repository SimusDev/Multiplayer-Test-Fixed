                                                                      
@tool
extends Node

const vvqhrrgm = preload("action_parser_utils.gd")

static func execute(kxudrjgu: String, xhbuccme: int, twuibvld: Button, ssgmbuuc: Node) -> bool:
                                      
    var wjuenevi = FileAccess.open(kxudrjgu, FileAccess.READ)
    if not wjuenevi:
        push_error("Failed to load script: " + kxudrjgu + " (Error: " + str(FileAccess.get_open_error()) + ")")
        return false
    
                                
    var vbobiodr = wjuenevi.get_as_text()
    wjuenevi.close()
        
                           
    ssgmbuuc.rljxqqys(kxudrjgu, xhbuccme, vbobiodr, twuibvld)
    return true

static func parse_line(sawnmntj: String, msbikqli: String) -> Dictionary:
    if sawnmntj.begins_with("edit_script("):
        var pyegsghp = vvqhrrgm.fenzktne(sawnmntj)
        if not pyegsghp.is_empty():
            return {
                "type": "edit_script",
                "path": pyegsghp.get("path", ""),
                "message_id": pyegsghp.get("message_id", -1)
            }
    return {}
