import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:read_up/models/user.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/screens/singIn/sign_in_screen.dart';
import 'package:read_up/widgets/custom_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final User? user = sessionProvider.user;
    print(user?.generoFavoritos?.join(', '));

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context, user),
    );
  }

  Widget _buildBody(BuildContext context, User? user) {
    final size = MediaQuery.of(context).size;
    if (user == null) {
      return const Center(
        child: Text("No se ha podido Cargar la informacion del perfil"),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            width: size.width,
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  top: BorderSide(color: Colors.black, width: 0.1),
                  left: BorderSide(color: Colors.black, width: 0.1),
                  right: BorderSide(color: Colors.black, width: 0.1),
                  bottom: BorderSide(color: Colors.black, width: 0.1),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                ),
                Text(
                  user.nombreUsuario!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${user.edad}\n Edad",
                      textAlign: TextAlign.center,
                    ),
                    Text("${user.nivelLector}\n Nivel lector",
                        textAlign: TextAlign.center),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
