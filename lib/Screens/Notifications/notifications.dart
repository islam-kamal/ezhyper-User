import 'package:ezhyper/Bloc/Notification_Bloc/notification_bloc.dart';
import 'package:ezhyper/Model/NotificationsModel/notifications_model.dart';
import 'package:ezhyper/Model/NotificationsModel/notifications_model.dart' as notifiction_model;
import 'package:ezhyper/Screens/Favourites/youDontHaveFavouriteList.dart';

import 'package:ezhyper/Widgets/Shimmer/shimmer_notification.dart';
import 'package:ezhyper/Widgets/no_data/no_data.dart';
import 'package:ezhyper/Widgets/visitor_message.dart';
import 'package:ezhyper/fileExport.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}
class _NotificationsState extends State<Notifications> {

  @override
  void initState() {
    notificationBloc.add(GetAllNotificationEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return NetworkIndicator(
        child: PageContainer(
            child:  Scaffold(
      backgroundColor: whiteColor,
      body:(StaticData.vistor_value == 'visitor')
          ? VistorMessage() : Container(

        child: Column(
          children: [
            CustomAppBar(
              text: translator.translate("NOTIFICATIONS"),
            ),
          //  CustomHeader( headerText : "NOTIFICATIONS",),

            Expanded(child: buildBody())],
        ),
      ),




      /*CustomBottomNavigationBar2(isActiveIconInNotifications : true, onTapNotifications : false ,),*/





    )));
  }

  Widget buildBody() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: translator.currentLanguage == 'ar' ? TextDirection.rtl :TextDirection.ltr,
        child:Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(height * .05),
                topLeft: Radius.circular(height * .05)),
            color: backgroundColor),
        child: Container(
          child: listViewBuilderForNotifications()

        )  ));
  }


  Widget listViewBuilderForNotifications(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder(
      bloc: notificationBloc,
      builder: (context, state) {
        if (state is Loading) {
          return ShimmerNotification(

          );
        } else if (state is Done) {
          var data = state .model as NotificationsModel;
          if(data.data ==null){
            return NoData(
              message: data.msg,
            );
          }else {
            return StreamBuilder<NotificationsModel>(
                stream: notificationBloc.notifications_subject,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data.isEmpty) {
                      return NoData(
                        image: "assets/images/img_contactus.png",
                        title: translator.translate("Notifications"),
                        message: translator.translate(
                            "If you are facing any problem or if you have a suggestion, please contact us"),
                      );
                    } else {
                      return ListView.builder(

                          scrollDirection: Axis.vertical,

                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(margin: EdgeInsets.only(
                                bottom: height * .02),
                                child: singleNotificationCard(
                                  notifications: snapshot.data.data[index],
                                ));
                          });
                    }
                  } else {
                    return ShimmerNotification();
                  }
                });
          }

        } else if (state is ErrorLoading) {
          var data = state. model as NotificationsModel;
          return YouDontHaveFavourites(
            message: translator.translate("You Dont Have Any Notificaions"),
            image: 'assets/images/menu_notification.png',
          );
            return NoData(
              message: '${data.msg}',
            );
        }else{
          return Container();
        }
      },
    );

  }

  Widget singleNotificationCard ({notifiction_model.Data notifications}){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        FittedBox(
          child: Container( padding: EdgeInsets.only(left: width*.075,
        right: width*.075,top: height*.05,bottom: height*.05 ) ,
            width: width,decoration:
          BoxDecoration(color: whiteColor,borderRadius:
          BorderRadius.all(Radius.circular(height*.05)),),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                     child: Row(children: [MyText(text: notifications.title, size: height*.02,color: greenColor,)],)),

               ],
             ),
            Container(
              child: MyText(
                size: height * .018,
                align: TextAlign.start,
                text: notifications.message,
              ),
            ),
            Container(

                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  children:
                [MyText(text: notifications.createDates.createdAtHuman, size: height*.018,color: greyColor,)],)),
          ],
          ),),
        ),
      ],
    );
  }

  Widget redDotOverNotificationsIcon(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(width:height > width ?  width*.1 : width*.085,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width:  height > width ? width * .02 : width * .005,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red),padding: EdgeInsets.only(top: height*.06 ),
              ),
            ],
          ),
        ],
      ),
    ) ;
  }
}
