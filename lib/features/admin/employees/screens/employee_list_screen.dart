import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_button.dart';
import 'package:clean_ride/core/widgets/app_input.dart';
import 'package:clean_ride/data/providers/users_provider.dart';
import 'package:gap/gap.dart';

class EmployeeListScreen extends ConsumerWidget {
  const EmployeeListScreen({super.key});

  Future<void> _showAddWasherDialog(BuildContext context, WidgetRef ref) async {
    final pageContext = context;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final passwordController = TextEditingController();
    var isSubmitting = false;

    await showDialog<void>(
      context: pageContext,
      barrierDismissible: !isSubmitting,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (formContext, setDialogState) {
            Future<void> submit() async {
              if (!(formKey.currentState?.validate() ?? false)) return;

              setDialogState(() => isSubmitting = true);
              final error = await ref.read(usersActionsProvider).createWasher(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                  );

              if (!formContext.mounted) return;
              setDialogState(() => isSubmitting = false);

              if (error == null) {
                Navigator.of(dialogContext).pop();
                ref.invalidate(usersProvider('employee'));
                if (!pageContext.mounted) return;
                ScaffoldMessenger.of(pageContext).showSnackBar(
                  const SnackBar(
                    content: Text('Washer added'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                if (!pageContext.mounted) return;
                ScaffoldMessenger.of(pageContext).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: const Text('Add Washer'),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppInput(
                          label: 'Name',
                          hint: 'Washer name',
                          controller: nameController,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        const Gap(14),
                        AppInput(
                          label: 'Email',
                          hint: 'washer@email.com',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return 'Email is required';
                            if (!text.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const Gap(14),
                        AppInput(
                          label: 'Phone',
                          hint: 'Optional',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                        ),
                        const Gap(14),
                        AppInput(
                          label: 'Address',
                          hint: 'Optional',
                          controller: addressController,
                          prefixIcon: Icons.location_on_outlined,
                          maxLines: 2,
                        ),
                        const Gap(14),
                        AppInput(
                          label: 'Password',
                          hint: 'Minimum 6 characters',
                          controller: passwordController,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            final text = value ?? '';
                            if (text.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              actions: [
                TextButton(
                  onPressed:
                      isSubmitting
                          ? null
                          : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                SizedBox(
                  width: 150,
                  child: AppButton(
                    label: 'Add',
                    icon: Icons.person_add_alt,
                    isLoading: isSubmitting,
                    onPressed: submit,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(usersProvider('employee'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Team'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Add washer',
            onPressed: () => _showAddWasherDialog(context, ref),
            icon: const Icon(Icons.person_add_alt_1),
          ),
          TextButton.icon(
            onPressed: () => context.push('/admin/team/payroll'),
            icon: const Icon(Icons.payments, size: 18),
            label: const Text('Payroll'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWasherDialog(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Washer'),
      ),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const Gap(12),
              Text('Could not load team', style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () => ref.invalidate(usersProvider('employee')),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (employees) {
          if (employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const Gap(16),
                  Text('No employees yet', style: AppTypography.titleMedium),
                  const Gap(16),
                  AppButton(
                    label: 'Add Washer',
                    icon: Icons.person_add_alt_1,
                    isFullWidth: false,
                    onPressed: () => _showAddWasherDialog(context, ref),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: AppButton(
                  label: 'Add Washer',
                  icon: Icons.person_add_alt_1,
                  onPressed: () => _showAddWasherDialog(context, ref),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: employees.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final w = employees[index];
                    final name = w['name']?.toString() ?? 'Employee';
                    final email = w['email']?.toString() ?? '';
                    final id = w['id']?.toString() ?? '';
                    final initials = name
                        .split(' ')
                        .map((x) => x.isNotEmpty ? x[0] : '')
                        .take(2)
                        .join();

                    return GestureDetector(
                      onTap: () => context.push('/admin/team/$id'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              initials,
                              style: AppTypography.titleMedium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: AppTypography.titleMedium),
                                const Gap(2),
                                Text(
                                  email,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Gap(4),
                                SelectableText(
                                  'ID: $id',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
