import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/base/bloc/bloc_status.dart';
import 'package:base_bloc_3/common/dialog/dialog_utils.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/signup/bloc/signup_bloc.dart';
import 'package:base_bloc_3/generated/l10n.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState
    extends BaseState<SignupPage, SignupEvent, SignupState, SignupBloc> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerFullName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _obscurePassword = true;

  @override
  void listener(BuildContext context, SignupState state) {
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
      context.pop(
        state.user,
      );
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
          child: Column(
            children: [
              _buildWelcomeMessage(context),
              SizedBox(height: 30.h),
              _buildFullNameField(),
              SizedBox(height: 10.h),
              _buildEmailField(),
              SizedBox(height: 10.h),
              _buildPasswordField(),
              SizedBox(height: 30.h),
              _buildSignupButton(),
              SizedBox(height: 10.h),
              buildTermAndConditionCheckbox(context),
              SizedBox(height: 10.h),
              _buildLoginLink(context),
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
          S.current.signup,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _controllerFullName,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: S.current.fullName,
        suffixIcon: const Icon(Icons.person_outline_outlined),
      ),
      validator: Validators.fullNameValidator,
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
        validator: Validators.emailValidator);
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

  Widget _buildSignupButton() {
    return blocBuilder(
      (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: (state.isAgreeWithTerms == true)  ? onEnableSignupButton : null,
          child: Text(S.current.signup),
        );
      },
    );
  }

  VoidCallback get onEnableSignupButton => () {
    if (!mounted || bloc.isClosed) return;

    if(_formKey.currentState?.validate() == true) {
      bloc.add(
        SignupEvent.signup(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          fullName: _controllerFullName.text,
        ),
      );
    }
  };

  Widget buildTermAndConditionCheckbox(BuildContext context) {
    return blocBuilder((context, state) {
      return Row(
        children: [
          Checkbox(
            value: state.isAgreeWithTerms,
            onChanged: (value) {
              bloc.add(
                    SignupEvent.agreeWithTerms(
                      isAgreeWithTerms: value ?? false,
                    ),
                  );
            },
          ),
          Text(
            S.current.terms_and_conditions,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      );
    });
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.current.already_have_an_account),
        TextButton(
          onPressed: () {
            _formKey.currentState?.reset();
            context.pop();
          },
          child: Text(S.current.login),
        ),
      ],
    );
  }
}
