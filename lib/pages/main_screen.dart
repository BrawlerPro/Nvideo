import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hentai_reader_love/model/user_model.dart';
import 'package:hentai_reader_love/pages/login.dart';
// import 'package:hentai_reader_love/pages/links.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:hentai_reader_love/model/linkfolder.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int? summ;
  int _currentIndex = 0;
  late String _userWrote;
  late String _notice;
  late String _userComment;
  String? queryText = '';
  Stream? streamQurey ;
  late String _Price;
  late String _Image;
  var position = const Text('Statistics', style: TextStyle(fontSize: 23,
      fontWeight: FontWeight.bold,
      fontFamily: 'BhuTukaExpandedOne-Regular'));

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  // void _menuOpen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const Seitings()),
  //   );
  // }


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
    initFireabase();
    _tabController = TabController(length: 3, vsync: this);
  }
  Future getTotal() async {
    int? sum = 0;
    FirebaseFirestore.instance.collection('users/${loggedInUser.uid}/codes').get().then(
          (querySnapshot) {
        for (var result in querySnapshot.docs) {
          sum = (sum! + int.parse(result.data()['price']));
        }
        summ = sum;
      },
    );
  }
  // void _launchURL(_url) async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(loggedInUser.uid)
  //       .collection('links')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     if (querySnapshot.docs.isEmpty) {
  //       Fluttertoast.showToast(
  //         msg: 'Please add site link example: https://nhentai.com/g/',
  //         timeInSecForIosWeb: 7,
  //       );
  //     } else {
  //       //launch('$lonink$_url');
  //     }
  //   });
  // }
  @override
  Widget build(BuildContext context) {


    final List _children = <Widget>[

      Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            stream:
            FirebaseFirestore.instance.collection('items').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('You no have mission');
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child:
                                  ListTile(
                                    title: Center(child: Text(
                                        snapshot.data!.docs[index].get('item')),),
                                    subtitle: Text(
                                      snapshot.data!.docs[index].get('comment'),
                                    ),
                                  ),
                                ),
                                Text('${snapshot.data!.docs[index].get('price')}₽')
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(snapshot.data!.docs[index].get('ImageUrl'), fit: BoxFit.fill),
                                ),
                                IconButton(onPressed: (){
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(loggedInUser.uid)
                                      .collection('codes')
                                      .add({
                                    'item': snapshot.data!.docs[index].get('item'),
                                    'comment': snapshot.data!.docs[index].get('comment'),
                                    'price': snapshot.data!.docs[index].get('price'),
                                    'ImageUrl': snapshot.data!.docs[index].get('ImageUrl')
                                  });
                                }, icon: const Icon(Icons.heart_broken))
                              ],
                            )
                          ],
                        ),
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
                          scrollable: true,
                          title: const Text('Add youre Code'),
                          content: Column(children: <Widget>[
                            Column(children: <Widget>[
                              TextField(
                                onChanged: (String value) {
                                  _userWrote = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Write name product',
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              TextField(
                                onChanged: (String svalue) {
                                  _userComment = svalue;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Write youre comment',
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: <Widget>[
                                TextField(
                                  onChanged: (String value) {
                                    _Price = value;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                                TextField(
                                  onChanged: (String value) {
                                    _Image = value;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Image Url',
                                  ),
                                  textInputAction: TextInputAction.done,
                                ),
                                TextField(
                                  onChanged: (String svalue) {
                                    _notice = svalue;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Write type',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ],
                            )
                          ],
                          ),
                          actions: [
                            FloatingActionButton(
                              backgroundColor: Colors.orange,
                              splashColor: Colors.white,
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .add({
                                  'item': _userWrote,
                                  'comment': _userComment,
                                  'price': _Price,
                                  'ImageUrl': _Image,
                                  'notice': _notice
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
      ),
      Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(loggedInUser.uid)
              .collection('codes')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>  snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child:
                                ListTile(
                                  title: Center(child: Text(
                                      snapshot.data!.docs[index].get('item')),),
                                  subtitle: Text(
                                    snapshot.data!.docs[index].get('comment'),
                                  ),
                                ),
                              ),
                              Text('${snapshot.data!.docs[index].get('price')}₽')
                            ],
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.red,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(snapshot.data!.docs[index].get('ImageUrl'), fit: BoxFit.fill),
                          ),
                        ],
                      ),
                    ),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(loggedInUser.uid)
                          .collection('codes')
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                    },
                  );
                });
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
                  getTotal();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Payment'),
                          content:Text('The cost of the order $summ ₽'),
                          actions: [
                            FloatingActionButton(
                              backgroundColor: Colors.orange,
                              splashColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.credit_card),
                            )
                          ],
                        );
                      });
                },
                child: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          )
      ),
      Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (String value) {
              setState(() {
                queryText = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Search...',
            ),
            textInputAction: TextInputAction.search,
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("items")
              .where("notice", isGreaterThanOrEqualTo: queryText )
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>  snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child:
                                ListTile(
                                  title: Center(child: Text(
                                      snapshot.data!.docs[index].get('item')),),
                                  subtitle: Text(
                                    snapshot.data!.docs[index].get('comment'),
                                  ),
                                ),
                              ),
                              Text('${snapshot.data!.docs[index].get('price')}₽')
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network(snapshot.data!.docs[index].get('ImageUrl'), fit: BoxFit.fill),
                              ),
                              IconButton(onPressed: (){
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(loggedInUser.uid)
                                    .collection('codes')
                                    .add({
                                  'item': snapshot.data!.docs[index].get('item'),
                                  'comment': snapshot.data!.docs[index].get('comment'),
                                  'price': snapshot.data!.docs[index].get('price'),
                                  'ImageUrl': snapshot.data!.docs[index].get('ImageUrl')
                                });
                              }, icon: const Icon(Icons.heart_broken))
                            ],
                          )
                        ],
                      ),
                    );

                });
          },
        ),
      ),
      Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 100,
                  width: 150,
                  child: Image.asset('assets/mvideo.png', fit: BoxFit.fill,),
                ),
                Column(children:const [
                  ListTile(
                    title: Text('Seitings',),
                  ),
                ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      title: const Text('LogOut',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () {
                        logout(context);
                      },
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Image.asset("assets/mvideo.png",
                        fit: BoxFit.contain)),
                Text(
                  'Welcome Back ${loggedInUser.name} !',
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${loggedInUser.email}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('${loggedInUser.uid}'),
              ],
            ),
          ),
        ),
      ),
    ];
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.red,
        backgroundColor: Colors.white,
        height: 50,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: const [
          Icon(Icons.shopping_bag_outlined),
          Icon(Icons.shopping_cart_outlined),
          Icon(Icons.search),
          Icon(Icons.account_circle_outlined),
        ],
      ),
    );
  }
}


void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      //message to show toast
      toastLength: Toast.LENGTH_LONG,
      //duration for message to show
      gravity: ToastGravity.CENTER,
      //where you want to show, top, bottom
      timeInSecForIosWeb: 1,
      //for iOS only
      //backgroundColor: Colors.red, //background Color for message
      textColor: Colors.white,
      //message text color
      fontSize: 16.0 //message font size
  );
}


Future<void> logout(BuildContext context) async
{
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
}

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;