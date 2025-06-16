import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/firebase/user/contact_remote_datasource.dart';
import 'package:base_bloc_3/data/model/user/contact_model.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:base_bloc_3/features/conversation/domain/repository/contact_repository.dart';
import 'package:base_bloc_3/generated/l10n.dart';

@Injectable(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDatasource _contactRemoteDatasource;
  ContactRepositoryImpl(this._contactRemoteDatasource);

  @override
  Future<Either<BaseError, ContactEntity>> createContact(ContactEntity contactEntity) async {
    try {
      final result = await _contactRemoteDatasource.createContact(ContactModel.fromEntity(contactEntity));
      if (result == null) {
        return left(BaseError.httpUnknownError(S.current.not_found));
      }
      return right(ContactEntity.fromModel(result));
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }

  @override
  Future<Either<BaseError, List<ContactEntity>>> fetchContactsByUserId(String userId) async {
    try {
      final result = await _contactRemoteDatasource.fetchContactsByUserId(userId);
      return right(result.map((e) => ContactEntity.fromModel(e)).toList());
    } on FirebaseException catch (exception) {
      return left(BaseError.httpUnknownError(exception.message ?? S.current.error_unknown));
    } catch (exception) {
      return left(BaseError.httpUnknownError(S.current.error_unknown));
    }
  }
}