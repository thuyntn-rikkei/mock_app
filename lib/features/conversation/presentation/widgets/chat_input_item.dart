import 'package:base_bloc_3/common/external_lib.dart';

Widget chatInput({
  required BuildContext context,
  required TextEditingController textController,
  required bool isUploading,
  required void Function(String message) onSend,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Row(
      children: [
        //input field & buttons
        Expanded(
          child: Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: 
                      TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {},
                        decoration: const InputDecoration(
                          hintText: 'Type Something...',
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                ),

                // //pick image from gallery button
                // IconButton(
                //     onPressed: () async {
                //       final ImagePicker picker = ImagePicker();
                //
                //       // Picking multiple images
                //       final List<XFile> images =
                //       await picker.pickMultiImage(imageQuality: 70);
                //
                //       // uploading & sending image one by one
                //       for (var i in images) {
                //         log('Image Path: ${i.path}');
                //         setState(() => _isUploading = true);
                //         await APIs.sendChatImage(widget.user, File(i.path));
                //         setState(() => _isUploading = false);
                //       }
                //     },
                //     icon: const Icon(Icons.image,
                //         color: Colors.blueAccent, size: 26)),
                //
                // //take image from camera button
                // IconButton(
                //     onPressed: () async {
                //       final ImagePicker picker = ImagePicker();
                //
                //       // Pick an image
                //       final XFile? image = await picker.pickImage(
                //           source: ImageSource.camera, imageQuality: 70);
                //       if (image != null) {
                //         log('Image Path: ${image.path}');
                //         setState(() => _isUploading = true);
                //
                //         await APIs.sendChatImage(
                //             widget.user, File(image.path));
                //         setState(() => _isUploading = false);
                //       }
                //     },
                //     icon: const Icon(Icons.camera_alt_rounded,
                //         color: Colors.blueAccent, size: 26)),

                //adding some space
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),

        //send message button
        MaterialButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              // if (_list.isEmpty) {
              //   //on first message (add user to my_user collection of chat user)
              //   APIs.sendFirstMessage(
              //       widget.user, _textController.text, Type.text);
              // } else {
              //   //simply send message
              //   APIs.sendMessage(
              //       widget.user, _textController.text, Type.text);
              // }
              onSend(textController.text);
              textController.text = '';
            }
          },
          minWidth: 0,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
          shape: const CircleBorder(),
          color: Colors.green,
          child: const Icon(Icons.send, color: Colors.white, size: 28),
        )
      ],
    ),
  );
}
