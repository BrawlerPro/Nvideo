import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hentai_reader_love/model/linkfolder.dart';

import '../model/user_model.dart';

class Seitings extends StatefulWidget {
  const Seitings({Key? key}) : super(key: key);

  @override
  _SeitingsState createState() => _SeitingsState();
}



class _SeitingsState extends State<Seitings> {
  late String _userWrote;
  late String _userSiteName;
  bool fisting = false;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  void initFireabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {

    // return SafeArea(child:
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream:
          FirebaseFirestore.instance.collection('users').doc(loggedInUser.uid).collection('links').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Text('You links');
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(snapshot.data!.docs[index].id),
                      child: Card(
                        child:
                        ListTile(
                          title: Text(
                              snapshot.data!.docs[index].get('sitename')),
                          onTap: () {
                            lonink = snapshot.data!.docs[index].get('link');
                          },
                          subtitle:  Text(
                            snapshot.data!.docs[index].get('link'),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(loggedInUser.uid)
                            .collection('links')
                            .doc(snapshot.data!.docs[index].id)
                            .delete();

                        //if(direction == DismissDirection.endToStart)
                      },
                    );
                  });
            }
          },
        ),
        floatingActionButton: SizedBox(
          height: 55,
          width: 55,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              splashColor: Colors.white,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add site name'),
                        content: Column(children: <Widget>[
                          TextField(
                            onChanged: (String value) {
                              _userWrote = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Write site link',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          TextField(
                            onChanged: (String svalue) {
                              _userSiteName = svalue;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Write site name',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.done,
                          )
                        ],
                        ),
                        actions: [
                          FloatingActionButton(
                            backgroundColor: Colors.orange,
                            splashColor: Colors.white,
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(loggedInUser.uid)
                                  .collection('links')
                                  .add({
                                'link': _userWrote,
                                'sitename': _userSiteName
                              });

                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.save),
                          )
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        )
    );
    //);
  }

}
