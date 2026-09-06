import 'package:flutter/material.dart';
import '../constants/mycolors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: (automaticallyImplyLeading && Navigator.canPop(context))
          ? Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(MyColors.textfieldBakground),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(MyColors.borderSubtle)),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Color(MyColors.textColor),
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            )
          : null,
      backgroundColor: const Color(MyColors.background),
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: const Color(MyColors.borderSubtle),
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
