import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet_app/backend/database.dart';

class fillupform extends StatefulWidget {
  @override
  fillupstate createState() => fillupstate();
}
class Userdata{
  String username="";
  dynamic nickname="";
}

class fillupstate extends State<fillupform> {
  

//__json file creation_____________Siraj
/* storing json file,displaying on the app screen as text */
  File jsonfile;
  Directory dir;
  String filename="mine.json"; //name for json file
  bool fileExists = false;
  Map<String, dynamic> filecontent;

  @override
  void initState(){
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonfile = new File(dir.path+"/"+ filename);
      fileExists = jsonfile.existsSync();
      if(fileExists)this.setState(() => filecontent = jsonDecode(jsonfile.readAsStringSync()));
          

        });

  }


  void createfile(Map<String, dynamic> content, Directory dir, String filename){
    print("creating file");
    print(content);
    print(dir.path);
   
    File file=new File(dir.path+"/"+filename);
    
    
    
    file.createSync();
    file.writeAsStringSync(jsonEncode(content));
    print(file.readAsStringSync());
    
    fileExists=true;
    
  }
  bool view(){
    if(fileExists){
      print("User existss");
      return true;
      }//if ends
    else{
        print("User does not exists");
        return false;
    }
  }

  void writeToFile(String key, dynamic value){
    print("writing to the file");
    Map<String, dynamic> content ={key: value};
    if(fileExists){
      print("file existss");
      Map<String, dynamic> jsonfilecontent = json.decode(jsonfile.readAsStringSync());

      jsonfilecontent.addAll(content);
      jsonfile.writeAsStringSync(jsonEncode(jsonfilecontent));
    }//if ends
    else{
      //if file not exists
      print("file does not exists");
      createfile(content,dir, filename);
    }
    this.setState(() =>filecontent = jsonDecode(jsonfile.readAsStringSync()));
  }
//__json file creation END_____________Siraj
 
 
  //Appbody
  final _formKey = GlobalKey<FormState>();
  Userdata data= new Userdata();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
          child:Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(filecontent.keys.toString()+filecontent.values.toString() ), //displaying jsonfile content
                
                TextFormField(
                  validator: (value){
                    if(value.isEmpty){
                      return 'please enter some text';
                    }
                  },
                  onSaved: (value){
                    data.nickname=value;
                  },
                ),
                RaisedButton(
                  onPressed: (){
                    if (_formKey.currentState.validate()) {
                     _formKey.currentState.save();
                     writeToFile("username", data.nickname);
                     dbc();
                    }
                  },
                  child: Text('continue'),
                ),
              ],
            ),
          )
      )
    );
  }
}