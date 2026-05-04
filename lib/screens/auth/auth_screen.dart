import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignup = false;
  String _email = '';
  String _pw = '';
  String _name = '';
  bool _showPw = false;
  bool _agreed = false;
  String _err = '';

  bool get _validEmail => RegExp(r'\S+@\S+\.\S+').hasMatch(_email);
  bool get _validPw    => _pw.length >= 8;
  bool get _canSubmit  => _validEmail && _validPw && (!_isSignup || _agreed);

  void _submit() {
    if (!_validEmail) { setState(() => _err = '이메일 형식을 확인해 주세요.'); return; }
    if (!_validPw)    { setState(() => _err = '비밀번호는 8자 이상이어야 해요.'); return; }
    if (_isSignup && !_agreed) { setState(() => _err = '약관에 동의해 주세요.'); return; }
    // TODO Phase 6: Supabase auth 연결
  }

  void _social(String provider) {
    // TODO Phase 6: 소셜 OAuth 연결
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 24),
          Text(_isSignup ? '회원가입' : '로그인', style: AppTextStyles.headline(AppColors.ink)),
          const SizedBox(height: 8),
          Text(_isSignup ? '동네 산책을 기록하기 위해 계정을 만들어요.' : '다시 돌아오셨네요.',
            style: AppTextStyles.body(AppColors.ink)),
          const SizedBox(height: 24),
          _field('이메일', onChanged: (v) => setState(() { _email = v; _err = ''; }), keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 10),
          _pwField(),
          if (_isSignup) ...[
            const SizedBox(height: 10),
            _field('닉네임 (선택)', onChanged: (v) => setState(() => _name = v)),
            const SizedBox(height: 10),
            _agreeRow(),
          ],
          if (_err.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_err, style: AppTextStyles.label(Colors.red)),
          ],
          const SizedBox(height: 16),
          _SubmitButton(label: _isSignup ? '가입하고 시작하기' : '로그인', enabled: _canSubmit, onTap: _canSubmit ? _submit : null),
          if (!_isSignup) ...[
            const SizedBox(height: 8),
            Center(child: TextButton(onPressed: (){}, child: Text('비밀번호를 잊으셨나요?', style: AppTextStyles.label(AppColors.slate)))),
          ],
          const SizedBox(height: 20),
          _Divider(),
          const SizedBox(height: 20),
          _SocialButton(label: 'Apple로 계속', onTap: () => _social('apple')),
          const SizedBox(height: 10),
          _SocialButton(label: '구글로 계속', onTap: () => _social('google')),
          const SizedBox(height: 10),
          _SocialButton(label: '카카오로 계속', onTap: () => _social('kakao'), bgColor: const Color(0xFFFEE500)),
          const SizedBox(height: 24),
          Center(child: Wrap(alignment: WrapAlignment.center, children: [
            Text(_isSignup ? '이미 계정이 있나요?' : '처음이신가요?', style: AppTextStyles.body(AppColors.ink)),
            TextButton(
              onPressed: () => setState(() { _isSignup = !_isSignup; _err = ''; }),
              child: Text(_isSignup ? '로그인' : '회원가입', style: AppTextStyles.body(AppColors.copper)),
            ),
          ])),
        ]),
      )),
    );
  }

  Widget _field(String hint, {required ValueChanged<String> onChanged, TextInputType? keyboardType}) =>
    TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: AppTextStyles.body(AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body(AppColors.border),
        filled: true,
        fillColor: AppColors.paper2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border)),
      ),
    );

  Widget _pwField() => TextField(
    onChanged: (v) => setState(() { _pw = v; _err = ''; }),
    obscureText: !_showPw,
    style: AppTextStyles.body(AppColors.ink),
    decoration: InputDecoration(
      hintText: '비밀번호 (8자 이상)',
      hintStyle: AppTextStyles.body(AppColors.border),
      filled: true, fillColor: AppColors.paper2,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border)),
      suffixIcon: IconButton(icon: Icon(_showPw ? Icons.visibility_off : Icons.visibility, color: AppColors.border),
        onPressed: () => setState(() => _showPw = !_showPw)),
    ),
  );

  Widget _agreeRow() => Row(children: [
    Checkbox(value: _agreed, onChanged: (v) => setState(() => _agreed = v!), activeColor: AppColors.moss),
    Expanded(child: Text('서비스 이용약관 및 개인정보처리방침에 동의합니다.', style: AppTextStyles.label(AppColors.ink))),
  ]);
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  const _SubmitButton({required this.label, required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: enabled ? AppColors.ink : AppColors.border,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(label, style: AppTextStyles.body(AppColors.paper))),
    ),
  );
}

class _SocialButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? bgColor;
  const _SocialButton({required this.label, required this.onTap, this.bgColor});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.paper2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(child: Text(label, style: AppTextStyles.body(AppColors.ink))),
    ),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Divider(color: AppColors.border)),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('또는', style: AppTextStyles.label(AppColors.ink))),
    Expanded(child: Divider(color: AppColors.border)),
  ]);
}
