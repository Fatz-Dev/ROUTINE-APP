import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/habit_categories.dart';
import '../../../core/constants/habit_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/habit.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/pickers.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? existing;
  const AddHabitScreen({super.key, this.existing});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _iconKey = 'check';
  HabitCategory _category = HabitCategory.kesehatan;
  bool _hasTarget = false;

  static const List<String> _commonUnits = [
    'gelas',
    'menit',
    'halaman',
    'kali',
    'ml',
    'km',
    'jam',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _nameCtrl.text = e.name;
      _descCtrl.text = e.description ?? '';
      _iconKey = e.iconKey;
      _category = HabitCategory.fromName(e.category);
      _hasTarget = e.hasTarget;
      _targetCtrl.text = e.targetValue?.toString() ?? '';
      _unitCtrl.text = e.targetUnit ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _targetCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(habitListProvider.notifier);
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final targetVal = _hasTarget ? int.tryParse(_targetCtrl.text.trim()) : null;
    final targetUnit =
        _hasTarget && _unitCtrl.text.trim().isNotEmpty ? _unitCtrl.text.trim() : null;

    if (widget.existing == null) {
      await notifier.create(
        name: name,
        iconKey: _iconKey,
        colorIndex: 0,
        category: _category.name,
        description: desc.isEmpty ? null : desc,
        hasTarget: _hasTarget && targetVal != null,
        targetValue: targetVal,
        targetUnit: targetUnit,
      );
    } else {
      final updated = widget.existing!.copyWith(
        name: name,
        iconKey: _iconKey,
        category: _category.name,
        description: desc.isEmpty ? null : desc,
        hasTarget: _hasTarget && targetVal != null,
        targetValue: targetVal,
        targetUnit: targetUnit,
      );
      await notifier.update(updated);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickIcon() async {
    final picked = await IconPickerSheet.show(context, selected: _iconKey);
    if (picked != null) setState(() => _iconKey = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              pinned: true,
              elevation: 0,
              backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
              title: Text(
                isEdit ? 'Edit Habit' : 'Habit Baru',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              actions: [
                if (isEdit)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      onPressed: _showDeleteDialog,
                    ),
                  ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPreviewCard(isDark),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Informasi Dasar'),
                    _buildInputCard(
                      isDark,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _nameCtrl,
                            label: 'Nama Habit',
                            hint: 'Misal: Olahraga Pagi',
                            icon: Icons.edit_rounded,
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Nama wajib diisi'
                                : null,
                          ),
                          const Divider(height: 32),
                          _buildTextField(
                            controller: _descCtrl,
                            label: 'Deskripsi (Opsional)',
                            hint: 'Catatan tambahan...',
                            icon: Icons.notes_rounded,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Kategori'),
                    _buildCategoryGrid(isDark),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Visual'),
                    _buildInputCard(
                      isDark,
                      child: InkWell(
                        onTap: _pickIcon,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(HabitIcons.get(_iconKey),
                                    color: AppColors.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ikon Habit',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w800)),
                                    Text('Pilih ikon yang sesuai',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                                color: theme.hintColor)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Target & Pengukuran'),
                    _buildTargetSettings(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBtn(context, isEdit, isDark),
    );
  }

  Widget _buildPreviewCard(bool isDark) {
    final name = _nameCtrl.text.isEmpty ? 'Nama Habit' : _nameCtrl.text;
    final targetVal = _targetCtrl.text;
    final unit = _unitCtrl.text;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Decorative background blobs
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                   Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primaryMid, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(HabitIcons.get(_iconKey),
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'PRATINJAU REAL-TIME',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            _category.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _hasTarget && targetVal.isNotEmpty
                                ? 'Target: $targetVal $unit'
                                : 'Presensi Harian',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Text(_category.emoji, style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInputCard(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: HabitCategory.values.map((c) {
        final selected = c == _category;
        return GestureDetector(
          onTap: () => setState(() => _category = c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkSurfaceAlt : Colors.white),
              borderRadius: BorderRadius.circular(16),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : (isDark ? Colors.white10 : Colors.black12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(c.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  c.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: selected
                        ? Colors.white
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTargetSettings(bool isDark) {
    return _buildInputCard(
      isDark,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _hasTarget
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.track_changes_rounded,
                    color: _hasTarget ? AppColors.primary : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gunakan Target',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      Text(
                        'Lacak kemajuan terukur',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _hasTarget,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _hasTarget = v),
                ),
              ],
            ),
          ),
          if (_hasTarget) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _targetCtrl,
                          label: 'Target',
                          hint: '8',
                          icon: Icons.numbers_rounded,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (!_hasTarget) return null;
                            if (v == null || v.trim().isEmpty)
                              return 'Wajib diisi';
                            final n = int.tryParse(v.trim());
                            if (n == null || n <= 0) return 'Angka > 0';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _unitCtrl,
                          label: 'Satuan',
                          hint: 'Gelas',
                          icon: Icons.straighten_rounded,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _commonUnits.map((u) {
                        final isActive = _unitCtrl.text == u;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(u),
                            selected: isActive,
                            onSelected: (v) {
                              if (v) {
                                _unitCtrl.text = u;
                                setState(() {});
                              }
                            },
                            selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isActive ? AppColors.primary : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBtn(BuildContext context, bool isEdit, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : AppColors.lightBg,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
        ),
        child: Text(
          isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH HABIT',
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }

  void _showDeleteDialog() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Habit?'),
        content: const Text(
            'Habit akan dinonaktifkan. Histori presensi tetap tersimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(habitListProvider.notifier).delete(widget.existing!.id);
      if (mounted) Navigator.of(context).pop();
    }
  }
}
