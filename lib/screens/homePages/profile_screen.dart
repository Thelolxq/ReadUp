import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/models/racha.dart';
import 'package:read_up/models/user.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/racha_service.dart';
import 'package:read_up/widgets/custom_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final RachaService _rachaService = RachaService();
  late Future<Racha> _rachaFuture;

  Future<Racha> _getRacha() async {
    try {
      final String? token = await _authService.getToken();
      if (token == null) {
        throw Exception("No se encontró el token de autenticación.");
      }
      return _rachaService.getRacha(token);
    } catch (error) {
      throw Exception("No se pudo cargar la racha: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _rachaFuture = _getRacha();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final User? user = sessionProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context, user),
    );
  }

  Widget _buildBody(BuildContext context, User? user) {
    final textTheme = Theme.of(context).textTheme;

    if (user == null) {
      return const Center(
        child: Text("No se ha podido cargar la información del perfil"),
      );
    }

     return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/fondo2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/fondo.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nombreUsuario ?? "Usuario",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.correo!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // --- Tile de Información Personal (sin cambios) ---
                CustomExpansionTile(
                  icon: Icons.person_outline,
                  color: Colors.blueAccent,
                  title: "Información Personal",
                  children: [
                    _buildInfoRow("Correo", user.correo!),
                    _buildInfoRow("Miembro desde", "2023-01-15"),
                  ],
                ),
                const SizedBox(height: 15),
                CustomExpansionTile(
                  icon: Icons.bar_chart_outlined,
                  color: Colors.green,
                  title: "Estadísticas de Lectura",
                  children: [
                    // --- AQUÍ VA LA MAGIA ---
                    FutureBuilder<Racha>(
                      future: _rachaFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildInfoRow("Racha", "Cargando...");
                        }
                        if (snapshot.hasError) {
                          return _buildInfoRow("Racha", "No disponible");
                        }
                        if (snapshot.hasData) {
                          final racha = snapshot.data!;
                          return _buildInfoRow(
                            "Racha actual",
                            "${racha.diasConsecutivos} días 🔥",
                            isHighlight: true,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const Divider(indent: 15, endIndent: 15),
                    _buildInfoRow("Rango", user.rango!, isHighlight: true),
                    const Divider(indent: 15, endIndent: 15),
                    _buildGenresSection(user.generoFavoritos!),
                  ],
                ),
                const SizedBox(height: 15),
                CustomExpansionTile(
                  icon: Icons.settings_outlined,
                  color: Colors.orange,
                  title: "Configuración",
                  children: [
                    _buildInfoRow("Notificaciones", "Activadas"),
                    _buildInfoRow("Modo Oscuro", "Automático"),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          const SizedBox(height: 150),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final sessionProvider = context.read<SessionProvider>();
                  sessionProvider.logout();

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/welcome', (Route<dynamic> route) => false);
                },
                child: const Text("Cerrar sesion")),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? Colors.blueAccent : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenresSection(List<String> genres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Géneros Favoritos",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            children: genres
                .map((genre) => Chip(
                      label: Text(
                        genre,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
