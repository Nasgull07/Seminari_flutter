import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seminari_flutter/models/user.dart';
import 'package:seminari_flutter/services/UserService.dart';
import '../widgets/Layout.dart';
import '../services/auth_service.dart';


/// -------------------  Pantalla de perfil d'usuari  ------------------- ///

class PerfilScreen extends StatefulWidget {
   final String userId;
  const PerfilScreen({super.key, required this.userId});
 @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}



class _PerfilScreenState extends State<PerfilScreen> {
  late Future<User> _userFuture;


  /// -------------------  Inicialitza l'usuari fent un getUserById  ------------------- ///
  @override
  void initState() {
    super.initState();
    _userFuture = UserService.getUserById(widget.userId);
  }




  /// -------------------  Navega a la pantalla de edició del perfil  ------------------- ///

  void _navigateToEditProfile(BuildContext context) {
  _userFuture.then((user) {
    context.go('/profile/edit', extra: user); 
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar el perfil: $error')),
    );
  });
  }
  
  /// -------------------  Navega a la pantalla de canvi de contrasenya  ------------------- ///

  void _navigateToChangePassword(BuildContext context) {
  context.go('/profile/change-password', extra: widget.userId);
}




  /// -------------------  Crea el widget de la pantalla de perfil  ------------------- ///

   @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No se encontraron datos del usuario.'));
        }

        final user = snapshot.data!;
        return _buildProfileScreen(context, user);
      },
    );
  }

  /// -------------------  Crea el widget de la pantalla de perfil  ------------------- ///

  @override
  Widget _buildProfileScreen(BuildContext context, User user) {
    return LayoutWrapper(
      title: 'Perfil',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildProfileItem(
                            context,
                            Icons.badge,
                            'ID',
                            user.id ?? 'N/A',
                          ),
                          const Divider(),
                          _buildProfileItem(context, Icons.cake, 'Edat', user.age.toString()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Configuració del compte',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildSettingItem(
                            context,
                            Icons.edit,
                            'Editar Perfil',
                            'Actualitza la teva informació personal',
                          ),
                          _buildSettingItem(
                            context,
                            Icons.lock,
                            'Canviar contrasenya',
                            'Actualitzar la contrasenya',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final authService = AuthService();
                        authService.logout();
                        context.go('/login');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al tancar sessió: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('TANCAR SESSIÓ'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------  Crea el widget de la configuració del compte  ------------------- ///

  Widget _buildSettingItem(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
) {
  return ListTile(
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      if (title == 'Editar Perfil') {
        _navigateToEditProfile(context);
      } else if (title == 'Canviar contrasenya') {
        _navigateToChangePassword(context);
      }
    },
  );
}
}
