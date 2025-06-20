import 'package:base_bloc_3/base/base_widget.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/utils/validators.dart';
import 'package:base_bloc_3/common/widgets/base_appbar.dart';
import 'package:base_bloc_3/common/widgets/base_scaffold.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/dashboard/presentation/bloc/edit_personal_information_bloc.dart';
import 'package:base_bloc_3/features/login/presentation/bloc/login_bloc.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';

class EditPersonalInformationScreen extends StatefulWidget {
  const EditPersonalInformationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditPersonalInformationScreenState();
  }
}

class _EditPersonalInformationScreenState extends BaseState<
    EditPersonalInformationScreen,
    EditPersonalInformationEvent,
    EditPersonalInformationState,
    EditPersonalInformationBloc> {
  final TextEditingController _controllerFullName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final authState = getIt<LoginBloc>().state;
    bloc.add(EditPersonalInformationEvent.loadUser(userId: authState.userId));
  }

  @override
  Widget renderUI(BuildContext context) {
    return blocBuilder((context, state) {
      _controllerFullName.text = bloc.state.user?.fullName ?? '';
      return BaseScaffold(
        appBar: _buildAppBar(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
            child: Column(
              children: [
                _buildAvatar(),
                SizedBox(height: 30.h),
                _buildFullNameField(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppBar() {
    return BaseAppBar(
      title: 'Edit Personal Information',
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
      hasBack: true,
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            bloc.state.user?.avatarUrl ?? '',
          ),
          radius: 56,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.indigo,
              child: IconButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();

                  final List<XFile> images =
                      await picker.pickMultiImage(imageQuality: 70);

                  for (var i in images) {
                    log('Image Path: ${i.path}');
                  }
                },
                icon: const Icon(
                  color: Colors.white,
                  Icons.camera_alt_sharp,
                  size: 20,
                ),
              ),
            ),
          ),
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
}
