import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/models/user_model.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Servis ve depolama
  final UserService _userService = UserService();
  final GetStorage _storage = GetStorage();

  // Durum değişkenleri
  bool _isLoading = true;
  bool _isSaving = false;
  String? _userId;
  String? _token;

  // Düzenleme modları
  bool _isEditingName = false;
  bool _isEditingSurname = false;
  bool _isEditingPhone = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  // Bildirim izni durumu
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkNotificationPermission();
  }

  /// Bildirim izni durumunu kontrol eder
  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (mounted) {
      setState(() {
        _notificationsEnabled = status.isGranted;
      });
    }
  }

  /// Kullanıcı bilgilerini API'den yükler
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      _userId = _storage.read('userId');
      _token = _storage.read('token');

      if (_userId != null && _token != null) {
        final user = await _userService.getUser(_userId!, _token!);
        _populateFields(user);
      }
    } catch (e) {
      debugPrint('Kullanıcı bilgileri yüklenemedi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kullanıcı bilgileri yüklenemedi'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Kullanıcı verilerini controller'lara doldurur
  void _populateFields(User user) {
    _nameController.text = user.name ?? '';
    _surnameController.text = user.surname ?? '';
    _phoneController.text = user.phoneNumber ?? '';
    _emailController.text = user.email ?? '';
    _passwordController.text = '********'; // Şifre güvenlik nedeniyle gösterilmez
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.appGreen,
              ),
            )
          : Column(
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
                          label: _formatPhone(_phoneController.text),
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
                        // Şifre (sadece gösterim amaçlı - bu API'de güncelleme yok)
                        _buildSettingsRow(
                          label: 'Şifre',
                          isEditing: _isEditingPassword,
                          onEditTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Şifre değiştirme şu anda desteklenmiyor'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        // Bildirim İzinleri
                        _buildNotificationRow(),
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
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
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

  /// Bildirim izinleri satırını oluşturur
  Widget _buildNotificationRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppColors.appBlack,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Bildirim İzinleri',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appBlack,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              if (value) {
                _showNotificationConfirmDialog();
              } else {
                _disableNotifications();
              }
            },
            activeColor: AppColors.appGreen,
          ),
        ],
      ),
    );
  }

  /// Bildirim açma onay diyaloğunu gösterir
  void _showNotificationConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: AppColors.appGreen,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Bildirimleri Aç',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.appBlack,
              ),
            ),
          ],
        ),
        content: Text(
          'Uygulama bildirimleri açmak istediğinize emin misiniz? Öğün hatırlatmaları ve önemli güncellemeler için bildirim alacaksınız.',
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
              _requestNotificationPermission();
            },
            child: Text(
              'Bildirimleri Aç',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.appGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sistem bildirim iznini ister
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (mounted) {
      if (status.isGranted) {
        setState(() => _notificationsEnabled = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bildirimler başarıyla açıldı'),
            backgroundColor: AppColors.appGreen,
          ),
        );
      } else if (status.isPermanentlyDenied) {
        // Kullanıcı kalıcı olarak reddetti, ayarlara yönlendir
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bildirimleri açmak için uygulama ayarlarına gidin'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Ayarlar',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bildirim izni reddedildi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Bildirimleri kapatır
  void _disableNotifications() {
    setState(() => _notificationsEnabled = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bildirimler kapatıldı'),
        backgroundColor: Colors.grey.shade600,
      ),
    );
  }

  String _formatPhone(String phone) {
    // Eğer telefon +90 ile başlıyorsa formatla
    if (phone.startsWith('+90') && phone.length >= 13) {
      String number = phone.substring(3);
      return '+90 ${number.substring(0, 3)} ${number.substring(3, 6)} ${number.substring(6, 8)} ${number.substring(8)}';
    }
    // +90 yoksa ve 10 haneli ise
    if (phone.length >= 10) {
      return '+90 ${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6, 8)} ${phone.substring(8)}';
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

  /// Değişiklikleri API'ye kaydeder
  Future<void> _saveChanges() async {
    if (_userId == null || _token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oturum bilgileri bulunamadı'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _userService.updateUser(
        _userId!,
        _token!,
        _nameController.text,
        _surnameController.text,
        _phoneController.text,
        _emailController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Değişiklikler kaydedildi'),
          backgroundColor: AppColors.appGreen,
        ),
      );
    } catch (e) {
      debugPrint('Kullanıcı güncellenemedi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Değişiklikler kaydedilemedi'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
    context.go('/');
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
