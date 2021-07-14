// // import 'package:trial/utils/universal_variables.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:trial/enum/user_state.dart';
// import 'package:tiral/models/users.dart';
// // import 'package:trial/resources/authentication_methods.dart';
// import 'package:trial/utils/utilities.dart';

// class UniversalVariables {
//   static const Color onlineDotColor = Color(0xFF5CFF72);
//   static const Color offlineDotColor = Color(0xFFFF2200);
//   static const Color waitingDotColor = Color(0xFFF4FF5C);
// }

// class OnlineDotIndicator extends StatelessWidget {
//   final String uid;
//   // final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

//   OnlineDotIndicator({
//     required this.uid,
//   });

//   @override
//   Widget build(BuildContext context) {
//     getColor(int state) {
//       UserState numToState(int number) {
//         switch (number) {
//           case 0:
//             return UserState.Offline;

//           case 1:
//             return UserState.Online;

//           case 2:
//             return UserState.Waiting;

//           default:
//             return UserState.Waiting;
//         }
//       }

//       switch (numToState(state)) {
//         case UserState.Offline:
//           return UniversalVariables.offlineDotColor;
//         case UserState.Online:
//           return UniversalVariables.onlineDotColor;
//         case UserState.Waiting:
//           return UniversalVariables.waitingDotColor;
//         default:
//           return UniversalVariables.waitingDotColor;
//       }
//     }

//     return Align(
//       alignment: Alignment.topRight,
//       child: StreamBuilder<DocumentSnapshot>(
//         stream: _authenticationMethods.getUserStream(
//           uid: uid,
//         ),
//         builder: (context, snapshot) {
//           Users users;

//           if (snapshot.hasData && snapshot.data!.data != null) {
//             users = Users.fromMap(snapshot.data.data());
//           }

//           return Container(
//             height: 10,
//             width: 10,
//             margin: const EdgeInsets.only(right: 2, top: 46),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: getColor(users?.state),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
