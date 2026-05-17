import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/account/model/profile.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/widget/custom_account_list.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';

class MainAccountScreen extends ConsumerWidget {
  const MainAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(accountNotifierProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (profile) => _buildContent(context, ref, profile),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Profile profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          ListTile(
            leading: profile.avatarBytes != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(profile.avatarBytes!),
                  )
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(profile.fullName),
            subtitle: Text('${profile.role} - ${profile.phoneNo}'),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 0.5),
          ),
          InkWell(
            onTap: () async {
              await context.push('/account/personal-info');
              ref.read(accountNotifierProvider.notifier).refresh();
            },
            child: const CustomAccountList(
              icon: Icons.person,
              title: 'Personal Information',
              colour: Colors.deepPurpleAccent,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const CustomAccountList(
              icon: Icons.settings,
              title: 'Settings',
              colour: Colors.lightBlueAccent,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const CustomAccountList(
              icon: Icons.credit_card,
              title: 'Payment',
              colour: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 0.5),
          ),
          if (profile.role.contains('Driver')) ...[
            InkWell(
              onTap: () {},
              child: const CustomAccountList(
                icon: Icons.person_pin_circle,
                title: 'Driver Dashboard',
                colour: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(thickness: 0.5),
            ),
          ],
          InkWell(
            onTap: () {},
            child: const CustomAccountList(
              icon: Icons.info_rounded,
              title: 'FAQs',
              colour: Colors.orangeAccent,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const CustomAccountList(
              icon: Icons.help,
              title: 'Help',
              colour: Colors.pinkAccent,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.red,
                ),
                onPressed: () => _handleLogout(context, ref),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CustomLoading()),
    );

    final failure =
        await ref.read(authNotifierProvider.notifier).logout();

    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (failure != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(failure.message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('CLOSE')),
          ],
        ),
      );
    }
    // Navigation handled by go_router redirect
  }
}
