import 'package:flutter/material.dart';

import 'ChipBar.dart';

class PlayerControl extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerControl> {
  int _chipToCall = 0;

  void _incr(int chipIncr) {
    setState(() {
      _chipToCall += chipIncr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DragTarget<PokerChip>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 50.0,
              width: 50.0,
              color: Colors.cyan,
              child: Center(
                child: Text('Value is updated to: $_chipToCall'),
              ),
            );
          },
          onWillAccept: (_) => true,
          onAccept: (_) => _incr(50)),

      Text('$_chipToCall'),
      // ElevatedButton(
      //   onPressed: () => _incr(50),
      //   child: Text("Put 50"),
      // ),
      ChipBar()
    ]);
  }
}

// void main() => runApp(const MyApp());

// /// This is the main application widget.
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: const MyStatefulWidget(),
//       ),
//     );
//   }
// }

// /// This is the stateful widget that the main application instantiates.
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);

//   @override
//   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
// }

// /// This is the private State class that goes with MyStatefulWidget.
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   int acceptedData = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Draggable<int>(
//           // Data is the value this Draggable stores.
//           data: 10,
//           child: Container(
//             height: 100.0,
//             width: 100.0,
//             color: Colors.lightGreenAccent,
//             child: const Center(
//               child: Text('Draggable'),
//             ),
//           ),
//           feedback: Container(
//             color: Colors.deepOrange,
//             height: 100,
//             width: 100,
//             child: const Icon(Icons.directions_run),
//           ),
//           childWhenDragging: Container(
//             height: 100.0,
//             width: 100.0,
//             color: Colors.pinkAccent,
//             child: const Center(
//               child: Text('Child When Dragging'),
//             ),
//           ),
//         ),
//         DragTarget<int>(
//           builder: (
//             BuildContext context,
//             List<dynamic> accepted,
//             List<dynamic> rejected,
//           ) {
//             return Container(
//               height: 100.0,
//               width: 100.0,
//               color: Colors.cyan,
//               child: Center(
//                 child: Text('Value is updated to: $acceptedData'),
//               ),
//             );
//           },
//           onAccept: (int data) {
//             setState(() {
//               acceptedData += data;
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
