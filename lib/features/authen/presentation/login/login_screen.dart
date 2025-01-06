import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/import.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseShareState<LoginScreen, AuthEvent, AuthState, AuthBloc>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget renderUI(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: BaseScaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30.sp),
            child: Column(
              children: [
                _buildWelcomeMessage(context),
                SizedBox(height: 60.h),
                _buildUsernameField(),
                SizedBox(height: 10.h),
                _buildPasswordField(),
                SizedBox(height: 60.h),
                _buildLoginButton(),
                _buildSignUpLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 150),
        Text(
          S.current.welcome_back,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          S.current.login_to_your_account,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _controllerUsername,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: S.current.username,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onEditingComplete: () => _focusNodePassword.requestFocus(),
      validator: Validators.usernameValidator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _controllerPassword,
      focusNode: _focusNodePassword,
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: S.current.password,
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
          onPressed: _togglePasswordVisibility,
          icon: _obscurePassword
              ? const Icon(Icons.visibility_outlined)
              : const Icon(Icons.visibility_off_outlined),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: Validators.passwordValidator,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Tạo phương thức cho nút Login
  Widget _buildLoginButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoginSuccess) {
          context.go(RouteName.home);
        }
      },
      builder: (context, state) {
        if (state.status == BaseStateStatus.loading) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: _onLoginPressed,
          child: Text(S.current.login),
        );
      },
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      getIt<AuthBloc>().add(
        AuthEvent.onLoginEvent(
          request: LoginRequest(
            password: _controllerPassword.text,
            username: _controllerUsername.text,
          ),
        ),
      );
    }
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.current.do_not_have_an_account),
        TextButton(
          onPressed: () {
            _formKey.currentState?.reset();
            context.push(RouteName.register);
          },
          child: Text(S.current.signup),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
