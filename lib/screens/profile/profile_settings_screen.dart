import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';

/// Profil ayarları ekranı - Kullanıcı bilgilerini düzenleme
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Controller'lar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Düzenleme modları
  bool _isEditingName = false;
  bool _isEditingSurname = false;
  bool _isEditingPhone = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  @override
  void initState() {
    super.initState();
    // Örnek veriler - API bağlantısı yapılacak
    _nameController.text = 'AhmetTt';
    _surnameController.text = 'Can';
    _phoneController.text = '5351234377';
    _emailController.text = 'cmala@example.com';
    _passwordController.text = 'siafre123';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.appBlack),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Hesap Ayarları',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Ad Soyad
                  _buildSettingsRow(
                    label: '${_nameController.text} ${_surnameController.text}',
                    isEditing: _isEditingName || _isEditingSurname,
                    onEditTap: () {
                      _showEditDialog(
                        title: 'Ad Soyad',
                        fields: [
                          _EditField(label: 'Ad', controller: _nameController),
                          _EditField(label: 'Soyad', controller: _surnameController),
                        ],
                      );
                    },
                  ),
                  _buildDivider(),
                  // Telefon
                  _buildSettingsRow(
                    label: '+90 ${_formatPhone(_phoneController.text)}',
                    isEditing: _isEditingPhone,
                    onEditTap: () {
                      _showEditDialog(
                        title: 'Telefon Numarası',
                        fields: [
                          _EditField(
                            label: 'Telefon',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      );
                    },
                  ),
                  _buildDivider(),
                  // Email
                  _buildSettingsRow(
                    label: _emailController.text,
                    isEditing: _isEditingEmail,
                    onEditTap: () {
                      _showEditDialog(
                        title: 'E-posta',
                        fields: [
                          _EditField(
                            label: 'E-posta',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      );
                    },
                  ),
                  _buildDivider(),
                  // Şifre
                  _buildSettingsRow(
                    label: 'Şifre',
                    isEditing: _isEditingPassword,
                    onEditTap: () {
                      _showEditDialog(
                        title: 'Şifre',
                        fields: [
                          _EditField(
                            label: 'Şifre',
                            controller: _passwordController,
                            obscureText: true,
                          ),
                        ],
                      );
                    },
                  ),
                  _buildDivider(),
                ],
              ),
            ),
          ),
          // Kaydet Butonu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Kaydet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Çıkış Yap Butonu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: OutlinedButton(
                onPressed: _showLogoutDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade400, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.red.shade400,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required String label,
    required bool isEditing,
    required VoidCallback onEditTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.appBlack,
              ),
            ),
          ),
          GestureDetector(
            onTap: onEditTap,
            child: Text(
              'Değiştir',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.appBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade300,
    );
  }

  String _formatPhone(String phone) {
    if (phone.length >= 10) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  void _showEditDialog({
    required String title,
    required List<_EditField> fields,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.w,
          right: 16.w,
          top: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.appBlack,
              ),
            ),
            SizedBox(height: 20.h),
            ...fields.map(
              (field) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: TextField(
                  controller: field.controller,
                  keyboardType: field.keyboardType,
                  obscureText: field.obscureText,
                  decoration: InputDecoration(
                    labelText: field.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.appGreen),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Tamam',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    // TODO: API bağlantısı yapılacak
    // Kullanıcı profil bilgilerini güncelleme işlemi
    final data = {
      'name': _nameController.text,
      'surname': _surnameController.text,
      'phoneNumber': _phoneController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    print('Kaydedilecek veriler: $data');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Değişiklikler kaydedildi'),
        backgroundColor: AppColors.appGreen,
      ),
    );
  }

  /// Çıkış yapma onay diyaloğunu gösterir
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Çıkış Yap',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlack,
          ),
        ),
        content: Text(
          'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text(
              'Çıkış Yap',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Çıkış işlemini gerçekleştirir
  void _logout() {
    // GetStorage'dan kullanıcı bilgilerini temizle
    final storage = GetStorage();
    storage.remove('token');
    storage.remove('userId');

    // Giriş ekranına yönlendir ve tüm geçmişi temizle
    context.go('/signin');
  }
}

// Yardımcı sınıf - düzenleme alanları için
class _EditField {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  _EditField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });
}
