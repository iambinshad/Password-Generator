import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:methodchannelprojects/controller/db/db_fuction.dart';
import 'package:methodchannelprojects/model/password_history_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  TextEditingController randomPasswordController = TextEditingController();
  @override
  void dispose() {
    randomPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    passwordLengthController.text = currentValue.toString();
    super.initState();
  }

  bool box1 = false;
  bool box2 = false;
  bool box3 = false;
  int currentValue = 8;
  TextEditingController passwordLengthController = TextEditingController();
  ScrollController scrollController = ScrollController();
  // List<bool> categoryValue = [];

  List<String> options = ["Numbers", "Characters", "Special Characters"];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    context.read<DbClass>().getAllPasswords();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Generator"),
        actions: [
          IconButton(
              onPressed: () {
                void fuction() async {
                  if (mounted) {
                    await Provider.of<DbClass>(context, listen: false)
                        .clearDatabase();
                    Navigator.pop(context);
                  }
                }

                mydialog(context, "Delete All",
                    "Do You Want To Delete All Password?", fuction);
              },
              icon: const Icon(Icons.delete_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      enableInteractiveSelection: false,
                      controller: randomPasswordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          isDense: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                final data = ClipboardData(
                                    text: randomPasswordController.text);
                                Clipboard.setData(data);
                                final snackbar = SnackBar(
                                    content:
                                        randomPasswordController.text.isEmpty
                                            ? const Text("Field is empty!")
                                            : const Text("Password Copy"));

                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(snackbar);
                              },
                              icon: const Icon(Icons.copy))),
                    ),
                    ListTile(
                      title: const Text("Numbers"),
                      trailing: Checkbox(
                          value: box1,
                          onChanged: (value) {
                            setState(() {
                              box1 = value ?? false;
                            });
                          }),
                    ),
                    ListTile(
                      title: const Text("Characters"),
                      trailing: Checkbox(
                          value: box2,
                          onChanged: (value) {
                            setState(() {
                              box2 = value ?? false;
                            });
                          }),
                    ),
                    ListTile(
                      title: const Text("Special Characters"),
                      trailing: Checkbox(
                          value: box3,
                          onChanged: (value) {
                            setState(() {
                              box3 = value ?? false;
                            });
                          }),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 18,
                        ),
                        const Text(
                          "Password Length   : ",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: "password length"),
                              controller: passwordLengthController,
                              keyboardType: TextInputType.none
                              ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MaterialButton(
                              minWidth: 5.0,
                              child: const Icon(Icons.arrow_drop_up),
                              onPressed: () {
                                currentValue =
                                    int.parse(passwordLengthController.text);
                                setState(() {
                                  if (currentValue < 20) {
                                    currentValue++;
                                    passwordLengthController.text =
                                        (currentValue).toString();
                                  } // incrementing value
                                });
                              },
                            ),
                            MaterialButton(
                              minWidth: 5.0,
                              child: const Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                int currentValue =
                                    int.parse(passwordLengthController.text);
                                setState(() {
                                  if (currentValue > 8) {
                                    currentValue--;
                                    passwordLengthController.text =
                                        (currentValue).toString();
                                  } // decrementing value
                                });
                              },
                            ),
                          ],
                        ),

                        // const Spacer(
                        //   flex: 3,
                        // )
                      ],
                    ),
                    SizedBox(
                        width: width / 1.1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.teal),
                            onPressed: () {
                              if (box1 == false &&
                                  box2 == false &&
                                  box3 == false) {
                                const snackbar = SnackBar(
                                    content: Text("None of options selected!"));
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(snackbar);
                              } else {
                                final password = generatePassword(
                                    isNumber: box1,
                                    isSpecial: box3,
                                    lengthofPassword: currentValue,
                                    letter: box2);
                                randomPasswordController.text = password;
                                DateTime date = DateTime.now();
                                String time =
                                    "${date.hour}:${date.minute}:${date.second}";
                                PasswordModel passwordModel = PasswordModel(
                                    password: password, time: time);
                                context
                                    .read<DbClass>()
                                    .addPasswordHistory(passwordModel);
                              }
                            },
                            child: const Text(
                              "Generate",
                            ))),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Card(
              child: Consumer<DbClass>(
                  builder: (context, value, child) => value.historList.isEmpty
                      ? const Center(
                          child: Text("Empty History!"),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          controller: scrollController,
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: value.historList.length,
                          itemBuilder: (context, index) => Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(7),
                                  onPressed: (context) {},
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(7),
                                  onPressed: (context) async {
                                    await Provider.of<DbClass>(context,
                                            listen: false)
                                        .deletePassword(
                                            value.historList[index].id!);
                                    // void function() async {
                                    //   if (mounted) {
                                    //     Navigator.pop(context);
                                    //   }
                                    // }
                                    // mydialog(
                                    //     context,
                                    //     "Delete Password",
                                    //     "Do You Want To Detele This?",
                                    //     function);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                              subtitle: Text(value.historList[index].time),
                              title: Text(value.historList[index].password),
                              trailing: IconButton(
                                  onPressed: () {
                                    final data = ClipboardData(
                                        text: value.historList[index].password);
                                    Clipboard.setData(data);
                                    const snackbar = SnackBar(
                                        content: Text("Password Copied"));

                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(snackbar);
                                  },
                                  icon: const Icon(Icons.copy)),
                            ),
                          ),
                        )),
            ))
          ],
        ),
      ),
    );
  }

  Future<dynamic> mydialog(
      BuildContext context, String title, String content, Function yesClick) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No")),
          ElevatedButton(
              onPressed: () async {
                await yesClick();
              },
              child: const Text("Yes")),
        ],
      ),
    );
  }

  String generatePassword({
    bool letter = true,
    bool isNumber = true,
    bool isSpecial = true,
    int? lengthofPassword,
  }) {
    int length = lengthofPassword!;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;
    if (isSpecial) chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }
}
