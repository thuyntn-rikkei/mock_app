import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/dialog/dialog_utils.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:base_bloc_3/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState
    extends BaseShareState<LoginPage, LoginEvent, LoginState, LoginBloc> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _obscurePassword = true;

  @override
  void listener(BuildContext context, LoginState state) {
    if (state.status == BaseStateStatus.failed) {
      if (state.message != null && state.message!.isNotEmpty) {
        DialogUtils.showDialog(content: state.message!);
      }
    }
    if (state.status == BaseStateStatus.loading) {
      DialogUtils.showLoading();
    } else {
      DialogUtils.hideLoading();
    }

    if (state.status == BaseStateStatus.success) {
      context.go(RouteName.home);
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
          child:  Column(
            children: [
              _buildWelcomeMessage(context),
              SizedBox(height: 30.h),
              _buildEmailField(),
              SizedBox(height: 10.h),
              _buildPasswordField(),
              SizedBox(height: 10.h),
              _buildForgotPasswordLink(),
              SizedBox(height: 30.h),
              _buildLoginButton(),
              _buildSignUpLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                S.current.app_name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          S.current.login,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: S.current.email,
        suffixIcon: const Icon(Icons.email_outlined),
      ),
      validator: Validators.emailValidator
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _controllerPassword,
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: S.current.password,
        suffixIcon: IconButton(
          onPressed: _togglePasswordVisibility,
          icon: _obscurePassword
              ? const Icon(Icons.visibility_outlined)
              : const Icon(Icons.visibility_off_outlined),
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

  Widget _buildForgotPasswordLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(S.current.forgot_password),
        )
      ],
    );
  }

  Widget _buildLoginButton() {
    return blocBuilder(
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              bloc.add(
                LoginEvent.login(
                  email: _controllerEmail.text,
                  password: _controllerPassword.text,
                ),
              );
            }
          },
          child: Text(S.current.login),
        );
      },
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.current.do_not_have_an_account),
        TextButton(
          onPressed: () async {
            _formKey.currentState?.reset();
            var data = await context.push(RouteName.register) as UserEntity?;
            _controllerEmail.text = data?.email ?? '';
            _controllerPassword.text = data?.password ?? '';
            print(data);
          },
          child: Text(S.current.signup),
        ),
      ],
    );
  }
}
