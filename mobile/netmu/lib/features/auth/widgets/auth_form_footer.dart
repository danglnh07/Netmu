import 'package:flutter/cupertino.dart';

class AuthFormFooter extends StatelessWidget {
  final String text;
  final String urlText;
  final String url;

  const AuthFormFooter({
    super.key,
    required this.text,
    required this.url,
    required this.urlText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '$text ',
          style: const TextStyle(
            color: Color(0xFF7A7A9D),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, url);
                },
                child: Text(
                  urlText,
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
