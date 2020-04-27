import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instacop/src/helpers/TextStyle.dart';
import 'package:instacop/src/helpers/colors_constant.dart';
import 'package:instacop/src/helpers/screen.dart';
import 'package:instacop/src/helpers/shared_preferrence.dart';
import 'package:instacop/src/helpers/utils.dart';
import 'package:instacop/src/views/HomePage/Admin/ChartRevenue/chart_admin_view.dart';
import 'package:instacop/src/views/HomePage/Admin/OrderAndSold/sold_and_order_view.dart';
import 'package:instacop/src/widgets/box_dashboard.dart';
import 'package:instacop/src/widgets/card_dashboard.dart';

class AdminHomeView extends StatefulWidget {
  @override
  _AdminHomeViewState createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  String _userCount = '0';
  String _productCount = '0';
  String _orderCount = '0';
  String _soldCount = '0';
  String total = '0';
  loadNumberDashboard() {
    //TODO: User
    Firestore.instance.collection('Users').getDocuments().then((onValue) {
      setState(() {
        _userCount = onValue.documents.length.toString();
      });
    });
    //TODO:Order
    Firestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Pending')
        .getDocuments()
        .then((onValue) {
      setState(() {
        _orderCount = onValue.documents.length.toString();
      });
    });
    //TODO: Product
    Firestore.instance.collection('Products').getDocuments().then((onValue) {
      setState(() {
        _productCount = onValue.documents.length.toString();
      });
    });
    //TODO:Sold
    Firestore.instance
        .collection('Orders')
        .where('status', isLessThan: 'Pending')
        .getDocuments()
        .then((onValue) {
      setState(() {
        _soldCount = onValue.documents.length.toString();
      });
    });
    //TODO: Revenue
    Firestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Completed')
        .getDocuments()
        .then((document) {
      int revenue = 0;
      for (var order in document.documents) {
        int value = int.parse(order.data['total']);
        revenue += value;
      }
      setState(() {
        total = Util.intToMoneyType(revenue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadNumberDashboard();
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: kBoldTextStyle.copyWith(
              fontSize: FontSize.setTextSize(50), fontWeight: FontWeight.w900),
        ),
        centerTitle: false,
        backgroundColor: kColorWhite,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ConstScreen.setSizeWidth(30)),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: GestureDetector(
                  onTap: () {
                    StorageUtil.clear();
                    Navigator.pushNamedAndRemoveUntil(context, 'welcome_screen',
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Sign out',
                    style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.s30, color: kColorBlue),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.blueAccent.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: DashboardCard(
                title: 'Revenue',
                color: Colors.orange.shade500,
                icon: FontAwesomeIcons.dollarSign,
                value: '$total VND',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminChartView()));
                },
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(10),
            ),
            //TODO: Users and Order
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardBox(
                      title: 'Users',
                      color: kColorBlue,
                      icon: FontAwesomeIcons.users,
                      value: _userCount,
                      onPress: () {
                        Navigator.pushNamed(context, 'admin_user_manager');
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardBox(
                      title: 'Orders',
                      color: kColorBlue,
                      icon: FontAwesomeIcons.shoppingCart,
                      value: _orderCount,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SoldAndOrderView(
                                      title: 'Order List',
                                    )));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
            //TODO: Product and Sold
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardBox(
                      title: 'Product',
                      color: kColorBlue,
                      icon: FontAwesomeIcons.productHunt,
                      value: _productCount,
                      onPress: () {
                        Navigator.pushNamed(context, 'admin_home_product');
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardBox(
                      title: 'Sold',
                      color: kColorBlue,
                      icon: Icons.done_outline,
                      value: _soldCount,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SoldAndOrderView(
                                      title: 'Sold Order List',
                                    )));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
            //TODO: Edit Page
            Expanded(
              flex: 2,
              child: Container(),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(50),
            )
          ],
        ),
      ),
    );
  }
}
