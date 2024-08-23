import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../services/services_locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/enums.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../../state/contoller/app_setting_value_controller.dart';
import '../base_screen.dart';
import 'bloc/user_profile_bloc.dart';
import 'components/logout_widget.dart';
import 'components/profile_info_widget.dart';

class UserProfileScreen extends StatefulWidget {
  final bool showBottomSheet;
  final ProfileBottomSheetType type;

  const UserProfileScreen(
      {super.key,
      this.showBottomSheet = false,
      this.type = ProfileBottomSheetType.none
      });

  @override
  State<UserProfileScreen> createState() => _UserProfileState();
}

class _UserProfileState extends BaseScreenState<UserProfileScreen> {
  AppSettingValueController appSettingValueController = Get.find();
  @override
  void initState() {
    appSettingValueController.fetchAppSettingValues(AppConstants.IsUserDeleteEnable);

    super.initState();

  }

  @override
  Widget baseBody(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          sl<UserProfileBloc>()..add(UserProfileInitialFetchEvent()),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          return WillPopScope(
              onWillPop: () async {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
                }
            return false;
          },
          child:Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(children: [
                  HeaderWidgetWithRightAlignActionButton(
                    text: translation(context).profile,
                    onBackPress: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
                      }
                    },
                    showCustomActionButton: true,
                    customActionButtonText: translation(context).logout,
                    customActionButtonIcon: Icons.logout,
                    rightPadding: 5,
                    onCustomActionButtonPress: () {
                      showLogoutBottomSheet(context);
                    },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: UserProfileInfoWidget(
                      showBottomSheet: widget.showBottomSheet,
                      type: widget.type,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          );
        },
      ),
    );
  }
}
