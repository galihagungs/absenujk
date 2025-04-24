import 'package:absenpraujk/bloc/profile/page/profilepage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ProfilepageBloc>().add(ProfilepageInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: BlocConsumer<ProfilepageBloc, ProfilepageState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ProfilepageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfilepageLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile Anda",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ProfilepageBloc>().add(
                                ProfilepageEditEvent(user: state.user),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Text(
                        'Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        state.user.name.toString(),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Email',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        state.user.email.toString(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfilepageEdit) {
              _nameController.text = state.user.name.toString();
              _emailController.text = state.user.email.toString();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile Anda",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfilepageBloc>().add(
                            ProfilepageSaveEvent(
                              email: _emailController.text,
                              name: _nameController.text,
                            ),
                          );
                        },
                        child: Text("Simpan"),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: Text(
                'Failed To Load Data',
                style: TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      ),
    );
  }
}
