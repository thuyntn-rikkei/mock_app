import 'package:base_bloc_3/common/external_lib.dart';
import 'package:image_picker/image_picker.dart';

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
        Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
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
              Icons.camera_alt_outlined,
              color: Colors.blueAccent,
              size: 26,
            ),
          ),
        ),
        //input field & buttons
        Expanded(
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextField(
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
