import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/conversation/presentation/widgets/user_item_widget.dart';
import 'package:base_bloc_3/features/dashboard/presentation/bloc/personal_information_bloc.dart';
import 'package:base_bloc_3/features/login/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';
import 'package:base_bloc_3/routes/app_routes.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PersonalInformationScreenState();
  }
}

class _PersonalInformationScreenState extends BaseState<
    PersonalInformationScreen,
    PersonalInformationEvent,
    PersonalInformationState,
    PersonalInformationBloc> {
  @override
  void initState() {
    super.initState();
    final authState = getIt<LoginBloc>().state;
    bloc.add(PersonalInformationEvent.loadUser(userId: authState.userId));
  }

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder((context, state) {
      final user = state.user;
      return BaseScaffold(
        body: (user != null) ? _buildBody(state, context) : const Center(),
      );
    });
  }

  Widget _buildBody(PersonalInformationState state, BuildContext context) {
    return Column(
      children: [
        _buildBackground(state.user!.avatarUrl),
        _buildUserInfoItem(state.user!),
        Expanded(
          child: _buildMenuItem(
            icon: Icons.logout,
            title: 'Log out',
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(
    String avatarUrl,
  ) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(avatarUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfoItem(UserEntity user) {
    return Container(
      color: Colors.white,
      child: buildUserItem2(
        context: context,
        user: user,
        onTap: () {},
        trailing: IconButton(
          onPressed: () {
            context.push(RouteName.editPersonalInformation);
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    final authBloc = getIt<LoginBloc>();
    return ListTile(
      leading: Stack(
        children: [
          Icon(
            icon,
            color: Colors.red,
            size: 24,
          ),
        ],
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
      onTap: () {
        authBloc.add(const LoginEvent.logout());
        context.go(
            RouteName.login,
        );
      },
    );
  }
}
