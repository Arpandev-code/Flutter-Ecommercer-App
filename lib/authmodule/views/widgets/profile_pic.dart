import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final VoidCallback press;
  const ProfilePic({
    super.key,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 90,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage:
                NetworkImage("https://i.postimg.cc/0jqKB6mS/Profile-Image.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 40,
              width: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: press,
                child: const Icon(Icons.camera_alt_outlined),
              ),
            ),
          )
        ],
      ),
    );
  }
}
