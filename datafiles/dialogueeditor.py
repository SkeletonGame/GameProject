import os
from cursesmenu import *

def loadjson(filename):
    import os, json
    file = f"{filename}.json"
    with open(file, 'r') as f:
        data = json.load(f)
    return data

def writejson(filename, data):
    import os, json
    file = f"{filename}.json"
    with open(file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, separators=(',', ': '))

def navMenu(list, title, exit = False):
    result = None
    if exit:
        result = list[SelectionMenu(list).get_selection(list, title)]
    else:
        list.append("Back")
        result = list[SelectionMenu(list).get_selection(list, title, exit_option = exit)]
    return result

local_dict = loadjson("dialogue")

scenes = []
for scene in local_dict:
    scenes.append(scene)
scenes.append("New Scene")

def main_menu():
    result = None
    result = navMenu(scenes, "Select a scene:", exit = True)
    if result == "New Scene":
        create_scene()
    elif result in local_dict:
        access_characters(result)
    else:
        print("Error: Option '" + result + "' not in dictionary (somehow). Try running the program again.")

def create_scene():
    confirmed = False
    while not confirmed:
        print("Enter the name of the scene below. Make sure that it matches the name of the scene in the GODOT editor.")
        scene_name = input()
        os.system('cls||clear')
        print("The name of the scene is '" + scene_name + "'? (y/n)")
        if input() == "y":
            confirmed = True
        os.system('cls||clear')
    local_dict[scene_name] = {}
    writejson("dialogue", local_dict)
    print("Press ENTER to redirect to character selection for this scene.")
    input()
    access_characters(scene_name)

def access_characters(scene):
    characters = []
    for character in local_dict[scene]:
        characters.append(character)
    characters.append("New Character")
    result = None
    result = navMenu(characters, "Select a character from scene '" + scene + "':")
    if result == "Back":
        main_menu()
    elif result == "New Character":
        create_character(scene)
    elif result in local_dict[scene]:
        access_dialogues(scene, result)
    else:
        print("Error: Option not in dictionary (somehow). Try running the program again.")

def create_character(scene):
    confirmed = False
    while not confirmed:
        print("Enter the name of the character below. Make sure that it matches the name of the character in the GODOT editor.")
        char_name = input()
        os.system('cls||clear')
        print("The name of the character is '" + char_name + "'? (y/n)")
        if input() == "y":
            confirmed = True
        os.system('cls||clear')
    local_dict[scene][char_name] = {
    "Interaction_Count": 0,
    "Dialogues": {}
    }
    writejson("dialogue", local_dict)
    print("Press ENTER to redirect to the dialogue editor for this character.")
    input()
    access_dialogues(scene, char_name)

def access_dialogues(scene, character):
    choice_list = ["Edit a dialogue", "Create a new dialogue", "Delete a dialogue"]
    result = navMenu(choice_list, "Scene: " + scene + " || " + "Character: " + character)
    if result == "Back":
        access_characters(scene)
    elif result == "Edit a dialogue":
        edit_dialogue(scene, character)
    elif result == "Create a new dialogue":
        create_dialogue(scene, character)
    elif result == "Delete a dialogue":
        delete_dialogue(scene_character)
    else:
        print("Error: Option not in dictionary (somehow). Try running the program again.")

def edit_dialogue(scene, character):
    dialogue_to_edit = {}
    line_of_dialogue = "0"
    dialogue_num = "0"
    if "0" not in local_dict[scene][character]["Dialogues"]:
        print("Error: There are no dialogues to be edited for this character. Press ENTER to redirect to dialogue creation.")
        input()
        create_dialogue(scene, character)
    elif "1" not in local_dict[scene][character]["Dialogues"]:
        dialogue_to_edit = local_dict[scene][character]["Dialogues"]["0"]
    else:
        choice_list = []
        for dialogue_num in local_dict[scene][character]["Dialogues"]:
            choice_list.append(dialogue_num)
        result = navMenu(choice_list, "Choose which dialogue you would like to edit:")
        if result == "Back":
            access_characters(scene)
        elif result in local_dict[scene][character]["Dialogues"]:
            dialogue_to_edit = local_dict[scene][character]["Dialogues"][result]
            dialogue_num = result
        else:
            print("Error: Option not in dictionary (somehow). Try running the program again.")
    result = "Arbitrary"
    add_info = {}
    while result != "Back":
        choice_list = ["Next Line", "Previous Line", "Edit this Line", "Add a new Line (after this one)", "Delete this Line", "Switch Speaker"]
        speaker = dialogue_to_edit[line_of_dialogue]["Speaker"]
        info_printed = ["Speaker: " + speaker]
        line = ""
        if "Line" in dialogue_to_edit[line_of_dialogue]:
            if "option_line" in add_info:
                del add_info["option_line"]
            line = dialogue_to_edit[line_of_dialogue]["Line"]
            if speaker == "Matt":
                choice_list.append("Change to Option Line")
            if "Emotion" in dialogue_to_edit[line_of_dialogue]:
                info_printed.append("Emotion: " + dialogue_to_edit[line_of_dialogue]["Emotion"])
                choice_list.append("Remove Emotion")
            else:
                choice_list.append("Add Emotion")
            if "Flag" in dialogue_to_edit[line_of_dialogue]:
                info_printed.append("Flag: " + dialogue_to_edit[line_of_dialogue]["Flag"])
                choice_list.append("Remove Flag")
            else:
                choice_list.append("Add Flag")
        elif "Options" in dialogue_to_edit[line_of_dialogue]:
            if not "option_line" in add_info:
                add_info["option_line"] = 0
            if "Emotion" in dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]:
                info_printed.append("Emotion: " + dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["Emotion"])
                choice_list.append("Remove Emotion")
            else:
                choice_list.append("Add Emotion")
            if "Flag" in dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]:
                info_printed.append("Flag: " + dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["Flag"])
                choice_list.append("Remove Flag")
            else:
                choice_list.append("Add Flag")
            line = dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["OP_Line"]
            info_printed.append("Option Line: Option (" + str(add_info["option_line"]) + "/" + str(len(dialogue_to_edit[line_of_dialogue]["Options"]) - 1) + ")")
            choice_list.insert(3, "Delete Option")
            choice_list.insert(3, "Add Option")
            choice_list.insert(2, "Next Option")
            choice_list.insert(3, "Previous Option")
            choice_list.append("Remove Options (Deletes all but option zero, which becomes the new line)")
        else:
            print("Error: Dialogue Line " + str(line_of_dialogue) + " not in character " + character + " for scene " + scene + ".")
        last_entry = ""
        for entry in dialogue_to_edit:
            last_entry = entry
        info_printed.insert(1, ("Line (" + line_of_dialogue + "/" + last_entry + "): " + line))
        info_string = ""
        for info in info_printed:
            info_string += info
            info_string += " || "
        result = navMenu(choice_list, info_string)
        if result == "Next Line" and str(int(line_of_dialogue) + 1) in dialogue_to_edit:
            line_of_dialogue = str(int(line_of_dialogue) + 1)
        elif result == "Previous Line" and str(int(line_of_dialogue) - 1) in dialogue_to_edit:
            line_of_dialogue = str(int(line_of_dialogue) - 1)
        elif result == "Edit this Line":
            print("Enter new line:")
            new_line = input()
            if "option_line" in add_info:
                dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["OP_Line"] = new_line
            else:
                dialogue_to_edit[line_of_dialogue]["Line"] = new_line
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Add a new Line (after this one)": # Stil Broken. I'm sleeping now
            backwardskeylist = []
            line_of_dialogue = str(int(line_of_dialogue) + 1)
            if line_of_dialogue in dialogue_to_edit:
                for key in dialogue_to_edit:
                    backwardskeylist.insert(0, key)
                for key in backwardskeylist:
                    dialogue_to_edit[str(int(key) + 1)] = dialogue_to_edit[key]
                    if key == line_of_dialogue:
                        break
            dialogue_to_edit[line_of_dialogue] = {"Speaker": "Matt", "Line": "Hoo Boy!"} # This Line Is Dedicated To My Insanity whilst Debugging
            print("Enter new line:")
            new_line = input()
            if "option_line" in add_info:
                dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["OP_Line"] = new_line
            else:
                dialogue_to_edit[line_of_dialogue]["Line"] = new_line
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Delete this Line":
            for key in dialogue_to_edit:
                if int(key) > int(line_of_dialogue):
                    dialogue_to_edit[str(int(key) - 1)] = dialogue_to_edit[key]
            del dialogue_to_edit[key]
            if not line_of_dialogue in dialogue_to_edit:
                line_of_dialogue = str(int(line_of_dialogue) - 1)
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Change to Option Line":
            dialogue_to_edit[line_of_dialogue]["Options"] = []
            dialogue_to_edit[line_of_dialogue]["Options"].append({"OP_Line": dialogue_to_edit[line_of_dialogue]["Line"]})
            dialogue_to_edit[line_of_dialogue]["Options"].append({"OP_Line": "New Option (Replace with line)"})
            del dialogue_to_edit[line_of_dialogue]["Line"]
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Next Option":
            if add_info["option_line"] + 1 < len(dialogue_to_edit[line_of_dialogue]["Options"]):
                add_info["option_line"] = add_info["option_line"] + 1
        elif result == "Previous Option":
            if add_info["option_line"] - 1 >= 0:
                add_info["option_line"] = add_info["option_line"] - 1
        elif result == "Add Option":
            if len(dialogue_to_edit[line_of_dialogue]["Options"]) < 4:
                dialogue_to_edit[line_of_dialogue]["Options"].append({"OP_Line": "New Option (Replace with line)"})
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Delete Option":
            if len(dialogue_to_edit[line_of_dialogue]["Options"]) > 2:
                del dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]
            if add_info["option_line"] >= len(dialogue_to_edit[line_of_dialogue]["Options"]):
                add_info["option_line"] = add_info["option_line"] - 1
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Remove Options (Deletes all but option zero, which becomes the new line)":
            dialogue_to_edit[line_of_dialogue]["Line"] = dialogue_to_edit[line_of_dialogue]["Options"][0]["OP_Line"]
            del dialogue_to_edit[line_of_dialogue]["Options"]
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Switch Speaker":
            if speaker == "Matt":
                dialogue_to_edit[line_of_dialogue]["Speaker"] = character
            elif speaker == character:
                dialogue_to_edit[line_of_dialogue]["Speaker"] = "Matt"
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Add Emotion":
            emotion = navMenu(["joy", "mad", "quizz"], "Which emotion?")
            if "Line" in dialogue_to_edit[line_of_dialogue]:
                dialogue_to_edit[line_of_dialogue]["Emotion"] = emotion
            elif "Options" in dialogue_to_edit[line_of_dialogue]:
                dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["Emotion"] = emotion
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Remove Emotion":
            if "Line" in dialogue_to_edit[line_of_dialogue]:
                del dialogue_to_edit[line_of_dialogue]["Emotion"]
            elif "Options" in dialogue_to_edit[line_of_dialogue]:
                del dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["Emotion"]
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
        elif result == "Add Flag":
            print("The only flag, as of the current version of how this stuff works, is the Skip flag.")
            print("Enter the number of the line to skip to.")
            skipnum = input()
            try:
                skipnum = int(skipnum)
                if skipnum >= 0 and skipnum <= int(last_entry):
                    if "Line" in dialogue_to_edit[line_of_dialogue]:
                        dialogue_to_edit[line_of_dialogue]["Flag"] = "Skip_" + str(skipnum)
                    elif "Options" in dialogue_to_edit[line_of_dialogue]:
                        dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["Flag"] = "Skip_" + str(skipnum)
                local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
                writejson("dialogue", local_dict)
            except:
                pass
        elif result == "Remove Flag":
            if "Line" in dialogue_to_edit[line_of_dialogue]:
                del dialogue_to_edit[line_of_dialogue]["Flag"]
            elif "Options" in dialogue_to_edit[line_of_dialogue]:
                del dialogue_to_edit[line_of_dialogue]["Options"][add_info["option_line"]]["Flag"]
            local_dict[scene][character]["Dialogues"][dialogue_num] = dialogue_to_edit
            writejson("dialogue", local_dict)
    access_dialogues(scene, character)


main_menu()
