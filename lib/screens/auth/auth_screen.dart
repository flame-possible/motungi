import 'package:flutter/material.dart';
import '../../theme/t.dart';
import '../../theme/app_text_styles.dart';

class AuthScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  final void Function(Map<String, dynamic>) onAuth;
  final VoidCallback onSignout;
  final VoidCallback onClose;

  const AuthScreen({
    super.key,
    this.user,
    required this.onAuth,
    required this.onSignout,
    required this.onClose,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignup = false;
  String _email = '';
  String _pw = '';
  String _name = '';
  bool _showPw = false;
  bool _agreed = false;
  String _err = '';

  bool get _validEmail => RegExp(r'\S+@\S+\.\S+').hasMatch(_email);
  bool get _validPw => _pw.length >= 8;
  bool get _canSubmit => _validEmail && _validPw && (!_isSignup || _agreed);

  void _submit() {
    if (!_validEmail) { setState(() => _err = '이메일 형식을 확인해 주세요.'); return; }
    if (!_validPw)    { setState(() => _err = '비밀번호는 8자 이상이어야 해요.'); return; }
    if (_isSignup && !_agreed) { setState(() => _err = '약관에 동의해 주세요.'); return; }
    // Simulate auth — real Supabase call goes here
    widget.onAuth({
      'name': _name.isNotEmpty ? _name : _email.split('@').first,
      'email': _email,
      'joinedAt': DateTime.now().toIso8601String().substring(0, 10),
    });
  }

  void _social(String provider) {
    // Placeholder — provider-specific OAuth flows go here
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        if (widget.user != null) {
          return _buildLoggedIn(t, widget.user!);
        }
        return _buildAuthForm(t);
      },
    );
  }

  Widget _buildLoggedIn(AppThemeTokens t, Map<String, dynamic> user) {
    final name = user['name'] as String? ?? '';
    final email = user['email'] as String? ?? '';
    final joinedAt = user['joinedAt'] as String? ?? '';
    final initial = name.isNotEmpty ? name.characters.first : '?';

    return Scaffold(
      backgroundColor: t.paper,
      body: SafeArea(
        child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              GestureDetector(
                onTap: widget.onClose,
                child: Row(children: [
                  Text('←', style: Ts.sans(16, FontWeight.w400, t.ink2)),
                  const SizedBox(width: 4),
                  Text('닫기', style: Ts.sans(14, FontWeight.w400, t.ink2)),
                ]),
              ),
              Expanded(
                child: Center(child: Text('계정', style: Ts.sans(15, FontWeight.w600, t.ink))),
              ),
              const SizedBox(width: 48),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const SizedBox(height: 32),
                // Avatar
                Container(
                  width: 84, height: 84,
                  decoration: BoxDecoration(color: t.copperL, shape: BoxShape.circle),
                  child: Center(
                    child: Text(initial, style: Ts.sans(36, FontWeight.w700, t.copperD)),
                  ),
                ),
                const SizedBox(height: 20),
                Text('$name님', style: Ts.serif(26, FontWeight.w700, t.ink)),
                const SizedBox(height: 6),
                Text(email, style: Ts.sans(13, FontWeight.w400, t.ink3)),
                if (joinedAt.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('$joinedAt부터 함께 걷는 중', style: Ts.sans(12, FontWeight.w400, t.ink3)),
                ],
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: t.ink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text('오늘로 돌아가기', style: Ts.sans(15, FontWeight.w600, t.paper)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: widget.onSignout,
                  child: Text('로그아웃', style: Ts.sans(13, FontWeight.w400, t.copper)),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildAuthForm(AppThemeTokens t) {
    return Scaffold(
      backgroundColor: t.paper,
      body: SafeArea(
        child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              GestureDetector(
                onTap: widget.onClose,
                child: Row(children: [
                  Text('←', style: Ts.sans(16, FontWeight.w400, t.ink2)),
                  const SizedBox(width: 4),
                  Text('닫기', style: Ts.sans(14, FontWeight.w400, t.ink2)),
                ]),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onClose,
                child: Row(children: [
                  Text('둘러보기', style: Ts.sans(13, FontWeight.w400, t.ink3)),
                  const SizedBox(width: 4),
                  Text('→', style: Ts.sans(13, FontWeight.w400, t.ink3)),
                ]),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand mark + name
                  Row(children: [
                    _buildBrandMark(t, 36),
                    const SizedBox(width: 10),
                    Text('모퉁이', style: Ts.serif(16, FontWeight.w700, t.ink2)),
                  ]),
                  const SizedBox(height: 28),
                  Text(
                    _isSignup ? '회원가입' : '로그인',
                    style: Ts.serif(28, FontWeight.w700, t.ink),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isSignup
                        ? '동네 산책을 기록하기 위해 계정을 만들어요.'
                        : '다시 돌아오셨네요. 반가워요.',
                    style: Ts.sans(14, FontWeight.w400, t.ink2),
                  ),
                  const SizedBox(height: 28),

                  // Email field
                  _buildField(
                    t: t,
                    hint: '이메일',
                    onChanged: (v) => setState(() { _email = v; _err = ''; }),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),

                  // Password field
                  _buildPwField(t),

                  if (_isSignup) ...[
                    const SizedBox(height: 10),
                    _buildField(
                      t: t,
                      hint: '닉네임 (선택)',
                      onChanged: (v) => setState(() => _name = v),
                    ),
                    const SizedBox(height: 12),
                    _buildAgreeRow(t),
                  ],

                  if (_err.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: t.copperL,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(_err, style: Ts.sans(13, FontWeight.w400, t.copperD)),
                    ),
                  ],
                  const SizedBox(height: 18),

                  // Submit
                  GestureDetector(
                    onTap: _canSubmit ? _submit : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _canSubmit ? t.ink : t.ruleSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          _isSignup ? '가입하고 시작하기' : '로그인',
                          style: Ts.sans(15, FontWeight.w600, _canSubmit ? t.paper : t.ink3),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Divider
                  Row(children: [
                    Expanded(child: Divider(color: t.ruleSoft)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('또는', style: Ts.sans(12, FontWeight.w400, t.ink3)),
                    ),
                    Expanded(child: Divider(color: t.ruleSoft)),
                  ]),
                  const SizedBox(height: 16),

                  // Social login
                  _buildSocialButton(t, label: 'Apple로 계속', onTap: () => _social('apple')),
                  const SizedBox(height: 10),
                  _buildSocialButton(t, label: '구글로 계속', onTap: () => _social('google')),
                  const SizedBox(height: 10),
                  _buildSocialButton(
                    t,
                    label: '카카오로 계속',
                    onTap: () => _social('kakao'),
                    bgColor: const Color(0xFFFEE500),
                    textColor: const Color(0xFF3C1E1E),
                  ),

                  const SizedBox(height: 24),
                  // Toggle login/signup
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _isSignup ? '이미 계정이 있나요?' : '계정이 없으신가요?',
                          style: Ts.sans(14, FontWeight.w400, t.ink2),
                        ),
                        GestureDetector(
                          onTap: () => setState(() { _isSignup = !_isSignup; _err = ''; }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Text(
                              _isSignup ? '로그인' : '가입하기',
                              style: Ts.sans(14, FontWeight.w400, t.copper),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildBrandMark(AppThemeTokens t, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: t.paper2,
        border: Border.all(color: t.ruleSoft, width: 0.8),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Align(
        alignment: const Alignment(0.4, 0.4),
        child: Container(
          width: size * 0.14, height: size * 0.14,
          decoration: BoxDecoration(
            color: t.moss,
            borderRadius: BorderRadius.circular(size * 0.04),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required AppThemeTokens t,
    required String hint,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: Ts.sans(14, FontWeight.w400, t.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Ts.sans(14, FontWeight.w400, t.ink3),
        filled: true,
        fillColor: t.paper2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.rule, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.rule, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.ink2, width: 1),
        ),
      ),
    );
  }

  Widget _buildPwField(AppThemeTokens t) {
    return TextField(
      onChanged: (v) => setState(() { _pw = v; _err = ''; }),
      obscureText: !_showPw,
      style: Ts.sans(14, FontWeight.w400, t.ink),
      decoration: InputDecoration(
        hintText: '비밀번호 (8자 이상)',
        hintStyle: Ts.sans(14, FontWeight.w400, t.ink3),
        filled: true,
        fillColor: t.paper2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.rule, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.rule, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.ink2, width: 1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _showPw ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: t.ink3,
            size: 18,
          ),
          onPressed: () => setState(() => _showPw = !_showPw),
        ),
      ),
    );
  }

  Widget _buildAgreeRow(AppThemeTokens t) {
    return Row(children: [
      Checkbox(
        value: _agreed,
        onChanged: (v) => setState(() => _agreed = v ?? false),
        activeColor: t.moss,
        side: BorderSide(color: t.rule),
      ),
      Expanded(
        child: Text(
          '서비스 이용약관 및 개인정보처리방침에 동의합니다.',
          style: Ts.sans(13, FontWeight.w400, t.ink2),
        ),
      ),
    ]);
  }

  Widget _buildSocialButton(
    AppThemeTokens t, {
    required String label,
    required VoidCallback onTap,
    Color? bgColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor ?? t.paper2,
          border: Border.all(color: t.rule, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(label, style: Ts.sans(14, FontWeight.w400, textColor ?? t.ink)),
        ),
      ),
    );
  }
}
