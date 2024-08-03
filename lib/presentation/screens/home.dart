import 'package:flutter/material.dart';
import 'package:localdatabasepoc/database/model.dart';

import '../../database/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final DataBaseHelper _dataBaseHelper = DataBaseHelper();
  late User _user;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataBaseHelper.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  Future<void> addUser() async {
    String name = nameController.text;
    String age = ageController.text;
    String email = emailController.text;
    _user = User(name: name, age: int.parse(age), email: email);

    try{
      await _dataBaseHelper.insertUser(_user);
    } catch(e){
      print(e);
    }
  }

  void populateFields(User user) {
    _user = user;
    nameController.text = _user.name!;
    ageController.text = _user.age.toString();
    emailController.text = _user.email!;
  }

  void selectUser(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFlite Demo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Enter your name",
                          labelText: "Name"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter your age",
                          labelText: "Age"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                          labelText: "Email"
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: addUser, child: const Text("Add")),
                        ElevatedButton(onPressed: (){}, child: const Text("Update")),
                        ElevatedButton(onPressed: selectUser, child: const Text("Select")),
                        ElevatedButton(onPressed: (){}, child: const Text("Delete")),
                      ],
                    )
                  ],
                ),
              ),
              // userWidget(),
              userWidget1()
            ],
          ),
        ),
      ),
    );
  }

  Widget userWidget1() {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 21)),
      builder: (context, snapshot){
        return Center(child: Text("essssei"),);
      },
    );
  }

  Widget userWidget(){
    return FutureBuilder(
      future: _dataBaseHelper.retrieveUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index){
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: const Icon(Icons.delete_forever),
                ),
                onDismissed: (DismissDirection direction) async {
                  await _dataBaseHelper.deleteUser(snapshot.data![index].id!);
                },
                key: UniqueKey(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => populateFields(snapshot.data![index]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            snapshot.data![index].name!
                          ),
                          Text(snapshot.data![index].email!)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
