import 'package:flutter/material.dart';
import 'VoiceCallwithToken.dart';

class NoAnswerwithToken extends StatefulWidget {
  const NoAnswerwithToken({Key? key}): super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<NoAnswerwithToken> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueGrey,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: Column(
                  children: <Widget>[
                    const SizedBox(height:100),
                    SizedBox(
                      height: 110,
                      width: 110,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/avatar.png"),
                          ),
                          Positioned(
                              bottom: 0,
                              right: -25,
                              child: RawMaterialButton(
                                onPressed: () {},
                                elevation: 1.0,
                                fillColor: Colors.white,
                                child: const Icon(Icons.camera_alt_outlined, color: Colors.blueGrey),
                                padding: const EdgeInsets.all(10.0),
                                shape: const CircleBorder(),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height:20),
                    const Text('Not Answered', style: TextStyle(fontSize: 18, color: Colors.white,
                        fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                    const SizedBox(height:10),
                  ]
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              color: Colors.blueGrey,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child: ListTile(
                        title: FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.cancel, color: Colors.blueGrey),
                        ),
                        subtitle: const Text('cancel', textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child: ListTile(
                        title: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const VoiceCallwithToken())
                            );
                          },
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.phone, color: Colors.white),
                        ),
                        subtitle: const Text('call again', textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}