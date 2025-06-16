
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/conversation/domain/entity/contact_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ContactRepository {
  Future<Either<BaseError, ContactEntity>> createContact(ContactEntity contactEntity);
  Future<Either<BaseError, List<ContactEntity>>> fetchContactsByUserId(String userId);
}