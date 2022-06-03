import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//trial hello

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //collection controller
  final _collection = TextEditingController();
  //businessname controller
  final _businessname = TextEditingController();
  //offerlink controller
  final _offerlink = TextEditingController();

  void _clearData() {
    _collection.clear();
    _businessname.clear();
    _offerlink.clear();
  }

  void _addData() async {
    //to check if all fields has answers
    if (_collection.text != "" &&
        _businessname.text != "" &&
        _offerlink.text != "") {
      //addifnotexistanddontallowifexist
      String docuid = "";
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection(_collection.text)
          .where("businessName", isEqualTo: _businessname.text)
          .get();
      for (final e in data.docs) {
        //put docid in a container for if else
        docuid = e.id.toString();
      }
      if (docuid != "") {
        //existing document will show an alertdialog
        Widget okButton = TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        );

        AlertDialog alert = AlertDialog(
          title: const Text("EXISTING"),
          content: const Text("Please Try Again"),
          actions: [okButton],
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
      } else {
        //add document if not existing
        final docbusiness =
            FirebaseFirestore.instance.collection(_collection.text).doc();

        final dataadd = {
          'businessName': _businessname.text,
          'offerLink': _offerlink.text
        };

        await docbusiness.set(dataadd);
        //alertdialog or successful transaction
        Widget okButton = TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        );

        AlertDialog alert = AlertDialog(
          title: const Text("SUCCESS"),
          content: const Text("Data Added"),
          actions: [okButton],
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
        _clearData();
      }
    } else {
      //if one or more fields are empty
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("FIELDS BLANK"),
        content: const Text("Please Try Again"),
        actions: [okButton],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

  void _deleteData() async {
    String docuid = "";
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection(_collection.text)
        .where("businessName", isEqualTo: _businessname.text)
        .get();
    for (final e in data.docs) {
      //put docid in a container for if else
      docuid = e.id.toString();
    }
    if (docuid != "") {
      FirebaseFirestore.instance
          .collection(_collection.text)
          .doc(docuid)
          .delete();
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("DELETED"),
        content: const Text("Successful"),
        actions: [okButton],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
      _clearData();
    } else {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("NOT EXISTING"),
        content: const Text("Data does not exist within the collection"),
        actions: [okButton],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

  void _updateData() async {
    String docuid = "";
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection(_collection.text)
        .where("businessName", isEqualTo: _businessname.text)
        .get();
    for (final e in data.docs) {
      //put docid in a container for if else
      docuid = e.id.toString();
    }
    if (docuid != "") {
      FirebaseFirestore.instance
          .collection(_collection.text)
          .doc(docuid)
          .update({'offerLink': _offerlink.text});
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      AlertDialog alert = AlertDialog(
        title: const Text("UPDATED"),
        content: const Text("Data Changed Successful"),
        actions: [okButton],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
      _clearData();
    } else {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      AlertDialog alert = AlertDialog(
        title: const Text("NOT EXISTING"),
        content:
            const Text("Business Name does not exist within the Collection"),
        actions: [okButton],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FIRESTORE FLUTTER",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Add Data to your Firestore",
            style: TextStyle(
              color: Colors.black,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _collection,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Enter Collection",
              prefixIcon: Icon(Icons.add_circle, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _businessname,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Enter Business Name",
              prefixIcon: Icon(Icons.add_business, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _offerlink,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Enter Offer Link",
              prefixIcon: Icon(Icons.add_link, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 10.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: () {
                _addData();
                //testing
              },
              child: const Text("ADD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 10.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondScreen()),
                );
              },
              child: const Text("LIST DATA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 10.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                if (_collection.text != "" && _businessname.text != "") {
                  Widget yesButton = TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        _deleteData();
                        Navigator.pop(context);
                      });
                  Widget noButton = TextButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                  AlertDialog alert = AlertDialog(
                    title: const Text("PROCEED"),
                    content: Text(
                        "Would you like to delete " + _businessname.text + "?"),
                    actions: [noButton, yesButton],
                  );

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                } else {
                  Widget okButton = TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );

                  AlertDialog alert = AlertDialog(
                    title: const Text("FIELDS EMPTY"),
                    content: const Text(
                        "Please enter Collection and Business Name you want to delete"),
                    actions: [okButton],
                  );

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                }
              },
              child: const Text("DELETE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 10.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                if (_collection.text != "" &&
                    _businessname.text != "" &&
                    _offerlink.text != "") {
                  _updateData();
                } else {
                  Widget okButton = TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );

                  AlertDialog alert = AlertDialog(
                    title: const Text("FIELDS EMPTY"),
                    content: const Text(
                        "Please enter Collection, Business Name, and new Offer Link to update"),
                    actions: [okButton],
                  );

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                }
              },
              child: const Text("UPDATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

String collname = "Tenant";

//SecondScreen
class SecondScreen extends StatelessWidget {
  SecondScreen({Key? key}) : super(key: key);

  final _collection2 = TextEditingController();

  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> doc =
              snapshot.docs[index].data() as Map<String, dynamic>;
          return ExpansionTile(
            title: Text(doc['businessName'] as String? ?? ""),
            children: [
              ListTile(
                title: const Text("Offer Link: "),
                subtitle: Text(doc['offerLink'] as String? ?? ""),
              )
            ],
          );
        });
  }

  void _collName() {
    if (_collection2.text != "") {
      collname = _collection2.text;
    } else {
      collname = "Tenant";
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("ALL DATA"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const HomeScreen())));
            }),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                    child: TextField(
                  controller: _collection2,
                  decoration:
                      const InputDecoration(hintText: "Enter Collection"),
                )),
                RawMaterialButton(
                  child:
                      const Text("Show", style: TextStyle(color: Colors.white)),
                  fillColor: Colors.blue,
                  onPressed: () {
                    _collName();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                )
              ]),
              const SizedBox(
                height: 10.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection(collname).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator();
                  } else {
                    return Expanded(
                      child: _buildList(snapshot.data!),
                    );
                  }
                },
              ),
            ],
          )));
}
