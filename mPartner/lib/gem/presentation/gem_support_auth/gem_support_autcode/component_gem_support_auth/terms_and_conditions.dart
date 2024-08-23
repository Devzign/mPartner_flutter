import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../../services/services_locator.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../utils/term_conditions/term_and_conditions_bloc.dart';

class TermsAndConditions extends StatefulWidget {

  Function(bool)isScrollToBottom;
  var dynamicPage;
  TermsAndConditions(this.dynamicPage,{required this.isScrollToBottom});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TermsAndConditions();
  }

}
class _TermsAndConditions extends State<TermsAndConditions>{
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
          double maxScroll = _controller.position.maxScrollExtent;
          double currentScroll = _controller.position.pixels;
          if(maxScroll==currentScroll){
            widget.isScrollToBottom(true);
          }
        });
  }


  @override
  Widget build(BuildContext context) {
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return BlocProvider(
      create: (context) => sl<TermsAndConditionsBloc>()..add(TermsAndCondtionsEvents(dynamicPage:widget.dynamicPage.toString())),
      child: BlocBuilder<TermsAndConditionsBloc, TermsAndConditionsState>(
        builder: (context, state) {
          return BlocConsumer<TermsAndConditionsBloc, TermsAndConditionsState>(
            listener: (context, state) {},

            builder: (context, state) {
              switch (state.gemstate) {
                case RequestState.loading:
                  return SizedBox(
                    height: 174,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  case RequestState.loaded:
                    return new Container(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        controller: _controller,
                      child:new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Container(
                            height: 40,
                            child: new Text(translation(context).termsAndConditons,style: GoogleFonts.poppins(color: AppColors.darkGrey, fontSize: 17 * textMultiplier, height: 21 / 14, fontWeight: FontWeight.w700,),),
                          ),
                          Divider(height: 1,),
                          new SizedBox(height: 20,),
                          // HtmlWidget(state.termsandCondtions!.data[0].tnc_Description,textStyle: TextStyle(fontSize: 14),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:state.termsandCondtions!.data
                                .map((data) => Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: data.tnc_Description.split('<p>').where((element) =>
                                element.trim().isNotEmpty).map((point) => Column(crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${point.trim().replaceAll(RegExp('</p>'), '')}',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.darkGreyText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ).toList(),
                              ),
                            ).toList(),
                          ),
                        ],
                      ),
                    ),width: MediaQuery.of(context).size.width,);
                    case RequestState.error:
                  return SizedBox(
                    height: 174,
                    child: Center(
                      child: Text(state.getCategoryTypeMessage.toString()),
                    ),
                  );
              }
            },
          );
        },
      ),
    );


  }

}