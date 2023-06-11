import 'package:app4hr/pages/position_page.dart';
import 'package:app4hr/utils/authentication.dart';
import 'package:app4hr/widgets/resume_popup.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';

import '../pages/admin/applications.dart';
import '../pages/admin/candidates.dart';
import '../pages/admin/home.dart';
import '../pages/admin/positions.dart';
import '../utils/navigation_functions.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late List<CollapsibleItem> _items;
  late String _headline;
  late Widget _page;

  @override
  void initState() {
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).text;
    _page = AdminHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.star),
            SizedBox(width: 4,),
            Text("App4HR"),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(context: context, builder: (ctx){
                return ResumeUploadPopup();
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async{
              await signOut();
              signOutGoogle();
              gotoLogin(context);
            },
          ),
        ],
      ),
      body: CollapsibleSidebar(
        isCollapsed: true,
        items: _items,
        collapseOnBodyTap: true,
        // avatarImg: _avatarImg,
        title: name ?? userEmail ?? "User",
        // onTitleTap: () {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Yay! Flutter Collapsible Sidebar!')));
        // },
        body: Container(
            padding: const EdgeInsets.only(left: 20.0,top: 20),
            child: _body(size, context)),
        backgroundColor: Colors.blue.shade900,
        selectedTextColor: Colors.limeAccent,
        textStyle: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        titleStyle: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        toggleTitleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        sidebarBoxShadow: const [
          BoxShadow(
            color: Colors.indigo,
            blurRadius: 20,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Colors.green,
            blurRadius: 50,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );
  }

  Widget _body(Size size, BuildContext context) {
    return _page;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Home',
        icon: Icons.assessment,
        onPressed: () => setState(() => _page = AdminHome()),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Home"))
        ),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Applications',
        icon: Icons.find_in_page,
        onPressed: () => setState(() => _page = Applications()),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Applications"))
        ),
        isSelected: false,
      ),
      CollapsibleItem(
        text: 'Positions',
        icon: Icons.person_search_rounded,
        onPressed: () => setState(() => _page = Positions()),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Positions"))
        ),
        isSelected: false,
      ),
      CollapsibleItem(
        text: 'Candidates',
        icon: Icons.people,
        onPressed: () => setState(() => _page = Candidates()),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Candidates"))
        ),
        isSelected: false,
      ),
    ];
  }

}
