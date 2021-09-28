import sys, json, os
from cursesmenu import *
from cursesmenu.items import *

def clear():
    import os
    if os.name == 'nt': _ = os.system('cls')
    else: _ = os.system('clear')

def makemenu(list, title='Please Select One', index=False):
    list.append('EXIT')
    menu = SelectionMenu(list, title=title, show_exit_option=False)
    resp = menu.get_selection(list, title=title, exit_option=False)
    if index:
        return resp
    else:
        return list[resp]

def jsonsave(data, filename = 'interactables.json', path = ''):
    print(filename)
    print(data)
    if path == '':
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent = 4, separators=(',', ': '))
    else:
        with open(os.path.join(path, filename), 'w', encoding='utf-8') as f:
            json.dump(data, f, indent = 4, separators=(',', ': '))

def camera_editor(data, filename, path):
    stage = 0
    while True:
        if not stage:
            roomlist = list(data.keys())
            roomlist.append("ADD ROOM")
            roomlist.append("REMOVE ROOM")
            room=makemenu(roomlist, 'Which ROOM would you like to EDIT?')
            stage = 1
        if room == 'EXIT': return 0
        if room == 'ADD ROOM':
            print("Type the NAME for the new DIALOGUE")
            newroom = input(":")
            data[newroom] = {}
            jsonsave(data, filename, path)
            stage = 0; continue
        if room == 'REMOVE ROOM':
            rmroomlist = list(data.keys())
            rmroomlist.append("BACK")
            rmroom = makemenu(rmroomlist, 'Which DIALOGUE would you like to REMOVE?')
            if rmroom == 'EXIT': return 0
            if rmroom == 'BACK': continue
            data.pop(rmroom, None)
            jsonsave(data, filename, path)
            stage = 0; continue
        if stage == 1:
            limitlist = list(data[room].keys())
            if not len(limitlist) >= 4:
                limitlist.append('ADD LIMIT')
            if len(limitlist) != 0:
                limitlist.append('REMOVE LIMIT')
            limitlist.append('BACK')
            limit = makemenu(limitlist, 'Which CAMERA LIMIT would you like to EDIT?')
        if limit == 'EXIT': return 0
        if limit == 'BACK': stage = 0; continue
        if limit == 'ADD LIMIT':
            limit_opts = ["limit_l", "limit_r", "limit_t", "limit_b"]; addlimitlist = []
            for i in limit_opts:
                if i not in list(data[room].keys()):
                    addlimitlist.append(i)
                    print(addlimitlist)
            addlimitlist.append("BACK")
            limit = makemenu(addlimitlist, 'Which CAMERA LIMIT would you like to ADD?')
            if limit == 'EXIT': return 0
            if limit == 'BACK': stage = 1; continue
        if limit == 'REMOVE LIMIT':
            rmlimitlist = list(data[room].keys())
            rmlimitlist.append("BACK")
            rmlimit = makemenu(rmlimitlist, 'Which DIALOGUE would you like to REMOVE?')
            if rmlimit == 'EXIT': return 0
            if rmlimit == 'BACK': stage = 1; continue
            data[room].pop(rmlimit, None)
            jsonsave(data, filename, path)
            stage = 1; continue
        print("Enter BACK to go back, EXIT to quit:")
        print("Enter the new value of "+limit+":")
        cur = ""
        if limit in data[room]:
            cur = "[" + str(data[room][limit]) + "]"
        value = input("\n\n"+cur+":")
        if value.upper() == 'EXIT': return 0
        if value.upper() == 'BACK': stage = 1; continue
        data[room][limit]=int(value)
        jsonsave(data, filename, path)




def diolouge_editor(data, filename, path):
    stage = 0
    emotelist = ["mad", "quizz", ""]
    while True:
        if not stage:
            diolougelist = list(data.keys())
            diolougelist.append("ADD DIALOGUE")
            diolougelist.append("REMOVE DIALOGUE")
            diolouge=makemenu(diolougelist, 'Which DIALOGUE would you like to EDIT?')
            stage = 1
        if diolouge == 'EXIT': return 0
        if diolouge == 'ADD DIALOGUE':
            print("Type the NAME for the new DIALOGUE")
            newdiolouge = input(":")
            data[newdiolouge] = {}
            diolouge = newdiolouge
            jsonsave(data, filename, path)
        if diolouge == 'REMOVE DIALOGUE':
            rmdiolougelist = list(data.keys())
            rmdiolougelist.append("BACK")
            rmdiolouge = makemenu(rmdiolougelist, 'Which DIALOGUE would you like to REMOVE?')
            if rmdiolouge == 'EXIT': return 0
            if rmdiolouge == 'BACK': stage = 0; continue
            data.pop(rmdiolouge, None)
            jsonsave(data, filename, path)
            stage = 0; continue
        if 'Dialogue_Lines' in data[diolouge]:
            if stage == 1:
                opts = []
                for i in data[diolouge]['Dialogue_Lines'].keys():
                    emotion = ''
                    if 'Emotion' in data[diolouge]['Dialogue_Lines'][i]:
                        emotion = '!' + data[diolouge]['Dialogue_Lines'][i]["Emotion"] + ':  '
                    opts.append(emotion + data[diolouge]['Dialogue_Lines'][i]["Line"])
                opts.append('ADD LINE')
                opts.append('REMOVE LINE')
                opts.append('BACK')
                linesopt = makemenu(opts, 'Which LINE would you like to EDIT?', index = True)
                stage = 2
            if opts[linesopt] == 'BACK': stage = 0; continue
            if opts[linesopt] == 'EXIT': return 0
            if opts[linesopt] == 'ADD LINE':
                data[diolouge]['Dialogue_Lines'][str(len(data[diolouge]['Dialogue_Lines'].keys()))] = {"Line": ''}
                jsonsave(data, filename, path)
                stage = 1; continue
            if opts[linesopt] == 'REMOVE LINE':
                opts2 = []
                for i in data[diolouge]['Dialogue_Lines'].keys():
                    emotion = ''
                    if 'Emotion' in data[diolouge]['Dialogue_Lines'][i]:
                        emotion = '!' + data[diolouge]['Dialogue_Lines'][i]["Emotion"] + ':  '
                    opts2.append(emotion + data[diolouge]['Dialogue_Lines'][i]["Line"])
                opts2.append('BACK')
                rmlinesopt = makemenu(opts2, 'Which LINE would you like to REMOVE?', index = True)
                if opts2[rmlinesopt] == 'BACK': stage = 1; continue
                if opts2[rmlinesopt] == 'EXIT': return 0
                data[diolouge]['Dialogue_Lines'].pop(str(rmlinesopt), None)
                jsonsave(data, filename, path)
                stage = 1; continue
            clear()
            if stage == 2:
                cur = data[diolouge]['Dialogue_Lines'][str(linesopt)]
                whch_edit = makemenu(["Line", "Emotion", "BACK"], 'Would you like to EDIT the LINE or the EMOTION?')
                stage = 3
            if whch_edit == 'BACK': stage = 1; continue
            if whch_edit == 'EXIT': return 0
            if whch_edit == 'Emotion': cur['Emotion'] = ""
            print("Print BACK to go back, EXIT to exit, or type a new "+whch_edit.upper()+" to replace this one:")
            print("the "+whch_edit.upper()+" is: " + cur[whch_edit])
            if whch_edit == 'Emotion':
                defaults = emotelist
            else:
                defaults = ''
            resp = input(str(defaults)+':')
            if resp.upper() == "BACK": stage = 2; continue
            if resp.upper() == "BACK": return 0
            if whch_edit == 'Emotion' and resp == '':
                cur.pop(whch_edit, None)
            else:
                cur[whch_edit] = resp
            jsonsave(data, filename, path)
            stage = 1; continue
        else:
            create_line = makemenu(["YES", "NO"], 'There are no LINES in ' + diolouge + '.  Would you like to create one?', index = True)
            if create_line == 2: return 0
            if create_line: stage = 0; continue
            if not create_line:
                clear()
                print('Please type the LINE:')
                LINE = input(':')
                print(diolouge, data, data[diolouge])
                data[diolouge]["Dialogue_Lines"] = {}
                data[diolouge]["Dialogue_Lines"][str(0)] = {}
                data[diolouge]["Dialogue_Lines"][str(0)]['Line'] = LINE
                jsonsave(data, filename, path)
                clear()
                while True:
                    print("Please type the EMOTION.  Leave blank for idle")
                    EMOTION = input(str(emotelist) + ':')
                    if not EMOTION in emotelist:
                        EMOTION = 0
                        print("That EMOTION is not recognised! please use one of the following: " + emotelist)
                        continue
                    else:
                        if EMOTION == '':
                            break
                        else:
                            data[diolouge]["Dialogue_Lines"][str(0)]['Emotion'] = EMOTION
                            jsonsave(data, filename, path)
                            break
                stage = 0; continue




def parsejson(filename='interactables.json', path=''):
    if path == '':
        if os.path.isfile(filename):
            with open(filename, 'r') as f:
                data = json.load(f)
        else:
            with open(filename, 'w') as f:
                f.write('{}'); data = {}

    else:
        if os.path.isfile(os.path.join(path, filename)):
            with open(os.path.join(path, filename), 'r') as f:
                data = json.load(f)
        else:
            with open(os.path.join(path, filename), 'w') as f:
                f.write('{}'); data = {}
    if filename == "interactables.json":
        return diolouge_editor(data, filename, path)
    if filename == "camera_limits.json":
        return camera_editor(data, filename, path)

def choosefile():
    parsejson(makemenu(['interactables.json', "camera_limits.json"], title='Which FILE would you like to EDIT?'))

def parsesysargs(indict, dict):
        for i in indict:
            k,v = i.split('=',1)
            if v == 'True': v=True
            if v == 'False': v=False
            dict[k] = v
        return dict
def sysargs():
        import sys
        arg = None; arglist = []; argopts = {}
        for i in sys.argv[1:]:
            if i[0] == '-':
                if not i[1:] in arglist: arg = i[1:]; arglist.append(arg); argopts[arg]=[]
                else: arg = i[1:]
            else: argopts[arg].append(i)
        if len(arglist) == 0:
            choosefile()
        if 'f' in arglist:
            parsejson(argopts['f'][0])

if __name__ == '__main__':
    sysargs()
