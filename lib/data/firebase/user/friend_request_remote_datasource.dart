import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/user/friend_request_model.dart';
import 'package:firebase_database/firebase_database.dart';

@injectable
class FriendRequestRemoteDatasource {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get friendRequestRef =>
      _firebaseDatabase.ref('friendRequests/');

  Future<FriendRequestModel?> createFriendRequest(
    FriendRequestModel friendRequestModel,
  ) async {
    final newRef = friendRequestRef.push();

    final newFriendRequest =
        friendRequestModel.copyWith(friendRequestId: newRef.key);

    await newRef.set(newFriendRequest.toJson());

    return newFriendRequest;
  }

  Future<List<FriendRequestModel>> fetchFriendRequestsByUserId(
    String userId,
  ) async {
    final query1 = friendRequestRef.orderByChild('userId').equalTo(userId);
    final snapshot1 = await query1.once();

    final query2 =
        friendRequestRef.orderByChild('friendRequestUserId').equalTo(userId);
    final snapshot2 = await query2.once();

    final allData = <FriendRequestModel>[];

    if (snapshot1.snapshot.exists && snapshot1.snapshot.value is Map) {
      final data1 = snapshot1.snapshot.value as Map;
      allData.addAll(
        data1.values
            .whereType<Map<Object?, Object?>>()
            .map((e) => Map<String, dynamic>.from(e))
            .map(FriendRequestModel.fromJson),
      );
    }

    if (snapshot2.snapshot.exists && snapshot2.snapshot.value is Map) {
      final data2 = snapshot2.snapshot.value as Map;
      allData.addAll(
        data2.values
            .whereType<Map<Object?, Object?>>()
            .map((e) => Map<String, dynamic>.from(e))
            .map(FriendRequestModel.fromJson),
      );
    }

    final uniqueFriendRequests = {
      for (var friendRequest in allData)
        friendRequest.friendRequestId: friendRequest,
    }.values.toList();

    return uniqueFriendRequests;
  }
}
