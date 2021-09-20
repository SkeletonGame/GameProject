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
            json.dump(data, f, indent=4, separators=(',', ': '))
    else:
        with open(os.path.join(path, filename), 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4, separators=(',', ': '))

def editor(data, filename, path):
    stage=0
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
            diolougelist.append("BACK")
            rmdiolouge=makemenu(rmdiolougelist, 'Which DIALOGUE would you like to REMOVE?')
            if rmdiolouge == 'EXIT': return 0
            if rmdiolouge == 'BACK': stage = 0; continue
            data.pop(rmdiolouge, None)
            jsonsave(data, filename, path)
            stage = 0; continue
        if 'Dialogue_Lines' in data[diolouge]:
            if stage == 1:
                opts=[]
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
                    EMOTION = input(str(emotelist)+':')
                    if not EMOTION in emotelist:
                        EMOTION = 0
                        print("That EMOTION is not recognised! please use one of the following: "+emotelist)
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
        with open(filename, 'r') as f:
            return editor(json.load(f), filename, path)
    else:
        with open(os.path.join(path, filename)) as f:
            return editor(json.load(f), filename, path)


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
            parsejson()
        if 'f' in arglist:
            parsejson(argopts['f'])

if __name__ == '__main__':
    sysargs()
