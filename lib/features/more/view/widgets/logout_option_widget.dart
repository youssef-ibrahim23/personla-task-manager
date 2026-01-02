import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/auth/views/login_view.dart';
import 'package:personal_task/features/more/view-model/more_view_model.dart';

class LogoutOptionWidget extends ConsumerWidget {
  const LogoutOptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(moreViewModelProvider);
    final localizations = AppLocalizations.of(context)!;

    // Listen to logout state changes
    ref.listen(moreViewModelProvider, (previous, next) {
      next.when(
        data: (_) {
          // Logout successful - navigate to login
          if (previous?.isLoading == true) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginView()),
              (route) => false,
            );
          }
        },
        error: (error, _) {
          // Show error dialog
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.logout_failed),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        loading: () {},
      );
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red[400], size: 28),
        title: Text(
          localizations.logout,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        subtitle: logoutState.isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[400]!),
                ),
              )
            : Text(
                localizations.logout_confirmation,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.surface),
              ),
        onTap: logoutState.isLoading
            ? null
            : () async {
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(localizations.logout , style: TextStyle(color: Theme.of(context).colorScheme.surface),),
                    content: Text(localizations.logout_confirmation , style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(localizations.cancel , style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                        ),
                        child: Text(
                          localizations.logout,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  await ref.read(moreViewModelProvider.notifier).logout();
                }
              },
      ),
    );
  }
}
