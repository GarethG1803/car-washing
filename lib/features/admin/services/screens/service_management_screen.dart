import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/service_package.dart';
import 'package:clean_ride/data/providers/services_provider.dart';
import 'package:clean_ride/data/providers/upload_provider.dart';
import 'package:gap/gap.dart';

class ServiceManagementScreen extends ConsumerWidget {
  const ServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Services & Pricing'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const Gap(12),
              Text('Could not load services', style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () => ref.invalidate(servicesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_car_wash_outlined,
                      size: 64, color: AppColors.textSecondary),
                  const Gap(16),
                  Text('No services configured', style: AppTypography.titleMedium),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Wash Packages', style: AppTypography.titleMedium),
              const Gap(12),
              ...services.map((s) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))
                      ],
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: s.imageUrl != null
                            ? Image.network(
                                s.imageUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _placeholder(),
                              )
                            : _placeholder(),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.name, style: AppTypography.titleMedium),
                          Text(
                            '${s.duration} min • ${s.category.name}',
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ]),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(s.price.toInt())}',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(8),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.textSecondary, size: 20),
                        onPressed: () => _showForm(context, ref, existing: s),
                      ),
                    ]),
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
          color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
      child: const Icon(Icons.local_car_wash, color: AppColors.primary),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {ServicePackage? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ServiceFormSheet(
        existing: existing,
        onSaved: () => ref.invalidate(servicesProvider),
      ),
    );
  }
}

class _ServiceFormSheet extends ConsumerStatefulWidget {
  final ServicePackage? existing;
  final VoidCallback onSaved;

  const _ServiceFormSheet({this.existing, required this.onSaved});

  @override
  ConsumerState<_ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends ConsumerState<_ServiceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _duration;
  String _vehicleType = 'sedan';
  String? _imageUrl;
  bool _uploadingImage = false;
  bool _saving = false;

  static const _vehicleTypes = ['sedan', 'suv', 'truck', 'motorcycle'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _price = TextEditingController(text: e != null ? e.price.toStringAsFixed(0) : '');
    _duration = TextEditingController(text: e?.duration.toString() ?? '60');
    _imageUrl = e?.imageUrl;
    if (e != null) {
      switch (e.category) {
        case ServiceCategory.premium:
          _vehicleType = 'suv';
        case ServiceCategory.deluxe:
          _vehicleType = 'truck';
        case ServiceCategory.addon:
          _vehicleType = 'motorcycle';
        default:
          _vehicleType = 'sedan';
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 1024, imageQuality: 85);
    if (file == null) return;

    setState(() => _uploadingImage = true);
    try {
      final url = await ref.read(uploadServiceProvider).uploadImage(file);
      setState(() => _imageUrl = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final dio = ref.read(apiClientProvider);
      final body = {
        'name': _name.text.trim(),
        'description':
            _description.text.trim().isEmpty ? null : _description.text.trim(),
        'price': double.parse(_price.text),
        'duration': int.parse(_duration.text),
        'vehicle_type': _vehicleType,
        'image_url': _imageUrl,
      };

      if (widget.existing != null) {
        await dio.patch('/services/${widget.existing!.id}', data: body);
      } else {
        await dio.post('/services', data: body);
      }

      if (mounted) {
        widget.onSaved();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const Gap(20),
                Text(
                  widget.existing != null ? 'Edit Service' : 'Add Service',
                  style: AppTypography.titleLarge,
                ),
                const Gap(20),
                GestureDetector(
                  onTap: _uploadingImage ? null : _pickImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.divider),
                      image: _imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_imageUrl!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _uploadingImage
                        ? const Center(child: CircularProgressIndicator())
                        : _imageUrl == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: AppColors.primary.withValues(alpha: 0.6)),
                                  const Gap(8),
                                  Text('Tap to add photo',
                                      style: AppTypography.bodyMedium
                                          .copyWith(color: AppColors.textSecondary)),
                                ],
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _imageUrl = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ),
                const Gap(16),
                TextFormField(
                  controller: _name,
                  decoration: _inputDeco('Service Name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const Gap(12),
                TextFormField(
                  controller: _description,
                  decoration: _inputDeco('Description (optional)'),
                  maxLines: 2,
                ),
                const Gap(12),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      decoration: _inputDeco('Price (Rp)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: TextFormField(
                      controller: _duration,
                      decoration: _inputDeco('Duration (min)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                ]),
                const Gap(12),
                DropdownButtonFormField<String>(
                  value: _vehicleType,
                  decoration: _inputDeco('Vehicle Type'),
                  items: _vehicleTypes
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child:
                                Text(t[0].toUpperCase() + t.substring(1)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _vehicleType = v!),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(widget.existing != null
                            ? 'Save Changes'
                            : 'Create Service'),
                  ),
                ),
                const Gap(8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
